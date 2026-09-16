# Lemmas & Ciphers

A personal, Markdown-first collection of notes on mathematics, cryptography, and
formal verification with Lean.

The published site is powered by [VitePress](https://vitepress.dev/) and deploys
to GitHub Pages whenever changes are merged into `main`.

## Writing notes

Published pages live in `docs/`. Add or revise Markdown there, use standard
fenced code blocks for examples, and write inline math with `$...$` or display
math with `$$...$$`. Update `docs/.vitepress/config.mts` when a new page should
appear in the site navigation.

Lean source files remain in `mathlib-in-lean/` beside the project’s original
material and can be updated independently of the website.

## Local development

Use Node.js 20 or later, install the declared dependencies, and start a local
preview:

```sh
npm install
npm run docs:dev
```

Run a production build before publishing:

```sh
npm run docs:build
```

## Publishing

The GitHub Actions workflow in `.github/workflows/deploy-pages.yml` deploys the
site for every push to `main` and can also be run manually. In the repository’s
**Settings → Pages**, set **Source** to **GitHub Actions** once to enable the
first deployment.
