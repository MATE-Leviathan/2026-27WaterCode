#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose is required. See docker/SETUP_GUIDE.md." >&2
  exit 1
fi
case "${1:--H}" in
  -H) profile=holoocean ;;
  -N) profile=holoocean-no-nvidia ;;
  -h|--help) echo "Simulation: -H (default) for NVIDIA, -N without NVIDIA."; exit 0 ;;
  *) echo "Use -H or -N." >&2; exit 1 ;;
esac
docker compose -p watercode-simulation -f "$script_dir/../docker-compose.yaml" -f "$script_dir/docker-compose.yaml" --profile holoocean --profile holoocean-no-nvidia stop holoocean holoocean-no-nvidia
docker compose -p watercode-simulation -f "$script_dir/../docker-compose.yaml" -f "$script_dir/docker-compose.yaml" --profile "$profile" up -d --build
