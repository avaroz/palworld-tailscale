FROM thijsvanloef/palworld-server-docker:latest

# Instalar Tailscale
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | tee /etc/apt/keyrings/tailscale-archive-keyring.gpg > /dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Script de entrada para Tailscale + Palworld
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

