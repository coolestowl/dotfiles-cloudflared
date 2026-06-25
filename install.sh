#!/usr/bin/env bash

curl -SOL https://github.com/cloudflare/cloudflared/releases/download/2026.3.0/cloudflared-linux-amd64

chmod +x cloudflared-linux-amd64

mv cloudflared-linux-amd64 ~/.local/bin/cloudflared

grep -qF "GIT_SSH_COMMAND" ~/.bashrc || cat << EOF >> ~/.bashrc
export GIT_SSH_COMMAND="$GIT_SSH_COMMAND -o ProxyCommand='cloudflared access ssh --hostname %h'"
EOF
