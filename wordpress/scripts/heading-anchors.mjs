// markdown-it plugin: assigns `id` attributes to headings (h1-h6) using the
// same GitHub-style slug algorithm used by VitePress/GitHub-flavored
// Markdown renderers, so hand-written Table-of-Contents links like
// `[Sum of Subspaces](#sum-of-subspaces)` resolve correctly. Plain
// markdown-it has no built-in heading-id support, so without this rule
// those TOC links are dead on WordPress even though they work on the
// VitePress site (which generates matching slugs automatically).
import GithubSlugger from 'github-slugger';

export function headingAnchorsPlugin(md) {
  md.core.ruler.push('heading_anchors', (state) => {
    const slugger = new GithubSlugger();
    const tokens = state.tokens;
    for (let i = 0; i < tokens.length; i++) {
      const token = tokens[i];
      if (token.type !== 'heading_open') continue;
      const inline = tokens[i + 1];
      if (!inline || inline.type !== 'inline') continue;
      const text = inline.children
        .filter((child) => child.type === 'text' || child.type === 'code_inline')
        .map((child) => child.content)
        .join('');
      if (!text) continue;
      const slug = slugger.slug(text);
      token.attrSet('id', slug);
    }
  });
}
