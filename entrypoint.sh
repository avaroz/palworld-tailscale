#!/bin/bash
set -e

echo "Starting Tailscale daemon..."
tailscaled --tun=userspace-networking > /tmp/tailscale.log 2>&1 &
sleep 3

if [ -n "$TAILSCALE_AUTHKEY" ]; then
  echo "Connecting to Tailscale..."
  tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=palworld-server --accept-dns=false
  echo "Tailscale connected successfully"
else
  echo "Warning: TAILSCALE_AUTHKEY not set"
fi

echo "Starting Palworld server..."
# The base image entrypoint is /home/steam/server/init.sh
exec /home/steam/server/init.sh "$@"

