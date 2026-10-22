export const MERGED_NOTE = '../docs/cryptography/complexity-of-lattice-problems/complexity-of-lattice-problems.md';
export const MERGED_SLUG = 'complexity-of-lattice-problems';
export const RETIRED_NOTES = [
  '../docs/cryptography/complexity-of-lattice-problems/basics.md',
  '../docs/cryptography/complexity-of-lattice-problems/approximation-algorithms.md',
];

export function resolveNoteLinks(markdown, absPath, mapping, cwd) {
  return markdown.replace(/(?<!!)\[([^\]]+)\]\(([^)\s]+\.md)(#[^)\s]*)?\)/g,
    (full, label, target, anchor = '') => {
      if (/^[a-z]+:/i.test(target) || target.startsWith('/')) return full;
      const key = path.relative(cwd, path.resolve(path.dirname(absPath), target));
      const post = mapping[key];
      if (!post) throw new Error(`No published WordPress mapping for linked note: ${target}`);
      return `[${label}](${post.link}${anchor})`;
    });
}

export async function wordpressRequest(url, options = {}, fetchImpl = fetch) {
  let response;
  try {
    response = await fetchImpl(url, {
      ...options,
      signal: options.signal ?? AbortSignal.timeout(60_000),
    });
  } catch (error) {
    // Log transport codes, not URLs, headers, or response bodies containing credentials.
    const code = error.cause?.code ?? error.name;
    throw new Error(`WordPress ${options.method ?? 'GET'} request failed (${code}). Check host connectivity and rerun the workflow.`, { cause: error });
  }
  if (!response.ok) {
    throw new Error(`WordPress ${options.method ?? 'GET'} request returned HTTP ${response.status}.`);
  }
  return response;
}

export async function retireMergedNotes(mapping, request, save) {
  if (!mapping[MERGED_NOTE]?.postId) {
    throw new Error('Cannot retire old chapters before the merged post is published.');
  }
  for (const key of RETIRED_NOTES) {
    const old = mapping[key];
    if (!old) continue;
    if (old.postId === mapping[MERGED_NOTE].postId) {
      throw new Error('Refusing to trash the merged post: old and new post IDs match.');
    }
    const post = await (await request(`/posts/${old.postId}?context=edit`)).json();
    if (post.status !== 'trash') {
      await request(`/posts/${old.postId}`, { method: 'DELETE' });
    }
    delete mapping[key];
    await save(mapping);
  }
}
import path from 'node:path';
