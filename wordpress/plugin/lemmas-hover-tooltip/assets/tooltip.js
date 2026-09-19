/**
 * Client-only hover/focus/tap preview for `.lemma-ref` / `.definition-ref`
 * cross-references, ported from the lemmas-and-ciphers VitePress site
 * (docs/.vitepress/theme/term-tooltip.ts).
 *
 * A reference link (produced by the publish-to-wordpress.mjs conversion
 * script's term-autolink pass) points to `#lemma-<id>` or
 * `#definition-<id>` — the anchor added to a lemma's/definition's title
 * paragraph as `<span id="lemma-<id>" class="lemma-anchor">` /
 * `<span id="definition-<id>" class="definition-anchor">`. On
 * hover/focus/click we look up that anchor on the *current* page, clone its
 * content up to the next separator, and show it in a floating box near the
 * reference.
 *
 * This only works for cross-references that resolve to an anchor present
 * on the same WordPress post/page (matching the current same-page-only
 * behavior of the VitePress site).
 */
(function () {
  'use strict';

  var TOOLTIP_CLASS = 'lemma-tooltip';
  var REF_SELECTOR = '.lemma-ref, .definition-ref';

  var tooltipEl = null;
  var pinned = false;
  var hideTimer;
  var bound = false;

  function clearHideTimer() {
    if (hideTimer !== undefined) {
      clearTimeout(hideTimer);
      hideTimer = undefined;
    }
  }

  function scheduleHide(delay) {
    clearHideTimer();
    hideTimer = setTimeout(function () {
      if (!pinned) hide();
    }, delay || 150);
  }

  function hide() {
    pinned = false;
    if (tooltipEl) tooltipEl.style.display = 'none';
  }

  function ensureTooltip() {
    if (tooltipEl) return tooltipEl;

    var el = document.createElement('div');
    el.className = TOOLTIP_CLASS;
    el.setAttribute('role', 'note');
    el.style.display = 'none';
    el.addEventListener('mouseenter', clearHideTimer);
    el.addEventListener('mouseleave', function () {
      scheduleHide();
    });
    document.body.appendChild(el);
    tooltipEl = el;
    return el;
  }

  /**
   * Collects the anchor element plus its following siblings, stopping
   * before the first of: a `<br>` separator, the next heading, or another
   * lemma/definition anchor.
   */
  function collectTermContent(anchor) {
    var fragment = document.createDocumentFragment();
    var node = anchor;
    var collected = false;

    while (node) {
      if (node !== anchor) {
        var isBreak = node.tagName === 'BR';
        var isHeading = /^H[1-6]$/.test(node.tagName);
        var isAnotherTerm =
          node.classList &&
          (node.classList.contains('lemma-anchor') ||
            node.classList.contains('definition-anchor'));
        if (isBreak || isHeading || isAnotherTerm) break;
      }
      fragment.appendChild(node.cloneNode(true));
      collected = true;
      node = node.nextElementSibling;
    }

    return collected ? fragment : null;
  }

  function positionTooltip(tooltip, ref) {
    var rect = ref.getBoundingClientRect();
    var maxWidth = Math.min(420, window.innerWidth - 32);
    tooltip.style.maxWidth = maxWidth + 'px';

    var tooltipRect = tooltip.getBoundingClientRect();
    var top = rect.bottom + 8;
    var left = rect.left;

    if (left + tooltipRect.width > window.innerWidth - 16) {
      left = window.innerWidth - tooltipRect.width - 16;
    }
    if (left < 16) left = 16;

    if (top + tooltipRect.height > window.innerHeight - 16) {
      top = rect.top - tooltipRect.height - 8;
    }
    if (top < 8) top = 8;

    tooltip.style.top = top + window.scrollY + 'px';
    tooltip.style.left = left + window.scrollX + 'px';
  }

  function showTooltip(ref) {
    var id = ref.getAttribute('data-term-id');
    if (!id) return;

    var kind = id.indexOf('definition-') === 0 ? 'definition' : 'lemma';
    var anchor = document.getElementById(id);
    var tooltip = ensureTooltip();
    tooltip.innerHTML = '';

    var content = anchor ? collectTermContent(anchor) : null;
    if (content) {
      tooltip.appendChild(content);
      if (anchor) {
        var jump = document.createElement('a');
        jump.href = '#' + id;
        jump.className = 'lemma-tooltip-jump';
        jump.textContent = 'Jump to definition \u2197';
        tooltip.appendChild(jump);
      }
    } else {
      var fallback = document.createElement('p');
      fallback.className = 'lemma-tooltip-fallback';
      fallback.textContent = 'This ' + kind + ' is not defined on the current page.';
      tooltip.appendChild(fallback);
    }

    tooltip.style.display = 'block';
    positionTooltip(tooltip, ref);
  }

  function setup() {
    if (bound) return;
    bound = true;

    document.addEventListener('mouseover', function (event) {
      var target = event.target.closest && event.target.closest(REF_SELECTOR);
      if (target) {
        clearHideTimer();
        showTooltip(target);
      }
    });

    document.addEventListener('mouseout', function (event) {
      var from = event.target.closest && event.target.closest(REF_SELECTOR);
      var related = event.relatedTarget;
      var to =
        related && related.closest && related.closest(REF_SELECTOR + ', .' + TOOLTIP_CLASS);
      if (from && !to) scheduleHide();
    });

    document.addEventListener('focusin', function (event) {
      var target = event.target.closest && event.target.closest(REF_SELECTOR);
      if (target) showTooltip(target);
    });

    document.addEventListener('focusout', function (event) {
      var target = event.target.closest && event.target.closest(REF_SELECTOR);
      if (target) scheduleHide();
    });

    document.addEventListener('click', function (event) {
      var target = event.target.closest && event.target.closest(REF_SELECTOR);
      if (target) {
        if (pinned && tooltipEl && tooltipEl.style.display === 'block') {
          hide();
        } else {
          event.preventDefault();
          showTooltip(target);
          pinned = true;
        }
        return;
      }
      if (tooltipEl && !tooltipEl.contains(event.target)) hide();
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') hide();
    });

    window.addEventListener('scroll', function () { hide(); }, { passive: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setup);
  } else {
    setup();
  }
})();
