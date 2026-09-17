#!/usr/bin/env bash
set -e

# If the 2026-27WaterCode from outside the container is owned
# by owner 1000, it is fine to use as is, since the id of
# ubuntu inside the container is also 1000
# If there's a mismatch, use bindfs to remap the user and group
# to be ubuntu:ubuntu. Try to avoid this if possible since it
# seems to slow down builds in some cases
readonly_root=/home/ubuntu/.2026-27WaterCode.readonly
writable_root=/home/ubuntu/2026-27WaterCode
readme="$readonly_root/README.md"

if [[ ! -e "$readme" ]]; then
	echo "Robot code is not mounted at $readonly_root" >&2
	echo "Mount the repo there (compose volume ..:$readonly_root) and retry." >&2
	exit 1
fi

id=$(stat -c '%u' "$readme")

if [[ $id == "1000" ]] ; then
	if [[ ! -e "$writable_root" ]]; then
		ln -sf "$readonly_root" "$writable_root"
	fi
else
	mkdir -p "$writable_root"

	# Might be best to fix sudoers file?
	# -p "" turns off prompt
	# -kS resets token and then reads password from stdin
	echo ubuntu | sudo -p "" -kS bindfs --force-user=ubuntu --force-group=ubuntu \
		--create-for-user=1000 --create-for-group=1000 \
		--chown-ignore --chgrp-ignore \
		"$readonly_root" "$writable_root" > /dev/null 2>&1
fi

# Do not auto-activate a venv. Humble's python3.10 has rclpy, and a
# 3.12 venv with include-system-site-packages = false hides it.
# Do not uv sync on start either; open3d has no aarch64 wheel.
exec "$@"
# Drop privileges and execute next container command, or 'bash' if not specified.
#if [[ $# -gt 0 ]]; then
   #exec sudo -u -H ubuntu -- "$@"
#else
   #exec sudo -u -H ubuntu -- bash
#fi
