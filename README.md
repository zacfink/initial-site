# Personal site

A single-file personal site for Zac. Everything — markup, styles, and content —
lives in [`index.html`](index.html). All page content is defined in the `SITE`
object in the `<script>` block near the bottom; the page renders itself from it,
so editing copy, projects, links, or labels means changing values there.

That object is also the fallback. Once Supabase is configured the page fetches a
newer copy of it on load and re-renders; if that request fails, the shipped copy
stays on screen. See [Editing content without a deploy](#editing-content-without-a-deploy).

## Structure

```
.
├── index.html        # the whole site (HTML + CSS + JS, self-contained)
├── assets/
│   └── resume.pdf    # downloadable résumé
├── supabase/
│   ├── schema.sql    # table + read-only policy (run once)
│   ├── seed.sql      # loads the shipped content into the row
│   └── seed.json     # the same content as plain JSON
├── .nojekyll         # serve files as-is on GitHub Pages
└── .gitignore
```

## Run locally

It's a static file — open `index.html` directly, or serve the folder:

```sh
python3 -m http.server 8000
# then visit http://localhost:8000
```

## Editing content without a deploy

Page content can also live in a Supabase row, so copy changes take effect on
reload with no commit and no deploy. Until it's configured the site behaves
exactly as it always has.

**One-time setup**

1. Create a project at [supabase.com](https://supabase.com) (free tier is fine).
2. **SQL Editor → New query**, paste [`supabase/schema.sql`](supabase/schema.sql), Run.
   This creates the `site_content` table with a read-only policy.
3. Same again with [`supabase/seed.sql`](supabase/seed.sql), which loads the
   content currently shipped in `index.html` into the row.
4. **Project Settings → API**: copy the **Project URL** and the **anon public** key.
5. Paste both into the `CONTENT` object near the bottom of `index.html`, replacing
   `YOUR-PROJECT-REF` and `YOUR-ANON-KEY`. Commit and deploy this once.

**From then on**: **Table Editor → `site_content`**, edit the `data` cell, save,
reload the site.

**Worth knowing**

- The anon key belongs in the page source. Row Level Security grants only
  `select` on this table, so a visitor can read that row and do nothing else.
- The row is merged over the shipped object one section at a time, so a row
  holding only `hero` updates the hero and leaves everything else as shipped.
- If the row fails to render, the page restores the shipped copy and logs a
  warning, so a bad edit can't take the site down.
- Re-run `seed.sql` at any time to reset the row to what's in `index.html`.
- To remove the feature entirely, delete the `CONTENT` object and
  `loadPublishedContent` from `index.html`.

## Deploy (GitHub Pages)

1. Create a repo and push this folder:
   ```sh
   git init
   git add .
   git commit -m "Initial site"
   git branch -M main
   git remote add origin https://github.com/zacfink/<repo>.git
   git push -u origin main
   ```
2. In the repo: **Settings → Pages → Build and deployment**.
3. Set **Source** to *Deploy from a branch*, branch **main**, folder **/ (root)**.
4. Save. The site publishes at `https://zacfink.github.io/<repo>/`.

> Tip: to use a custom domain, add a `CNAME` file containing the domain and
> configure DNS per GitHub's instructions.
