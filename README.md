# longxianwen.net

Personal blog, built with [Jekyll](https://jekyllrb.com/).

## Local with Docker

From the `myapps` repo:

```bash
docker compose up -d loong
```

Caddy proxies `https://longxianwen.net` → `loong:4000`. Host port defaults to `1313`.

One-off static build (optional; not required for normal use):

```bash
docker compose run --rm loong build
```

## Local without Docker

```bash
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

## GitHub Pages

Push to `main`. GitHub Actions builds `_site` and deploys — no Docker build step on the VPS.

1. Repo **Settings → Pages → Source**: GitHub Actions
2. Custom domain: `longxianwen.net` (see `CNAME`)

If DNS for `longxianwen.net` points at this VPS, Caddy serves the local Jekyll container. GitHub Pages is the push-to-deploy path (or a future DNS cutover).
