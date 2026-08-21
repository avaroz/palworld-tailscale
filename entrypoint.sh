#!/bin/bash
set -e

echo "Starting Tailscale daemon..."
tailscaled --tun=userspace-networking > /tmp/tailscale.log 2>&1 &
TAILSCALE_PID=$!
sleep 3

if [ -n "$TAILSCALE_AUTHKEY" ]; then
  echo "Connecting to Tailscale..."
  tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=palworld-server --accept-dns=false
  echo "Tailscale connected successfully"
else
  echo "Warning: TAILSCALE_AUTHKEY not set. Tailscale will not connect."
fi

echo "All services started. Keeping container alive..."
# Mantener el contenedor vivo
while true; do
  sleep 10
done

