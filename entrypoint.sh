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

# Ensure ADMIN_PASSWORD is set (required for REST API)
if [ -z "$ADMIN_PASSWORD" ]; then
  echo "ERROR: ADMIN_PASSWORD must be set"
  exit 1
fi

# Export all Palworld variables so they're available to the base image
export ADMIN_PASSWORD

echo "Admin password is configured"

# The base image entrypoint is /home/steam/server/init.sh
exec /home/steam/server/init.sh "$@"

