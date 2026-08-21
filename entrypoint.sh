#!/bin/bash
set -e

echo "Starting Tailscale daemon..."
tailscaled --tun=userspace-networking &
TAILSCALE_PID=$!
sleep 3

if [ -n "$TAILSCALE_AUTHKEY" ]; then
  echo "Connecting to Tailscale..."
  tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=palworld-server --accept-dns=false
  echo "Tailscale connected successfully"
else
  echo "Warning: TAILSCALE_AUTHKEY not set. Tailscale will not connect."
fi

echo "Starting Palworld server..."
# Ejecutar el comando de inicio estándar de Palworld
exec bash /home/steam/PalServer/run.sh

