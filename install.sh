#!/usr/bin/env bash

set -e

latest_release_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
  https://github.com/cloudflare/cloudflared/releases/latest)"

case "$latest_release_url" in
  https://github.com/cloudflare/cloudflared/releases/tag/?*)
    latest_version="${latest_release_url##*/}"
    ;;
  *)
    printf 'Failed to resolve the latest cloudflared release: %s\n' "$latest_release_url" >&2
    exit 1
    ;;
esac

printf 'Downloading cloudflared %s\n' "$latest_version"
curl -fSL -o cloudflared-linux-amd64 \
  "https://github.com/cloudflare/cloudflared/releases/download/${latest_version}/cloudflared-linux-amd64"

chmod +x cloudflared-linux-amd64

mv cloudflared-linux-amd64 ~/.local/bin/cloudflared

grep -qF "GIT_SSH_COMMAND" ~/.bashrc || cat << EOF >> ~/.bashrc
export GIT_SSH_COMMAND="$GIT_SSH_COMMAND -o ProxyCommand='cloudflared access ssh --hostname %h'"
EOF
