import { execFileSync, spawnSync } from 'node:child_process';
import { existsSync, realpathSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const WORDPRESS_DIR = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

export function changedNotes(repo, before, after) {
  if (!before || !after) throw new Error('Both BEFORE and AFTER commit refs are required.');
  const resolve = (ref) => execFileSync('git', ['rev-parse', '--verify', '--end-of-options', `${ref}^{commit}`], {
    cwd: repo, encoding: 'utf8',
  }).trim();
  const head = resolve(after);
  const base = /^0+$/.test(before)
    ? execFileSync('git', ['hash-object', '-t', 'tree', '--stdin'], {
      cwd: repo, input: '', encoding: 'utf8',
    }).trim()
    : resolve(before);
  return execFileSync('git', [
    'diff', '--name-only', '-z', '--no-renames', '--diff-filter=AM',
    base, head, '--', 'docs/**/*.md',
  ], { cwd: repo, encoding: 'utf8' }).split('\0').filter(Boolean);
}

function main() {
  const repo = path.dirname(WORDPRESS_DIR);
  const files = changedNotes(repo, process.env.BEFORE, process.env.AFTER)
    .filter((file) => existsSync(path.join(repo, file)));
  if (!files.length) {
    console.log('No added or modified notes to publish.');
    return;
  }
  const result = spawnSync(process.execPath, [
    path.join(WORDPRESS_DIR, 'scripts/publish-to-wordpress.mjs'),
    ...files.map((file) => path.relative(WORDPRESS_DIR, path.join(repo, file))),
  ], { cwd: WORDPRESS_DIR, stdio: 'inherit' });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error('Note publishing failed; section refresh skipped.');
  const sections = spawnSync(process.execPath, [
    path.join(WORDPRESS_DIR, 'scripts/generate-section-pages.mjs'),
  ], { cwd: WORDPRESS_DIR, stdio: 'inherit' });
  if (sections.error) throw sections.error;
  if (sections.status !== 0) throw new Error('Section-page refresh failed.');
}

if (process.argv[1] && realpathSync(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    main();
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
