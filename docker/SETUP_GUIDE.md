# Competition setup (topside and real robot)

This guide is for the competition container used on the topside computer and with the real robot. It is not the HoloOcean simulation. For simulation, see [docker/simulation/SETUP_GUIDE.md](simulation/SETUP_GUIDE.md).

## Prerequisites

On Ubuntu, install Docker Engine and the Docker Compose plugin from Docker's official apt repository. `docker compose version` should succeed. Your user should be in the `docker` group so you do not need sudo for every command.

## Start

From the repository root:

```bash
bash docker/setup.sh
```

The repo is mounted into the container. The entrypoint exposes it at `/home/ubuntu/2026-27WaterCode`.

## Enter

```bash
bash docker/enter.sh
```

## Stop

```bash
bash docker/stop.sh
```
