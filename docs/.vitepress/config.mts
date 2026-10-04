import { defineConfig } from 'vitepress'
import { termAutolinkPlugin } from './term-autolink.mts'

export default defineConfig({
  lang: 'en-US',
  title: 'Lemmas & Ciphers',
  description: 'Personal notes on mathematics, cryptography, and formal verification.',
  base: process.env.GITHUB_ACTIONS ? '/lemmas-and-ciphers/' : '/',
  cleanUrls: true,
  lastUpdated: true,
  markdown: {
    math: true,
    config: (md) => {
      md.use(termAutolinkPlugin)
    },
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
            {
              text: 'Linear Algebra',
              link: '/mathematics/linear-algebra/',
              items: [
                { text: 'Fundamentals', link: '/mathematics/linear-algebra/fundamentals' },
                { text: 'Structures', link: '/mathematics/linear-algebra/structures' },
                { text: 'Summary', link: '/mathematics/linear-algebra/summary' },
              ],
            },
            { text: 'Math of Proof', link: '/mathematics/math-of-proof/' },
            {
              text: 'Commutative Algebra',
              link: '/mathematics/commutative-algebra/',
              items: [
                { text: 'Rings and Ideals', link: '/mathematics/commutative-algebra/ring' },
                { text: 'Polynomial Rings', link: '/mathematics/commutative-algebra/polynomial-ring' },
                { text: 'Affine Algebraic Varieties', link: '/mathematics/commutative-algebra/affine-algbraic-varieties' },
                { text: 'Modules', link: '/mathematics/commutative-algebra/modules' },
                { text: 'Tensor Products', link: '/mathematics/commutative-algebra/tensor-product' },
                { text: 'Localization', link: '/mathematics/commutative-algebra/localization' },
                { text: 'Noetherian and Artinian Rings', link: '/mathematics/commutative-algebra/noetherian-and-artinian-rings' },
              ],
            },
          ],
        },
      ],
      '/cryptography/': [
        {
          text: 'Cryptography',
          items: [
            { text: 'Overview', link: '/cryptography/' },
            {
              text: 'Complexity of Lattice Problems',
              link: '/cryptography/complexity-of-lattice-problems/',
              items: [
                { text: 'Basics', link: '/cryptography/complexity-of-lattice-problems/basics' },
                { text: 'Approximation Algorithms', link: '/cryptography/complexity-of-lattice-problems/approximation-algorithms' },
                { text: 'Closest Vector Problem', link: '/cryptography/complexity-of-lattice-problems/closest-vector-problem' },
                { text: 'Basic Reduction Problem', link: '/cryptography/complexity-of-lattice-problems/basic-reduction-problem' },
                { text: 'Cryptographic Functions', link: '/cryptography/complexity-of-lattice-problems/cryptographic-functions' },
              ],
            },
          ],
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
            { text: 'Practical Tips', link: '/formal-verification/tips' },
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
