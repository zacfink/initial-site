# Personal site

A single-file personal site for Zac. Everything — markup, styles, and content —
lives in [`index.html`](index.html). All page content is defined in the `SITE`
constant in the `<script>` block near the bottom; the page renders itself from it,
so editing copy, projects, links, or labels means changing values there.

## Structure

```
.
├── index.html        # the whole site (HTML + CSS + JS, self-contained)
├── assets/
│   └── resume.pdf    # downloadable résumé
├── .nojekyll         # serve files as-is on GitHub Pages
└── .gitignore
```

## Run locally

It's a static file — open `index.html` directly, or serve the folder:

```sh
python3 -m http.server 8000
# then visit http://localhost:8000
```

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
