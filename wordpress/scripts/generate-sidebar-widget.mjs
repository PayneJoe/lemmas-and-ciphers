#!/usr/bin/env node
// Generates the "Custom HTML" sidebar navigation widget snippet for the
// lemmas-and-ciphers WordPress site, grouping published posts by category
// (Mathematics / Cryptography / Formal Verification).
//
// Usage:
//   node scripts/generate-sidebar-widget.mjs
//
// Prints ready-to-paste HTML to stdout. Paste it into:
//   wp-admin -> Appearance -> Widgets -> Primary Widget Area
//     -> add a "Custom HTML" widget -> paste the output as its content.
//
// Re-run and re-paste whenever notes are added/removed so the sidebar
// stays in sync. Styling for `.lemmas-sidebar-nav` lives in
// wordpress/plugin/additional.css (WordPress Additional CSS panel).

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

if (!WP_URL) {
  console.error('Missing WP_URL. Copy wordpress/.env.example to wordpress/.env and fill it in.');
  process.exit(1);
}

function authHeader() {
  const token = Buffer.from(`${WP_USER}:${WP_APP_PASSWORD}`).toString('base64');
  return `Basic ${token}`;
}

// Order matches the desired nav order: Mathematics, Cryptography,
// Formal Verification.
const CATEGORY_NAMES = ['Mathematics', 'Cryptography', 'Formal Verification'];

function escapeHtml(str) {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

async function fetchCategory(name) {
  const res = await fetch(`${WP_URL}/wp-json/wp/v2/categories?search=${encodeURIComponent(name)}`, {
    headers: WP_APP_PASSWORD ? { Authorization: authHeader() } : {},
  });
  if (!res.ok) return null;
  const found = await res.json();
  return found.find((c) => c.name === name) || null;
}

async function fetchPostsForCategory(categoryId) {
  const res = await fetch(
    `${WP_URL}/wp-json/wp/v2/posts?categories=${categoryId}&per_page=50&_fields=id,title,link,date`,
    { headers: WP_APP_PASSWORD ? { Authorization: authHeader() } : {} }
  );
  if (!res.ok) return [];
  const posts = await res.json();
  // Oldest first, matching typical chapter/reading order.
  return posts.sort((a, b) => new Date(a.date) - new Date(b.date));
}

async function main() {
  const lines = ['<nav class="lemmas-sidebar-nav">'];

  for (const name of CATEGORY_NAMES) {
    const category = await fetchCategory(name);
    lines.push(`  <h4>${escapeHtml(name)}</h4>`);
    if (!category) {
      lines.push('  <p class="lemmas-sidebar-empty">No notes yet.</p>');
      continue;
    }
    const posts = await fetchPostsForCategory(category.id);
    if (posts.length === 0) {
      lines.push('  <p class="lemmas-sidebar-empty">No notes yet.</p>');
      continue;
    }
    lines.push('  <ul>');
    for (const post of posts) {
      // post.title.rendered is already HTML-entity-encoded by the WP API;
      // re-escaping it would double-encode entities like "&#8211;".
      lines.push(`    <li><a href="${post.link}">${post.title.rendered}</a></li>`);
    }
    lines.push('  </ul>');
  }

  lines.push('</nav>');
  console.log(lines.join('\n'));
}

main();
