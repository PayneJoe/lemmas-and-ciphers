import type MarkdownIt from 'markdown-it'

// Matches prose mentions like "lemma 2.8" or "Lemma 12.3" so they can be
// turned into hoverable cross-reference links without changing how notes
// are authored.
const LEMMA_MENTION_RE = /\b([Ll]emma)\s+(\d+)\.(\d+)\b/g

/**
 * A small markdown-it core rule that finds "Lemma X.Y" mentions in rendered
 * prose and wraps them in `<a href="#lemma-X-Y" class="lemma-ref">`, so a
 * companion client-side script can show the referenced lemma's content in a
 * hover/focus tooltip. Definitions are anchored separately via the
 * `{#lemma-X-Y .lemma-anchor}` attribute syntax already supported by
 * VitePress's bundled `markdown-it-attrs`.
 *
 * Registered last (via `ruler.push`) so it runs after `markdown-it-attrs`
 * has already consumed `{...}` attribute syntax and assigned `id`s to the
 * preceding block tokens.
 */
export function lemmaAutolinkPlugin(md: MarkdownIt): void {
  md.core.ruler.push('lemma_autolink', (state) => {
    const { tokens, Token } = state

    for (let i = 0; i < tokens.length; i++) {
      const inlineToken = tokens[i]
      if (inlineToken.type !== 'inline' || !inlineToken.children) continue

      // The block token immediately preceding an `inline` token is always
      // its own opening tag (e.g. `paragraph_open`). If that block carries
      // the anchor id for the lemma this text belongs to, skip auto-linking
      // that exact match so a lemma's own title doesn't link to itself.
      const ownerToken = tokens[i - 1]
      const selfId = ownerToken?.attrGet ? ownerToken.attrGet('id') : null

      const children = inlineToken.children
      const nextChildren: typeof children = []

      for (const child of children) {
        if (child.type !== 'text' || !child.content) {
          nextChildren.push(child)
          continue
        }

        LEMMA_MENTION_RE.lastIndex = 0
        if (!LEMMA_MENTION_RE.test(child.content)) {
          nextChildren.push(child)
          continue
        }

        LEMMA_MENTION_RE.lastIndex = 0
        let lastIndex = 0
        let match: RegExpExecArray | null

        while ((match = LEMMA_MENTION_RE.exec(child.content))) {
          const [full, , major, minor] = match
          const id = `lemma-${major}-${minor}`

          if (match.index > lastIndex) {
            const textToken = new Token('text', '', 0)
            textToken.content = child.content.slice(lastIndex, match.index)
            nextChildren.push(textToken)
          }

          if (id === selfId) {
            const textToken = new Token('text', '', 0)
            textToken.content = full
            nextChildren.push(textToken)
          } else {
            const openToken = new Token('html_inline', '', 0)
            openToken.content = `<a href="#${id}" class="lemma-ref" data-lemma-id="${major}-${minor}">`

            const textToken = new Token('text', '', 0)
            textToken.content = full

            const closeToken = new Token('html_inline', '', 0)
            closeToken.content = '</a>'

            nextChildren.push(openToken, textToken, closeToken)
          }

          lastIndex = match.index + full.length
        }

        if (lastIndex < child.content.length) {
          const textToken = new Token('text', '', 0)
          textToken.content = child.content.slice(lastIndex)
          nextChildren.push(textToken)
        }
      }

      inlineToken.children = nextChildren
    }
  })
}
