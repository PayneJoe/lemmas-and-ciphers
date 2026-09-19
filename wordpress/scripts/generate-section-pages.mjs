#!/usr/bin/env node
// Creates/updates the "Mathematics", "Cryptography", and "Formal
// Verification" WordPress Pages, each listing only links to that
// section's submodule categories (e.g. under Mathematics: "Linear
// Algebra", "Math of Proof") - not post content. This is what the top
// nav's section entries should point to, so visitors see a short list of
// submodules to pick from instead of a flat dump of every post.
//
// Usage:
//   node scripts/generate-section-pages.mjs
//
// Re-run whenever a new submodule folder (docs/<category>/<submodule>/)
// is published for the first time, so its link shows up here. Safe to
// re-run any time - it updates the same Page by slug instead of creating
// duplicates.
//
// Reads WordPress connection details from wordpress/.env (see
// .env.example): WP_URL, WP_USER, WP_APP_PASSWORD.

import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const SCRIPTS_DIR = path.dirname(fileURLToPath(import.meta.url));
const WORDPRESS_DIR = path.dirname(SCRIPTS_DIR);

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

if (!WP_URL || !WP_USER || !WP_APP_PASSWORD) {
  console.error('Missing WP_URL/WP_USER/WP_APP_PASSWORD. Copy wordpress/.env.example to wordpress/.env and fill it in.');
  process.exit(1);
}

function authHeader() {
  const token = Buffer.from(`${WP_USER}:${WP_APP_PASSWORD}`).toString('base64');
  return `Basic ${token}`;
}

// Order matches the desired nav order.
const SECTION_NAMES = ['Mathematics', 'Cryptography', 'Formal Verification'];

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function slugify(name) {
  return name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
}

async function fetchAllCategories() {
  const res = await fetch(`${WP_URL}/wp-json/wp/v2/categories?per_page=100`, {
    headers: { Authorization: authHeader() },
  });
  if (!res.ok) {
    throw new Error(`Failed to fetch categories: ${res.status} ${await res.text()}`);
  }
  return res.json();
}

function buildPageHtml(sectionName, childCategories) {
  const lines = [`<p class="lemmas-section-intro">Notes in this section are grouped by submodule:</p>`];
  if (childCategories.length === 0) {
    lines.push('<p class="lemmas-section-empty">More notes coming soon.</p>');
  } else {
    lines.push('<ul class="lemmas-section-links">');
    for (const cat of childCategories) {
      lines.push(`  <li><a href="${cat.link}">${escapeHtml(cat.name)}</a></li>`);
    }
    lines.push('</ul>');
  }
  return lines.join('\n');
}

async function findPageBySlug(slug) {
  const res = await fetch(`${WP_URL}/wp-json/wp/v2/pages?slug=${encodeURIComponent(slug)}`, {
    headers: { Authorization: authHeader() },
  });
  if (!res.ok) return null;
  const found = await res.json();
  return found[0] || null;
}

async function upsertPage(title, html) {
  const slug = slugify(title);
  const existing = await findPageBySlug(slug);
  const body = {
    title,
    slug,
    content: `<!-- wp:html -->\n${html}\n<!-- /wp:html -->`,
    status: 'publish',
  };
  const url = existing
    ? `${WP_URL}/wp-json/wp/v2/pages/${existing.id}`
    : `${WP_URL}/wp-json/wp/v2/pages`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: authHeader(),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  if (!res.ok) {
    throw new Error(`Page upsert failed for "${title}": ${res.status} ${await res.text()}`);
  }
  return res.json();
}

async function main() {
  const categories = await fetchAllCategories();
  const byName = new Map(categories.map((c) => [c.name, c]));

  for (const sectionName of SECTION_NAMES) {
    const parent = byName.get(sectionName);
    const children = parent
      ? categories
          .filter((c) => c.parent === parent.id)
          .sort((a, b) => a.name.localeCompare(b.name))
      : [];

    console.log(`\n${sectionName}: ${children.length ? children.map((c) => c.name).join(', ') : '(no submodules yet)'}`);

    const html = buildPageHtml(sectionName, children);
    const result = await upsertPage(sectionName, html);
    console.log(`  Page #${result.id}: ${result.link}`);
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
