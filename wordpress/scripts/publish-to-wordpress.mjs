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
import { admonitionPlugin } from './admonition.mjs';
import { headingAnchorsPlugin } from './heading-anchors.mjs';

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
  md.use(admonitionPlugin);
  md.use(headingAnchorsPlugin);
  return md;
}

function extractTitle(markdown) {
  const match = markdown.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : null;
}

// --- Table of contents styling --------------------------------------------
//
// Notes commonly start with a hand-written `<details><summary>Table of
// Contents</summary>...</details>` block linking to heading anchors. Tag it
// with a class so it can be floated as a sticky sidebar box (see
// plugin/additional.css .post-toc rules) instead of sitting inline at the
// top of the post, which is more convenient to navigate for long notes.

function markTableOfContents(html) {
  return html.replace(
    /<details>(\s*<summary>(?:<strong>)?\s*Table of Contents\b[\s\S]*?<\/details>)/i,
    // `open` so the floating sidebar TOC is visible immediately (still
    // collapsible by clicking the summary, for readers who want it hidden).
    (full, rest) => `<details class="post-toc" open>${rest}`
  );
}

// --- Home-page teaser (<!--more--> + manual excerpt) ----------------------
//
// Twenty Ten's home-page loop calls the_content() (full post body), while
// its category/archive loop calls the_excerpt(). Without a manual excerpt
// or a `<!--more-->` marker, the home page therefore shows every post in
// full, and the auto-generated excerpt is just the first 55 words of raw
// HTML (which today means garbled Table-of-Contents text). Fix both by
// finding the same "teaser" cut point - the 2nd paragraph-level block
// (<p>/<ul>/<ol>/<blockquote>) after the TOC - and (a) inserting a
// `<!--more-->` marker there so the_content() truncates with a "Continue
// reading" link on the home page (full content still shows on the single
// post page - this is standard, built-in WordPress behavior), and (b)
// deriving a plain-text excerpt from that same window for the_excerpt().

const TEASER_BLOCK_RE = /<\/(p|ul|ol|blockquote)>/gi;

function findTeaserCutIndex(html, blockCount = 2) {
  const tocEnd = html.search(/<\/details>/i);
  const searchStart = tocEnd === -1 ? 0 : tocEnd + '</details>'.length;
  TEASER_BLOCK_RE.lastIndex = searchStart;
  let count = 0;
  let match;
  while ((match = TEASER_BLOCK_RE.exec(html))) {
    count += 1;
    if (count >= blockCount) {
      return match.index + match[0].length;
    }
  }
  return -1; // post is too short to need truncation
}

function insertReadMoreMarker(html) {
  const cutIndex = findTeaserCutIndex(html);
  if (cutIndex === -1) return html;
  return `${html.slice(0, cutIndex)}\n<!--more-->\n${html.slice(cutIndex)}`;
}

function excerptFromHtml(html, maxWords = 50) {
  const cutIndex = findTeaserCutIndex(html);
  const teaserHtml = cutIndex === -1 ? html : html.slice(0, cutIndex);
  const tocStripped = teaserHtml.replace(/<details[^>]*>[\s\S]*?<\/details>/i, ' ');
  const text = tocStripped
    .replace(/<[^>]+>/g, ' ')
    .replace(/&hellip;/g, '...')
    .replace(/&[a-z#0-9]+;/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim();
  const words = text.split(' ');
  if (words.length <= maxWords) return text;
  return `${words.slice(0, maxWords).join(' ')}\u2026`;
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

// --- Category resolution --------------------------------------------------
//
// Maps a note's folder (relative to docs/) to a two-level WordPress
// category: a parent category ("Mathematics" / "Cryptography" / "Formal
// Verification") and, when the note lives in a submodule subfolder
// (docs/<category>/<submodule>/...), a child category for that submodule
// (e.g. "Linear Algebra", "Math of Proof"). Posts are tagged with the
// child category when one exists, so each submodule's archive page
// naturally lists just its own posts. Deeper folders (e.g. chapter
// subfolders under a submodule) are ignored for categorization - they're
// just organizational, not their own category.

const FOLDER_TO_CATEGORY = {
  mathematics: 'Mathematics',
  cryptography: 'Cryptography',
  'formal-verification': 'Formal Verification',
};

// Small words stay lowercase when title-casing a folder name, matching
// natural section titles like "Math of Proof" / "Mathlib in Lean".
const TITLE_CASE_LOWERCASE_WORDS = new Set(['of', 'in', 'and', 'the', 'a', 'on', 'to', 'for', 'vs', 'is']);

function humanizeFolderName(folder) {
  return folder
    .split('-')
    .map((word, i) => {
      const lower = word.toLowerCase();
      if (i > 0 && TITLE_CASE_LOWERCASE_WORDS.has(lower)) return lower;
      return lower.charAt(0).toUpperCase() + lower.slice(1);
    })
    .join(' ');
}

function resolveCategoryPathForFile(absPath) {
  const parts = absPath.split(path.sep);
  const docsIndex = parts.lastIndexOf('docs');
  if (docsIndex === -1 || docsIndex + 1 >= parts.length) return null;
  const parentName = FOLDER_TO_CATEGORY[parts[docsIndex + 1]];
  if (!parentName) return null;
  // docs/<category>/<submodule>/.../file.md needs at least 3 segments
  // after "docs" (category, submodule, file) for a submodule to exist.
  const hasSubmodule = parts.length - docsIndex >= 4;
  const childName = hasSubmodule ? humanizeFolderName(parts[docsIndex + 2]) : null;
  return { parentName, childName };
}

const categoryIdCache = new Map();

async function getOrCreateCategoryId(name, parentId) {
  const cacheKey = `${parentId || 0}:${name}`;
  if (categoryIdCache.has(cacheKey)) return categoryIdCache.get(cacheKey);

  const searchRes = await fetch(
    `${WP_URL}/wp-json/wp/v2/categories?search=${encodeURIComponent(name)}`,
    { headers: { Authorization: authHeader() } }
  );
  if (searchRes.ok) {
    const found = await searchRes.json();
    const exact = found.find((c) => c.name === name && (!parentId || c.parent === parentId));
    if (exact) {
      categoryIdCache.set(cacheKey, exact.id);
      return exact.id;
    }
  }

  const createBody = { name };
  if (parentId) createBody.parent = parentId;

  const createRes = await fetch(`${WP_URL}/wp-json/wp/v2/categories`, {
    method: 'POST',
    headers: {
      Authorization: authHeader(),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(createBody),
  });
  if (!createRes.ok) {
    const text = await createRes.text();
    throw new Error(`Category creation failed for "${name}": ${createRes.status} ${text}`);
  }
  const created = await createRes.json();
  categoryIdCache.set(cacheKey, created.id);
  return created.id;
}

// --- WordPress post publish/update --------------------------------------

async function publishPost({ title, html, existingPostId, categoryIds, excerpt }) {
  const body = {
    title,
    content: `<!-- wp:html -->\n${html}\n<!-- /wp:html -->`,
    status: 'publish',
  };
  if (categoryIds && categoryIds.length) {
    body.categories = categoryIds;
  }
  if (excerpt) {
    body.excerpt = excerpt;
  }

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
  html = markTableOfContents(html);
  const excerpt = excerptFromHtml(html);
  html = insertReadMoreMarker(html);

  const mappingKey = path.relative(process.cwd(), absPath);
  const existingPostId = mapping[mappingKey]?.postId;

  const categoryPath = resolveCategoryPathForFile(absPath);
  let categoryIds;
  if (categoryPath) {
    const parentId = await getOrCreateCategoryId(categoryPath.parentName);
    if (categoryPath.childName) {
      const childId = await getOrCreateCategoryId(categoryPath.childName, parentId);
      console.log(`  category: ${categoryPath.parentName} > ${categoryPath.childName}`);
      categoryIds = [childId];
    } else {
      console.log(`  category: ${categoryPath.parentName}`);
      categoryIds = [parentId];
    }
  }

  const result = await publishPost({ title, html, existingPostId, categoryIds, excerpt });
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
