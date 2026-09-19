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
- `scripts/heading-anchors.mjs` — assigns GitHub-style `id`s to headings
  (matching VitePress's auto-generated slugs), so a note's hand-written
  Table of Contents links (e.g. `[Sum of Subspaces](#sum-of-subspaces)`)
  actually resolve on WordPress instead of being dead links.
- `scripts/generate-sidebar-widget.mjs` — generates the HTML for the
  sidebar "quick navigation" Custom HTML widget, grouping published posts
  by category (Mathematics / Cryptography / Formal Verification). Re-run
  and re-paste into the widget whenever notes are added/removed.
- `plugin/additional.css` — CSS for the admonition callout boxes, the
  per-post floating Table of Contents, and the sidebar navigation widget.
  Paste this into `wp-admin → Appearance → Customize → Additional CSS`
  (see "Site styling" below) — it is **not** bundled into the plugin zip,
  since re-uploading the plugin proved unreliable on some managed hosts
  (Additional CSS applies instantly, no install/cache step involved).
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
  This plugin only carries the JS hover behavior — its styling and the
  admonition callout box CSS live in `plugin/additional.css` instead (see
  "Site styling" below), since re-uploading the plugin zip proved
  unreliable for delivering CSS updates on some managed hosts.

## 3. Theme

For an arXiv/classic-academic-blog look, install WordPress's official
**"Twenty Ten"** theme: `wp-admin → Appearance → Themes → Add New Theme` →
search "Twenty Ten" → **Install** → **Activate**.

## 4. Site styling (Additional CSS)

Paste the full contents of `plugin/additional.css` into `wp-admin →
Appearance → Customize → Additional CSS`, then click **Publish**. This
covers:
- Admonition callout box styling (`.md-alert*`) — tinted background,
  colored left border, and bold title per kind (note/tip/important/
  warning/caution).
- Per-post Table of Contents (`.post-toc`) — pinned with `position: fixed`
  to the left edge of the browser window (>= 900px viewports), mirroring
  the "On this page" outline on the old VitePress site: it stays visible
  the whole time you scroll, no matter which section of the post you're
  reading, so you can jump to any section directly. On narrow/mobile
  screens (< 900px) it falls back to a plain non-floating inline box so
  it doesn't cover the article text.
- Sidebar navigation widget styling (`.lemmas-sidebar-nav`, see below).

Whenever `plugin/additional.css` changes, re-paste it (there's no REST API
for Additional CSS on managed hosts, so this step stays manual).

## 5. Sidebar navigation widget

Twenty Ten ships a right-hand sidebar ("Primary Widget Area"). To add a
quick-navigation list grouped by Mathematics / Cryptography / Formal
Verification:

```sh
cd wordpress
node scripts/generate-sidebar-widget.mjs
```

Copy the printed HTML, then go to `wp-admin → Appearance → Widgets →
Primary Widget Area → add a "Custom HTML" widget` and paste it in as the
widget's content. Re-run the script and re-paste whenever notes are
added/removed so the sidebar stays current.

## 6. Top navigation menu

Add "About" and the three category archives to the site's nav menu
(`wp-admin → Appearance → Menus`):
1. If no menu exists yet, create one and assign it to the "Primary
   Navigation Menu" (or "Header Menu") location.
2. Under **Pages** in the left column, check **About** → **Add to Menu**.
3. Under **Categories**, check **Mathematics**, **Cryptography**, and
   **Formal Verification** → **Add to Menu**.
4. Drag the items into this order: Home, Mathematics, Cryptography, Formal
   Verification, About.
5. Click **Save Menu**.

(The Menus REST API is blocked on this host even with an Application
Password, so this step can't be automated from the publish script — it's a
one-time setup, not something you'll repeat per note.)

## 7. Configure the publish script

```sh
cd wordpress
npm install
cp .env.example .env
# edit .env: set WP_URL, WP_USER, WP_APP_PASSWORD
```

## 8. Usage

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
3. Assigns GitHub-style `id`s to every heading, and floats a leading
   hand-written Table of Contents block to the side of the post (see "Site
   styling" above), so its links actually resolve and long notes are easy
   to navigate.
4. Renders `> [!Note]` / `> [!Important]` / `> [!Tip]` / `> [!Warning]` /
   `> [!Caution]` blockquotes as styled callout boxes (same visual intent
   as VitePress's built-in admonition support).
5. Leaves `$...$` / `$$...$$` math untouched (protected from Markdown's
   emphasis parsing) so the MathJax/QuickLaTeX plugin renders it client-side.
6. Uploads any local images (`![alt](./img/foo.png)`) to the WordPress
   media library and rewrites the URL.
7. Assigns a WordPress category automatically based on the note's folder
   under `docs/` (`docs/mathematics/...` → "Mathematics",
   `docs/cryptography/...` → "Cryptography",
   `docs/formal-verification/...` → "Formal Verification"), creating the
   category via REST if it doesn't exist yet.
8. Publishes a new post, or **updates** the existing one if this file was
   published before (tracked in `post-mapping.json`).

Re-run the same command any time you edit the Markdown note — it updates
the same WordPress post in place. After publishing a note in a new
category for the first time, re-run
`node scripts/generate-sidebar-widget.mjs` and re-paste its output (see
"Sidebar navigation widget" above) so the sidebar picks it up.

## 9. Notes / limitations

- The hover-tooltip only resolves cross-references to anchors on the
  **same** WordPress post/page — identical to the current VitePress site's
  behavior (it doesn't fetch content from other pages).
- Only one WordPress post is created per Markdown file. If you split notes
  across many posts later, keep the `id`s (`lemma-X-Y` / `definition-X-Y`)
  unique per post.
- This pipeline intentionally does **not** migrate everything from
  `lemmas-and-ciphers` at once — start with 1–2 test notes, verify math,
  tooltips, and images render correctly live, then migrate more as needed.
