// Shared markdown-it rule that turns prose mentions like "Lemma 2.8" or
// "Definition 1.0" into hoverable cross-reference links, mirroring
// docs/.vitepress/term-autolink.mts used by the VitePress site. Kept as a
// plain JS/CommonJS-free ESM module so the publish script can run under
// plain Node without a build step.

const TERM_MENTION_RE = /\b(Lemma|Definition)\s+(\d+)\.(\d+)\b/gi;

const KIND_INFO = {
  lemma: { prefix: 'lemma', refClass: 'lemma-ref' },
  definition: { prefix: 'definition', refClass: 'definition-ref' },
};

/**
 * Registered last (via `ruler.push`) so it runs after `markdown-it-attrs`
 * has already consumed `{...}` attribute syntax and assigned ids to the
 * preceding block tokens (e.g. `paragraph_open`).
 */
export function termAutolinkPlugin(md) {
  md.core.ruler.push('term_autolink', (state) => {
    const { tokens, Token } = state;

    for (let i = 0; i < tokens.length; i++) {
      const inlineToken = tokens[i];
      if (inlineToken.type !== 'inline' || !inlineToken.children) continue;

      const ownerToken = tokens[i - 1];
      const selfId = ownerToken && ownerToken.attrGet ? ownerToken.attrGet('id') : null;

      const children = inlineToken.children;
      const nextChildren = [];

      for (const child of children) {
        if (child.type !== 'text' || !child.content) {
          nextChildren.push(child);
          continue;
        }

        TERM_MENTION_RE.lastIndex = 0;
        if (!TERM_MENTION_RE.test(child.content)) {
          nextChildren.push(child);
          continue;
        }

        TERM_MENTION_RE.lastIndex = 0;
        let lastIndex = 0;
        let match;

        while ((match = TERM_MENTION_RE.exec(child.content))) {
          const [full, keyword, major, minor] = match;
          const kind = KIND_INFO[keyword.toLowerCase()];
          const id = `${kind.prefix}-${major}-${minor}`;

          if (match.index > lastIndex) {
            const textToken = new Token('text', '', 0);
            textToken.content = child.content.slice(lastIndex, match.index);
            nextChildren.push(textToken);
          }

          if (id === selfId) {
            const textToken = new Token('text', '', 0);
            textToken.content = full;
            nextChildren.push(textToken);
          } else {
            const openToken = new Token('html_inline', '', 0);
            openToken.content = `<a href="#${id}" class="${kind.refClass}" data-term-id="${id}">`;

            const textToken = new Token('text', '', 0);
            textToken.content = full;

            const closeToken = new Token('html_inline', '', 0);
            closeToken.content = '</a>';

            nextChildren.push(openToken, textToken, closeToken);
          }

          lastIndex = match.index + full.length;
        }

        if (lastIndex < child.content.length) {
          const textToken = new Token('text', '', 0);
          textToken.content = child.content.slice(lastIndex);
          nextChildren.push(textToken);
        }
      }

      inlineToken.children = nextChildren;
    }
  });
}
