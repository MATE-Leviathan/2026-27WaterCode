#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose is required. See docker/SETUP_GUIDE.md." >&2
  exit 1
fi
docker compose -p watercode-simulation -f "$script_dir/../docker-compose.yaml" -f "$script_dir/docker-compose.yaml" --profile holoocean --profile holoocean-no-nvidia down
