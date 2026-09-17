// Client-only hover/focus/tap preview for `.lemma-ref` / `.definition-ref`
// cross-references.
//
// A reference link (produced by the `termAutolinkPlugin` markdown-it rule)
// points to `#lemma-<id>` or `#definition-<id>`, the anchor added to a
// lemma's/definition's title paragraph via `{#lemma-<id> .lemma-anchor}` or
// `{#definition-<id> .definition-anchor}`. On hover/focus/click we look up
// that anchor on the *current* page, clone its content (the title,
// statement, and — for lemmas — the collapsed proof) up to the next `<br>`
// separator, and show it in a floating box near the reference.
//
// Math inside the cloned content is already static markup (MathJax renders
// to SVG/CommonHTML at build time), so no re-rendering is needed.

const TOOLTIP_CLASS = 'lemma-tooltip'
const REF_SELECTOR = '.lemma-ref, .definition-ref'

let tooltipEl: HTMLElement | null = null
let pinned = false
let hideTimer: ReturnType<typeof setTimeout> | undefined
let bound = false

function clearHideTimer() {
  if (hideTimer !== undefined) {
    clearTimeout(hideTimer)
    hideTimer = undefined
  }
}

function scheduleHide(delay = 150) {
  clearHideTimer()
  hideTimer = setTimeout(() => {
    if (!pinned) hide()
  }, delay)
}

function hide() {
  pinned = false
  if (tooltipEl) tooltipEl.style.display = 'none'
}

function ensureTooltip(): HTMLElement {
  if (tooltipEl) return tooltipEl

  const el = document.createElement('div')
  el.className = TOOLTIP_CLASS
  el.setAttribute('role', 'note')
  el.style.display = 'none'
  el.addEventListener('mouseenter', clearHideTimer)
  el.addEventListener('mouseleave', () => scheduleHide())
  document.body.appendChild(el)
  tooltipEl = el
  return el
}

/**
 * Collects the anchor element plus its following siblings, stopping before
 * the first of: a `<br>` separator, the next heading, or another lemma/
 * definition title (so we don't wander into unrelated later content or
 * accidentally swallow the following term's own definition). Lemmas are
 * consistently separated from what follows by a blank-line `<br />`; many
 * definitions instead sit directly under a `###`/`##` subsection heading or
 * immediately before the next definition, so all three boundary kinds are
 * needed to bound the content correctly.
 */
function collectTermContent(anchor: Element): DocumentFragment | null {
  const fragment = document.createDocumentFragment()
  let node: Element | null = anchor
  let collected = false

  while (node) {
    if (node !== anchor) {
      const isBreak = node.tagName === 'BR'
      const isHeading = /^H[1-6]$/.test(node.tagName)
      const isAnotherTerm =
        node.classList.contains('lemma-anchor') || node.classList.contains('definition-anchor')
      if (isBreak || isHeading || isAnotherTerm) break
    }
    fragment.appendChild(node.cloneNode(true))
    collected = true
    node = node.nextElementSibling
  }

  return collected ? fragment : null
}

function positionTooltip(tooltip: HTMLElement, ref: HTMLElement) {
  const rect = ref.getBoundingClientRect()
  const maxWidth = Math.min(420, window.innerWidth - 32)
  tooltip.style.maxWidth = `${maxWidth}px`

  const tooltipRect = tooltip.getBoundingClientRect()
  let top = rect.bottom + 8
  let left = rect.left

  if (left + tooltipRect.width > window.innerWidth - 16) {
    left = window.innerWidth - tooltipRect.width - 16
  }
  if (left < 16) left = 16

  if (top + tooltipRect.height > window.innerHeight - 16) {
    top = rect.top - tooltipRect.height - 8
  }
  if (top < 8) top = 8

  tooltip.style.top = `${top + window.scrollY}px`
  tooltip.style.left = `${left + window.scrollX}px`
}

function showTooltip(ref: HTMLElement) {
  // Full anchor id, e.g. "lemma-2-8" or "definition-1-0".
  const id = ref.dataset.termId
  if (!id) return

  const kind = id.startsWith('definition-') ? 'definition' : 'lemma'
  const anchor = document.getElementById(id)
  const tooltip = ensureTooltip()
  tooltip.innerHTML = ''

  const content = anchor ? collectTermContent(anchor) : null
  if (content) {
    tooltip.appendChild(content)
    if (anchor) {
      const jump = document.createElement('a')
      jump.href = `#${id}`
      jump.className = 'lemma-tooltip-jump'
      jump.textContent = 'Jump to definition \u2197'
      tooltip.appendChild(jump)
    }
  } else {
    const fallback = document.createElement('p')
    fallback.className = 'lemma-tooltip-fallback'
    fallback.textContent = `This ${kind} is not defined on the current page.`
    tooltip.appendChild(fallback)
  }

  tooltip.style.display = 'block'
  positionTooltip(tooltip, ref)
}

export function setupTermTooltips(): void {
  if (bound || typeof document === 'undefined') return
  bound = true

  document.addEventListener('mouseover', (event) => {
    const target = (event.target as HTMLElement)?.closest?.(REF_SELECTOR) as HTMLElement | null
    if (target) {
      clearHideTimer()
      showTooltip(target)
    }
  })

  document.addEventListener('mouseout', (event) => {
    const from = (event.target as HTMLElement)?.closest?.(REF_SELECTOR)
    const related = event.relatedTarget as HTMLElement | null
    const to = related?.closest?.(`${REF_SELECTOR}, .${TOOLTIP_CLASS}`)
    if (from && !to) scheduleHide()
  })

  document.addEventListener('focusin', (event) => {
    const target = (event.target as HTMLElement)?.closest?.(REF_SELECTOR) as HTMLElement | null
    if (target) showTooltip(target)
  })

  document.addEventListener('focusout', (event) => {
    const target = (event.target as HTMLElement)?.closest?.(REF_SELECTOR)
    if (target) scheduleHide()
  })

  document.addEventListener('click', (event) => {
    const target = (event.target as HTMLElement)?.closest?.(REF_SELECTOR) as HTMLElement | null
    if (target) {
      if (pinned && tooltipEl?.style.display === 'block') {
        hide()
      } else {
        event.preventDefault()
        showTooltip(target)
        pinned = true
      }
      return
    }
    if (tooltipEl && !tooltipEl.contains(event.target as Node)) hide()
  })

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') hide()
  })

  window.addEventListener('scroll', () => hide(), { passive: true })
}
