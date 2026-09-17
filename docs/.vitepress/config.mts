import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'en-US',
  title: 'Lemmas & Ciphers',
  description: 'Personal notes on mathematics, cryptography, and formal verification.',
  base: process.env.GITHUB_ACTIONS ? '/lemmas-and-ciphers/' : '/',
  cleanUrls: true,
  lastUpdated: true,
  markdown: {
    math: true,
  },
  head: [
    ['link', { rel: 'icon', href: '/favicon.svg', type: 'image/svg+xml' }],
  ],
  themeConfig: {
    siteTitle: 'Lemmas & Ciphers',
    nav: [
      { text: 'Mathematics', link: '/mathematics/' },
      { text: 'Cryptography', link: '/cryptography/' },
      { text: 'Formal Verification', link: '/formal-verification/' },
    ],
    sidebar: {
      '/mathematics/': [
        {
          text: 'Mathematics',
          items: [
            { text: 'Overview', link: '/mathematics/' },
            { text: 'Linear Algebra', link: '/mathematics/linear-algebra/ch01-ch03' },
            { text: 'Math of Proof', link: '/mathematics/math-of-proof/' },
          ],
        },
      ],
      '/cryptography/': [
        {
          text: 'Cryptography',
          items: [{ text: 'Overview', link: '/cryptography/' }],
        },
      ],
      '/formal-verification/': [
        {
          text: 'Formal Verification',
          items: [
            { text: 'Overview', link: '/formal-verification/' },
            { text: 'Mathematics in Lean', link: '/formal-verification/mathlib-in-lean/' },
            { text: 'Chapter 8: Basics', link: '/formal-verification/mathlib-in-lean/ch08/' },
            { text: 'Chapter 9: Groups and Rings', link: '/formal-verification/mathlib-in-lean/ch09/' },
            { text: 'Chapter 10: Linear Algebra', link: '/formal-verification/mathlib-in-lean/ch10/' },
          ],
        },
      ],
    },
    search: {
      provider: 'local',
    },
    editLink: {
      pattern: 'https://github.com/PayneJoe/lemmas-and-ciphers/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },
    footer: {
      message: 'Published with GitHub Pages.',
      copyright: 'Copyright © 2026',
    },
  },
})
