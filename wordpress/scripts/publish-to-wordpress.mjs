#!/usr/bin/env node
// Markdown -> WordPress publisher for Lemmas & Ciphers notes.
//
// Usage:
//   node scripts/publish-to-wordpress.mjs <markdown-file> [<markdown-file> ...]
//
// Reads WordPress connection details from environment variables (see
// .env.example): WP_URL, WP_USER, WP_APP_PASSWORD.
//
// For each Markdown file:
//   1. Extracts a title (first H1) and body.
//   2. Protects `$...$` / `$$...$$` math spans from Markdown's emphasis
//      parsing (so `$u_1$` doesn't get mangled into `$u<em>1$</em>`),
//      restoring the raw LaTeX after rendering so a client-side MathJax/
//      KaTeX WordPress plugin can render it.
//   3. Renders Markdown -> HTML with markdown-it + markdown-it-attrs +
//      the same term-autolink rule used by the VitePress site, so
//      "Lemma X.Y" / "Definition X.Y" mentions become hoverable
//      cross-reference links matching the lemmas-hover-tooltip plugin.
//   4. Uploads any local images referenced via relative paths to the
//      WordPress media library and rewrites their `src` to the uploaded
//      URL.
//   5. Publishes (or updates, if already published before) the resulting
//      HTML as a WordPress post via the REST API, using Application
//      Password Basic Auth.
//   6. Records the Markdown-file -> WordPress-post-ID mapping in
//      post-mapping.json so re-running this script updates the existing
//      post instead of creating a duplicate.

import { readFile, writeFile } from 'node:fs/promises';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import process from 'node:process';
import MarkdownIt from 'markdown-it';
import markdownItAttrs from 'markdown-it-attrs';
import { termAutolinkPlugin } from './term-autolink.mjs';

const SCRIPTS_DIR = path.dirname(fileURLToPath(import.meta.url));
const WORDPRESS_DIR = path.dirname(SCRIPTS_DIR);
const MAPPING_PATH = path.join(WORDPRESS_DIR, 'post-mapping.json');

function loadEnvFile() {
  const envPath = path.join(WORDPRESS_DIR, '.env');
  if (!existsSync(envPath)) return;
  const raw = readFileSync(envPath, 'utf8');
  for (const line of raw.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eq = trimmed.indexOf('=');
    if (eq === -1) continue;
    const key = trimmed.slice(0, eq).trim();
    let value = trimmed.slice(eq + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    if (!(key in process.env)) process.env[key] = value;
  }
}

loadEnvFile();

const WP_URL = (process.env.WP_URL || '').replace(/\/+$/, '');
const WP_USER = process.env.WP_USER || '';
const WP_APP_PASSWORD = process.env.WP_APP_PASSWORD || '';

function assertConfigured() {
  const missing = [];
  if (!WP_URL) missing.push('WP_URL');
  if (!WP_USER) missing.push('WP_USER');
  if (!WP_APP_PASSWORD) missing.push('WP_APP_PASSWORD');
  if (missing.length) {
    console.error(
      `Missing required config: ${missing.join(', ')}.\n` +
        'Copy wordpress/.env.example to wordpress/.env and fill in your WordPress site URL,\n' +
        'username, and an Application Password (Users -> Profile -> Application Passwords).'
    );
    process.exit(1);
  }
}

function authHeader() {
  const token = Buffer.from(`${WP_USER}:${WP_APP_PASSWORD}`).toString('base64');
  return `Basic ${token}`;
}

async function loadMapping() {
  if (!existsSync(MAPPING_PATH)) return {};
  const raw = await readFile(MAPPING_PATH, 'utf8');
  return raw.trim() ? JSON.parse(raw) : {};
}

async function saveMapping(mapping) {
  await writeFile(MAPPING_PATH, JSON.stringify(mapping, null, 2) + '\n', 'utf8');
}

// --- Math protection -------------------------------------------------
//
// Markdown-it's emphasis rule treats `_` and `*` as formatting markers, so
// raw LaTeX like `$u_1 + u_2$` gets corrupted. We swap math spans out for
// placeholder tokens before rendering and restore the original LaTeX
// afterwards.

const MATH_PATTERNS = [
  /\$\$[\s\S]+?\$\$/g, // $$ ... $$ (block)
  /\\\[[\s\S]+?\\\]/g, // \[ ... \] (block)
  /\\\([\s\S]+?\\\)/g, // \( ... \) (inline)
  /\$(?!\s)(?:[^$\n]|\\\$)+?(?<!\s)\$/g, // $ ... $ (inline, no leading/trailing space)
];

function protectMath(markdown) {
  const stash = [];
  let protectedText = markdown;
  for (const pattern of MATH_PATTERNS) {
    protectedText = protectedText.replace(pattern, (match) => {
      const token = `@@MATH_${stash.length}@@`;
      stash.push(match);
      return token;
    });
  }
  return { protectedText, stash };
}

function restoreMath(html, stash) {
  return html.replace(/@@MATH_(\d+)@@/g, (_, index) => stash[Number(index)]);
}

// --- Markdown rendering ------------------------------------------------

function buildRenderer() {
  const md = new MarkdownIt({ html: true, linkify: true });
  md.use(markdownItAttrs);
  md.use(termAutolinkPlugin);
  return md;
}

function extractTitle(markdown) {
  const match = markdown.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : null;
}

// --- Image upload --------------------------------------------------------

async function uploadImage(localPath) {
  const buffer = await readFile(localPath);
  const filename = path.basename(localPath);
  const ext = path.extname(filename).toLowerCase();
  const mimeTypes = { '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.gif': 'image/gif', '.svg': 'image/svg+xml' };
  const mime = mimeTypes[ext] || 'application/octet-stream';

  const res = await fetch(`${WP_URL}/wp-json/wp/v2/media`, {
    method: 'POST',
    headers: {
      Authorization: authHeader(),
      'Content-Type': mime,
      'Content-Disposition': `attachment; filename="${filename}"`,
    },
    body: buffer,
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Image upload failed for ${localPath}: ${res.status} ${text}`);
  }

  const json = await res.json();
  return json.source_url;
}

async function resolveAndUploadImages(markdown, markdownFilePath) {
  const noteDir = path.dirname(markdownFilePath);
  const imageRe = /!\[([^\]]*)\]\((\.\/[^)\s]+|[^)\s:]+\.(?:png|jpe?g|gif|svg))\)/gi;
  const uploaded = new Map();
  let match;
  const matches = [];
  while ((match = imageRe.exec(markdown))) {
    matches.push(match);
  }

  let result = markdown;
  for (const m of matches) {
    const [full, alt, relPath] = m;
    if (/^https?:\/\//i.test(relPath)) continue; // already remote
    if (uploaded.has(relPath)) continue;
    const localPath = path.resolve(noteDir, relPath);
    if (!existsSync(localPath)) {
      console.warn(`  ! image not found on disk, skipping upload: ${localPath}`);
      continue;
    }
    console.log(`  uploading image: ${relPath}`);
    const url = await uploadImage(localPath);
    uploaded.set(relPath, url);
    result = result.split(full).join(`![${alt}](${url})`);
  }
  return result;
}

// --- WordPress post publish/update --------------------------------------

async function publishPost({ title, html, existingPostId }) {
  const body = {
    title,
    content: `<!-- wp:html -->\n${html}\n<!-- /wp:html -->`,
    status: 'publish',
  };

  const url = existingPostId
    ? `${WP_URL}/wp-json/wp/v2/posts/${existingPostId}`
    : `${WP_URL}/wp-json/wp/v2/posts`;

  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: authHeader(),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`WordPress publish failed: ${res.status} ${text}`);
  }

  return res.json();
}

// --- Main ----------------------------------------------------------------

async function processFile(filePath, mapping, md) {
  console.log(`\nProcessing ${filePath}`);
  const absPath = path.resolve(filePath);
  let markdown = await readFile(absPath, 'utf8');

  const title = extractTitle(markdown) || path.basename(filePath, '.md');
  // Drop the leading H1 since WordPress renders the post title separately.
  markdown = markdown.replace(/^#\s+.+\n?/m, '');

  markdown = await resolveAndUploadImages(markdown, absPath);

  const { protectedText, stash } = protectMath(markdown);
  let html = md.render(protectedText);
  html = restoreMath(html, stash);

  const mappingKey = path.relative(process.cwd(), absPath);
  const existingPostId = mapping[mappingKey]?.postId;

  const result = await publishPost({ title, html, existingPostId });
  mapping[mappingKey] = { postId: result.id, link: result.link };

  console.log(`  ${existingPostId ? 'Updated' : 'Created'} post #${result.id}: ${result.link}`);
}

async function main() {
  assertConfigured();

  const files = process.argv.slice(2);
  if (files.length === 0) {
    console.error('Usage: node scripts/publish-to-wordpress.mjs <markdown-file> [<markdown-file> ...]');
    process.exit(1);
  }

  const md = buildRenderer();
  const mapping = await loadMapping();

  for (const file of files) {
    try {
      await processFile(file, mapping, md);
    } catch (err) {
      console.error(`  ERROR processing ${file}:`, err.message);
    }
  }

  await saveMapping(mapping);
}

main();
