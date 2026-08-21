FROM thijsvanloef/palworld-server-docker:latest

# Instalar Tailscale
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg > /usr/share/keyrings/tailscale-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu focal main" | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Script de entrada para Tailscale + Palworld
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

