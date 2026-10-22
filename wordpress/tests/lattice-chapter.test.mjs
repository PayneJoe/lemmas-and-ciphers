import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';
import { renderNote } from '../scripts/publish-to-wordpress.mjs';

const folder = fileURLToPath(new URL('../../docs/cryptography/complexity-of-lattice-problems/', import.meta.url));
const source = readFileSync(path.join(folder, 'complexity-of-lattice-problems.md'), 'utf8');

test('the merged chapter replaces both sources and retains local image references', () => {
  assert.equal(existsSync(path.join(folder, 'basics.md')), false);
  assert.equal(existsSync(path.join(folder, 'approximation-algorithms.md')), false);
  assert.equal((source.match(/^# /gm) ?? []).length, 1);
  for (const image of source.matchAll(/!\[[^\]]*\]\(([^)]+)\)/g)) {
    assert.ok(existsSync(path.resolve(folder, image[1])), image[1]);
  }
  for (const section of [
    '## Basics', '## Solving SVP in Dimension 2', '## Approximating SVP in Dimension n',
    '## Approximating CVP in Dimension n', '### Gauss Running Time Analysis',
    '### LLL Running Time Analysis',
  ]) {
    assert.ok(source.includes(section), section);
  }
});

test('combined TOC and hover references resolve to unique WordPress anchors', () => {
  const { html } = renderNote(source);
  const ids = [...html.matchAll(/\bid="([^"]+)"/g)].map((match) => match[1]);
  assert.equal(new Set(ids).size, ids.length, 'Duplicate IDs in combined chapter');
  const links = [...html.matchAll(/href="#([^"]+)"/g)].map((match) => match[1]);
  assert.ok(links.length >= 19);
  for (const target of links) assert.ok(ids.includes(target), `Missing anchor ${target}`);
});

test('every chapter figure fits its container without changing aspect ratio', () => {
  const { html } = renderNote(source);
  const images = [...html.matchAll(/<img\b[^>]*>/g)].map((match) => match[0]);
  assert.equal(images.length, [...source.matchAll(/!\[[^\]]*\]\([^)]+\)/g)].length);
  assert.ok(images.length > 0);
  for (const image of images) {
    assert.match(image, /style="[^"]*max-width:100%;width:auto;height:auto;box-sizing:border-box;/);
    assert.match(image, /alt="[^"]+"/);
  }
  assert.match(html, /<table[^>]*style="table-layout:fixed;width:100%;max-width:100%;"/);
});

test('image styles preserve authored attributes and leave text tables alone', () => {
  const { html } = renderNote('![Figure](figure.png){width=1200 height=600}\n\n| Text |\n| --- |\n| Value |\n');
  assert.match(html, /width="1200"/);
  assert.match(html, /height="600"/);
  assert.match(html, /max-width:100%;width:auto;height:auto;/);
  assert.match(html, /<table>/);
  assert.doesNotMatch(html, /table-layout:fixed/);
});
