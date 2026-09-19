// Renders GitHub/VitePress-style admonition blockquotes:
//
//   > [!Note] Optional title
//   > Body text...
//
//   > [!Important]
//   > Body text on its own line(s)...
//
// VitePress has built-in support for this syntax; plain markdown-it does
// not, so without this rule these blocks render as a literal blockquote
// containing the raw "[!Note] ..." text. This core rule finds such
// blockquotes and rewrites them into a styled callout: the blockquote gets
// `md-alert md-alert-<kind>` classes, and the "[!Kind] Title" marker is
// replaced with a bold label line (falling back to the capitalized kind
// name when no title text follows the marker).

const KIND_LABELS = {
  note: 'Note',
  tip: 'Tip',
  important: 'Important',
  warning: 'Warning',
  caution: 'Caution',
};

const MARKER_RE = /^\[!(Note|Tip|Important|Warning|Caution)\]\s*(.*)$/i;

export function admonitionPlugin(md) {
  md.core.ruler.push('admonition', (state) => {
    const { tokens, Token } = state;

    for (let i = 0; i < tokens.length; i++) {
      if (tokens[i].type !== 'blockquote_open') continue;

      // Expect: blockquote_open, paragraph_open, inline, paragraph_close, ...
      const paragraphOpen = tokens[i + 1];
      const inline = tokens[i + 2];
      if (
        !paragraphOpen ||
        paragraphOpen.type !== 'paragraph_open' ||
        !inline ||
        inline.type !== 'inline' ||
        !inline.children ||
        inline.children.length === 0
      ) {
        continue;
      }

      const firstChild = inline.children[0];
      if (firstChild.type !== 'text') continue;

      const match = firstChild.content.match(MARKER_RE);
      if (!match) continue;

      const kind = match[1].toLowerCase();
      let titleText = match[2].trim();

      // Consume the marker (and the trailing softbreak that ends the
      // marker's line, if the title line isn't the only content) from the
      // inline token's children, replacing them with a bold title line.
      const children = inline.children;
      let consumeUpTo = 1; // always drop the marker text token itself
      if (children[1] && children[1].type === 'softbreak') {
        consumeUpTo = 2; // also drop the line break right after the marker
      }
      const remainingChildren = children.slice(consumeUpTo);

      if (!titleText) titleText = KIND_LABELS[kind] || match[1];

      const strongOpen = new Token('strong_open', 'strong', 1);
      const titleTextToken = new Token('text', '', 0);
      titleTextToken.content = titleText;
      const strongClose = new Token('strong_close', 'strong', -1);

      const newChildren = [strongOpen, titleTextToken, strongClose];
      if (remainingChildren.length > 0) {
        const lineBreak = new Token('html_inline', '', 0);
        lineBreak.content = '<br class="md-alert-break" />';
        newChildren.push(lineBreak, ...remainingChildren);
      }

      inline.children = newChildren;

      const existingClass = tokens[i].attrGet('class');
      const newClass = [existingClass, 'md-alert', `md-alert-${kind}`]
        .filter(Boolean)
        .join(' ');
      tokens[i].attrSet('class', newClass);
    }
  });
}
