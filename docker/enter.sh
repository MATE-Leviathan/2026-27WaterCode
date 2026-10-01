#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
  -h|--help) echo "Enter competition: bash docker/enter.sh"; exit 0 ;;
  "") docker exec -it leviathan /bin/bash ;;
  *) echo "For HoloOcean, use docker/simulation/enter.sh." >&2; exit 1 ;;
esac
