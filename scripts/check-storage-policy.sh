#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TARGETS=(
  docker-compose.yml
  bootstrap.sh
  manage.sh
  scripts
  nginx
  sync
)

if grep -R --line-number --exclude='check-storage-policy.sh' '/srv/data' "${TARGETS[@]}"; then
  echo "Forbidden path found: /srv/data" >&2
  exit 1
fi

if grep -R --line-number --exclude='check-storage-policy.sh' 'docker compose down -v\|docker compose down --volumes' docker-compose.yml bootstrap.sh manage.sh scripts nginx sync; then
  echo "Forbidden destructive compose command found." >&2
  exit 1
fi

echo "Storage policy check passed."
