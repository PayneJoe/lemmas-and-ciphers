import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import './custom.css'
import { setupLemmaTooltips } from './lemma-tooltip'

export default {
  extends: DefaultTheme,
  enhanceApp() {
    if (typeof window !== 'undefined') {
      setupLemmaTooltips()
    }
  },
} satisfies Theme
