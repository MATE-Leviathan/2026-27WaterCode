#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
  ""|-H) docker exec -it holoocean-ros /bin/bash ;;
  -R) docker exec -it leviathan-sim /bin/bash ;;
  -h|--help) echo "Enter HoloOcean (default), or -R for the robot adapter container." ;;
  *) echo "Use -R for robot adapters, or no option for HoloOcean." >&2; exit 1 ;;
esac
