#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose is required. See docker/SETUP_GUIDE.md." >&2
  exit 1
fi
case "${1:-}" in
  -h|--help) echo "Competition Docker: bash docker/stop.sh"; exit 0 ;;
  "") ;;
  *) echo "For HoloOcean, use docker/simulation/setup.sh (-H or -N)." >&2; exit 1 ;;
esac
docker compose -p docker -f "$script_dir/docker-compose.yaml" down
