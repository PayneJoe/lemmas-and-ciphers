import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';
import MarkdownIt from 'markdown-it';
import attrs from 'markdown-it-attrs';
import { headingAnchorsPlugin } from '../scripts/heading-anchors.mjs';
import { termAutolinkPlugin } from '../scripts/term-autolink.mjs';

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
  const html = new MarkdownIt({ html: true })
    .use(attrs).use(termAutolinkPlugin).use(headingAnchorsPlugin).render(source);
  const ids = [...html.matchAll(/\bid="([^"]+)"/g)].map((match) => match[1]);
  assert.equal(new Set(ids).size, ids.length, 'Duplicate IDs in combined chapter');
  const links = [...html.matchAll(/href="#([^"]+)"/g)].map((match) => match[1]);
  assert.ok(links.length >= 19);
  for (const target of links) assert.ok(ids.includes(target), `Missing anchor ${target}`);
});
