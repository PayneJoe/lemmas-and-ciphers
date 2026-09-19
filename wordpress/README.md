# Lemmas & Ciphers — WordPress publishing pipeline

This directory holds everything needed to run a personal WordPress site for
math/cryptography notes, with **Markdown in this git repo as the source of
truth** and a script that publishes/updates WordPress posts from it. It also
ports the "hover to preview a referenced Lemma/Definition" feature from the
VitePress site (`docs/`) so cross-references keep working on WordPress.

## Contents

- `plugin/lemmas-hover-tooltip/` — a small custom WordPress plugin. Ports
  `docs/.vitepress/theme/term-tooltip.ts` + its CSS to plain JS/CSS enqueued
  site-wide. No build step; just PHP + JS + CSS.
- `scripts/publish-to-wordpress.mjs` — the Markdown → WordPress publish
  script (see "Usage" below).
- `scripts/term-autolink.mjs` — shared logic (ported from
  `docs/.vitepress/term-autolink.mts`) that turns "Lemma X.Y" / "Definition
  X.Y" prose mentions into hoverable cross-reference links.
- `scripts/admonition.mjs` — renders GitHub/VitePress-style admonition
  blockquotes (`> [!Note] ...`, `> [!Important] ...`, `[!Tip]`,
  `[!Warning]`, `[!Caution]`) as styled callout boxes, matching how
  VitePress renders this syntax natively (plain markdown-it does not
  support it out of the box).
- `post-mapping.json` — tracks which Markdown file maps to which WordPress
  post ID, so re-running the publish script **updates** existing posts
  instead of creating duplicates. Safe to commit.
- `.env.example` — copy to `.env` (gitignored) and fill in your WordPress
  credentials.

## 1. Hosting & WordPress setup

Recommended: **self-hosted WordPress (WordPress.org)** on a budget managed
host (e.g. Hostinger, SiteGround, Cloudways) rather than WordPress.com. This
gets you:
- Unrestricted plugin installs (needed for the hover-tooltip plugin below,
  plus math/code plugins) without WordPress.com's paid Business/Commerce
  tier.
- Full REST API access with **Application Passwords** built into WordPress
  core (5.6+) — no extra plugin needed for the publish script to
  authenticate.

Steps:
1. Sign up with a host, use its one-click WordPress installer.
2. Point a domain at it (or start on the host's temporary subdomain).
3. Log in to `wp-admin` → **Users → Profile → Application Passwords** →
   create one (e.g. named "notes-publisher"). Copy the generated password —
   you won't see it again.

## 2. Install plugins

From `wp-admin → Plugins`:
- **Math rendering**: install "Simple MathJax" (or "WP QuickLaTeX"). This
  renders the `$...$` / `$$...$$` LaTeX the publish script leaves untouched
  in each post's HTML.
- **Code highlighting** (optional, if notes have code blocks): install
  "Enlighter" or similar.
- **Hover-preview tooltips**: install the custom plugin in this repo:
  1. Zip the `plugin/lemmas-hover-tooltip/` folder (or copy it directly)
     into your WordPress install's `wp-content/plugins/` directory.
  2. Activate "Lemmas Hover Tooltip" from `wp-admin → Plugins`.
  This same plugin also carries the CSS for admonition callout boxes
  (`.md-alert*`), so re-upload it whenever `assets/tooltip.css` changes.

## 3. Theme

For an arXiv/classic-academic-blog look, install WordPress's official
**"Twenty Ten"** theme: `wp-admin → Appearance → Themes → Add New Theme` →
search "Twenty Ten" → **Install** → **Activate**.

## 4. Configure the publish script

```sh
cd wordpress
npm install
cp .env.example .env
# edit .env: set WP_URL, WP_USER, WP_APP_PASSWORD
```

## 5. Usage

Publish (or update) one or more notes:

```sh
cd wordpress
node scripts/publish-to-wordpress.mjs ../docs/mathematics/linear-algebra/ch01-ch03.md
```

What it does per file:
1. Uses the first `# H1` heading as the WordPress post title (and strips it
   from the body, since WordPress renders the title separately).
2. Converts Markdown → HTML, preserving `{#id .class}` anchors (so
   "Lemma X.Y"/"Definition X.Y" anchors keep working) and turning prose
   mentions of them into hoverable links — same mechanism as the VitePress
   site.
3. Renders `> [!Note]` / `> [!Important]` / `> [!Tip]` / `> [!Warning]` /
   `> [!Caution]` blockquotes as styled callout boxes (same visual intent
   as VitePress's built-in admonition support).
4. Leaves `$...$` / `$$...$$` math untouched (protected from Markdown's
   emphasis parsing) so the MathJax/QuickLaTeX plugin renders it client-side.
5. Uploads any local images (`![alt](./img/foo.png)`) to the WordPress
   media library and rewrites the URL.
6. Publishes a new post, or **updates** the existing one if this file was
   published before (tracked in `post-mapping.json`).

Re-run the same command any time you edit the Markdown note — it updates
the same WordPress post in place.

## 6. Notes / limitations

- The hover-tooltip only resolves cross-references to anchors on the
  **same** WordPress post/page — identical to the current VitePress site's
  behavior (it doesn't fetch content from other pages).
- Only one WordPress post is created per Markdown file. If you split notes
  across many posts later, keep the `id`s (`lemma-X-Y` / `definition-X-Y`)
  unique per post.
- This pipeline intentionally does **not** migrate everything from
  `lemmas-and-ciphers` at once — start with 1–2 test notes, verify math,
  tooltips, and images render correctly live, then migrate more as needed.
