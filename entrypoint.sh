#!/usr/bin/env bash
set -euo pipefail

cd /srv/jekyll

bundle install

case "${1:-serve}" in
  build)
    shift
    exec jekyll build "$@"
    ;;
  serve|"")
    [[ "${1:-}" == "serve" ]] && shift || true
    exec jekyll serve --host 0.0.0.0 --port 4000 --force_polling --watch "$@"
    ;;
  *)
    exec "$@"
    ;;
esac
