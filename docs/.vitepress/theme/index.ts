import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import './custom.css'
import { setupTermTooltips } from './term-tooltip'

export default {
  extends: DefaultTheme,
  enhanceApp() {
    if (typeof window !== 'undefined') {
      setupTermTooltips()
    }
  },
} satisfies Theme
