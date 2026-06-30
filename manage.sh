#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage:
  ./manage.sh config
  ./manage.sh pull
  ./manage.sh up
  ./manage.sh down
  ./manage.sh restart
  ./manage.sh logs [service]
  ./manage.sh ps
  ./manage.sh exec SERVICE COMMAND...

Safety:
  This wrapper refuses Compose down commands that remove volumes.
EOF
}

require_env() {
  if [[ ! -f .env ]]; then
    echo "Missing .env. Run ./bootstrap.sh first, then edit .env." >&2
    exit 1
  fi
}

compose() {
  docker compose "$@"
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

case "$1" in
  config)
    require_env
    compose config
    ;;
  pull)
    require_env
    compose pull
    ;;
  up)
    require_env
    compose up -d
    ;;
  down)
    shift
    for arg in "$@"; do
      if [[ "$arg" == "-v" || "$arg" == "--volumes" ]]; then
        echo "Refusing to run docker compose down with volume removal." >&2
        exit 2
      fi
    done
    require_env
    compose down "$@"
    ;;
  restart)
    require_env
    compose restart
    ;;
  logs)
    require_env
    shift
    compose logs -f --tail=200 "$@"
    ;;
  ps)
    require_env
    compose ps
    ;;
  exec)
    require_env
    shift
    if [[ $# -lt 2 ]]; then
      echo "Usage: ./manage.sh exec SERVICE COMMAND..." >&2
      exit 1
    fi
    compose exec "$@"
    ;;
  *down*-v*|*--volumes*|volume|volumes)
    echo "Refusing unsafe volume operation. Persistent data lives in protected external volumes." >&2
    exit 2
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown command: $1" >&2
    usage
    exit 1
    ;;
esac
