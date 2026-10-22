import assert from 'node:assert/strict';
import { execFile, execFileSync } from 'node:child_process';
import { cpSync, mkdtempSync, mkdirSync, readFileSync, symlinkSync, writeFileSync, rmSync } from 'node:fs';
import { createServer } from 'node:http';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';
import { promisify } from 'node:util';
import { changedNotes } from '../scripts/publish-changed-notes.mjs';
import {
  MERGED_NOTE, RETIRED_NOTES, retireMergedNotes, resolveNoteLinks, wordpressRequest,
} from '../scripts/publishing-state.mjs';

test('request failures expose transport codes, not credentials, and do not retry writes', async () => {
  let calls = 0;
  await assert.rejects(
    wordpressRequest('https://example.test', { method: 'POST' }, async () => {
      calls++;
      throw new TypeError('sensitive diagnostic', { cause: { code: 'ECONNRESET' } });
    }),
    (error) => error.message.includes('ECONNRESET') && !error.message.includes('sensitive'),
  );
  assert.equal(calls, 1);
  await assert.rejects(
    wordpressRequest('https://example.test', {}, async () => new Response('private', { status: 401 })),
    /HTTP 401/,
  );
});

test('old posts cannot be retired without a published replacement', async () => {
  await assert.rejects(retireMergedNotes({}, () => assert.fail('No request expected'), () => {}),
    /before the merged post/);
});

test('migration trashes only the two mapped posts and is idempotent', async () => {
  const mapping = {
    [MERGED_NOTE]: { postId: 200 },
    [RETIRED_NOTES[0]]: { postId: 140 },
    [RETIRED_NOTES[1]]: { postId: 136 },
    unrelated: { postId: 42 },
  };
  const calls = [];
  const snapshots = [];
  const request = async (route, options = {}) => {
    calls.push([route, options.method ?? 'GET']);
    return Response.json({ status: 'publish' });
  };
  const save = async (state) => snapshots.push(structuredClone(state));
  await retireMergedNotes(mapping, request, save);
  assert.equal(snapshots.length, 2);
  assert.deepEqual(calls.filter(([, method]) => method === 'DELETE'),
    [['/posts/140', 'DELETE'], ['/posts/136', 'DELETE']]);
  assert.equal(mapping.unrelated.postId, 42);
  assert.equal(mapping[MERGED_NOTE].postId, 200);
  await retireMergedNotes(mapping, () => assert.fail('Already migrated'), save);
});

test('interrupted migration preserves state and resumes a post already in trash', async () => {
  const mapping = {
    [MERGED_NOTE]: { postId: 200 },
    [RETIRED_NOTES[0]]: { postId: 140 },
    [RETIRED_NOTES[1]]: { postId: 136 },
  };
  let saved;
  await assert.rejects(retireMergedNotes(mapping, async (route) => {
    if (route.includes('136')) throw new Error('connection lost');
    return Response.json({ status: 'publish' });
  }, async (state) => { saved = structuredClone(state); }), /connection lost/);
  assert.equal(saved[RETIRED_NOTES[0]], undefined);
  assert.equal(saved[RETIRED_NOTES[1]].postId, 136);
  await retireMergedNotes(saved, async (_route, options = {}) => {
    assert.notEqual(options.method, 'DELETE');
    return Response.json({ status: 'trash' });
  }, async () => {});
  assert.equal(saved[RETIRED_NOTES[1]], undefined);
});

test('migration refuses to delete the replacement post', async () => {
  await assert.rejects(retireMergedNotes({
    [MERGED_NOTE]: { postId: 200 }, [RETIRED_NOTES[0]]: { postId: 200 },
  }, () => assert.fail('No request expected'), () => {}), /IDs match/);
});

test('selection spans all pushed commits, handles spaces and excludes deleted notes', () => {
  const repo = mkdtempSync(path.join(os.tmpdir(), 'notes-selection-'));
  const git = (...args) => execFileSync('git', args, { cwd: repo, encoding: 'utf8' }).trim();
  const commit = () => {
    git('add', '.');
    git('-c', 'user.name=Test', '-c', 'user.email=test@example.test', 'commit', '-qm', 'fixture');
    return git('rev-parse', 'HEAD');
  };
  try {
    git('init', '-q');
    mkdirSync(path.join(repo, 'docs/topic'), { recursive: true });
    writeFileSync(path.join(repo, 'docs/topic/old.md'), 'Old');
    const before = commit();
    writeFileSync(path.join(repo, 'docs/topic/first note.md'), 'First');
    commit();
    rmSync(path.join(repo, 'docs/topic/old.md'));
    writeFileSync(path.join(repo, 'docs/topic/second.md'), 'Second');
    const after = commit();
    assert.deepEqual(changedNotes(repo, before, after),
      ['docs/topic/first note.md', 'docs/topic/second.md']);
    assert.deepEqual(changedNotes(repo, after, after), []);
    assert.deepEqual(changedNotes(repo, '0'.repeat(40), after),
      ['docs/topic/first note.md', 'docs/topic/second.md']);
    assert.throws(() => changedNotes(repo, '', after), /required/);
  } finally {
    rmSync(repo, { recursive: true });
  }
});

test('relative chapter links use the published WordPress URL', () => {
  const cwd = '/repo/wordpress';
  const file = '/repo/docs/cryptography/complexity-of-lattice-problems/index.md';
  const mapping = { [MERGED_NOTE]: { postId: 200, link: 'https://example.test/combined/' } };
  assert.equal(resolveNoteLinks('[Chapter](./complexity-of-lattice-problems.md#basics)', file, mapping, cwd),
    '[Chapter](https://example.test/combined/#basics)');
  assert.throws(() => resolveNoteLinks('[Missing](./absent.md)', file, mapping, cwd), /No published/);
});

test('publisher reports failures, recovers a lost create response, and retires posts only after success', async () => {
  const root = mkdtempSync(path.join(os.tmpdir(), 'notes-publish-'));
  const wp = path.join(root, 'wordpress');
  mkdirSync(wp);
  cpSync(fileURLToPath(new URL('../scripts', import.meta.url)), path.join(wp, 'scripts'), { recursive: true });
  symlinkSync(fileURLToPath(new URL('../node_modules', import.meta.url)), path.join(wp, 'node_modules'), 'dir');
  const note = path.resolve(wp, MERGED_NOTE);
  mkdirSync(path.dirname(note), { recursive: true });
  writeFileSync(note, '# Complexity of Lattice Problems\n\n## Basics\n\nCombined content.\n');
  const mappingPath = path.join(wp, 'post-mapping.json');
  writeFileSync(mappingPath, JSON.stringify({
    [RETIRED_NOTES[0]]: { postId: 140 }, [RETIRED_NOTES[1]]: { postId: 136 },
  }));
  const calls = [];
  let created = false;
  let failSecondDelete = true;
  const server = createServer(async (request, response) => {
    calls.push([request.method, request.url]);
    const route = request.url.replace('/wp-json/wp/v2', '');
    let body = '';
    for await (const chunk of request) body += chunk;
    const json = (value, status = 200) => {
      response.writeHead(status, { 'Content-Type': 'application/json' });
      response.end(JSON.stringify(value));
    };
    if (route.startsWith('/categories?')) return json([{ id: 10, name: 'Cryptography', parent: 0 }, {
      id: 11, name: 'Complexity of Lattice Problems', parent: 10,
    }]);
    if (route.startsWith('/posts?slug=')) return json(created ? [{ id: 200 }] : []);
    if (route === '/posts' && request.method === 'POST') {
      assert.equal(JSON.parse(body).slug, 'complexity-of-lattice-problems');
      created = true;
      request.socket.destroy(); // The server committed, but the client never received its ID.
      return;
    }
    if (route === '/posts/200' && request.method === 'POST') {
      return json({ id: 200, link: 'https://example.test/combined/' });
    }
    if (route.startsWith('/posts/') && request.method === 'GET') return json({ status: 'publish' });
    if (route === '/posts/136' && request.method === 'DELETE' && failSecondDelete) {
      failSecondDelete = false;
      return json({}, 503);
    }
    if (request.method === 'DELETE') return json({ trashed: true });
    json({}, 404);
  });
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const run = (file) => promisify(execFile)(process.execPath, [
    path.join(wp, 'scripts/publish-to-wordpress.mjs'), file,
  ], { cwd: wp, env: {
    ...process.env, WP_URL: `http://127.0.0.1:${server.address().port}`,
    WP_USER: 'test', WP_APP_PASSWORD: 'test',
  } });
  try {
    await assert.rejects(run('missing-note-for-test.md'),
      (error) => error.code === 1 && /ERROR processing/.test(error.stderr));
    assert.equal(calls.length, 0);
    await assert.rejects(run(MERGED_NOTE),
      (error) => error.code === 1 && /request failed/.test(error.stderr));
    assert.equal(calls.filter(([method]) => method === 'DELETE').length, 0);
    await assert.rejects(run(MERGED_NOTE),
      (error) => error.code === 1 && /HTTP 503/.test(error.stderr));
    const partial = JSON.parse(readFileSync(mappingPath, 'utf8'));
    assert.equal(partial[MERGED_NOTE].postId, 200);
    assert.equal(partial[RETIRED_NOTES[0]], undefined);
    assert.equal(partial[RETIRED_NOTES[1]].postId, 136);
    await run(MERGED_NOTE);
    const complete = JSON.parse(readFileSync(mappingPath, 'utf8'));
    assert.deepEqual(Object.keys(complete), [MERGED_NOTE]);
    assert.equal(calls.filter(([method, url]) => method === 'POST' && url === '/wp-json/wp/v2/posts').length, 1);
  } finally {
    await new Promise((resolve) => server.close(resolve));
    rmSync(root, { recursive: true });
  }
});
