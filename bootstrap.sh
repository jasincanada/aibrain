#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

VOLUMES=(
  aibrain_couchdb_data
  aibrain_obsidian_vault
  aibrain_obsidian_config
  aibrain_ollama
)

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example. Edit it before starting services."
else
  echo ".env already exists; leaving it unchanged."
fi

for volume in "${VOLUMES[@]}"; do
  if docker volume inspect "$volume" >/dev/null 2>&1; then
    echo "Volume exists: $volume"
  else
    docker volume create "$volume" >/dev/null
    echo "Created external volume: $volume"
  fi
done

echo
echo "Bootstrap complete. Review .env, then use ./manage.sh config to validate Compose."
