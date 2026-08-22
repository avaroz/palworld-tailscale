# Palworld Server with Tailscale - Railway Deployment

A containerized Palworld dedicated server with Tailscale VPN support, ready to deploy on Railway or any Docker-compatible platform.

## Quick Start

### Option 1: Deploy on Railway (Recommended)

1. Click the Railway deploy button or connect your GitHub fork
2. Railway will automatically set up the environment variables from `.env.production`
3. Configure the Palworld settings in Railway's dashboard under Variables
4. Deploy and enjoy!

### Option 2: Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/avaroz/palworld-tailscale.git
   cd palworld-tailscale
   ```

2. Copy the environment template:
   ```bash
   cp .env.example .env
   ```

3. Edit `.env` with your desired configuration (see Configuration section below)

4. Build and run with Docker:
   ```bash
   docker build -t palworld-server .
   docker run -it \
     --env-file .env \
     -p 8211:8211/udp \
     -p 27015:27015/udp \
     palworld-server
   ```

## Configuration

All server settings are controlled via environment variables. Two configuration files are provided:

- **`.env.example`** - Complete reference with all available options and descriptions
- **`.env.production`** - Production-ready configuration

### Key Variables

#### Basic Settings
- `PALWORLD_SERVER_NAME` - Server name (default: "Palworld Server")
- `PALWORLD_SERVER_PASSWORD` - Server password for joining
- `PALWORLD_PORT` - Game server port (default: 8211)
- `PALWORLD_QUERY_PORT` - Server query/discovery port (default: 27015)
- `PALWORLD_MAX_PLAYERS` - Max concurrent players (default: 32)

#### Gameplay
- `PALWORLD_DIFFICULTY` - Easy / Normal / Hard
- `PALWORLD_GAME_SPEED` - Speed multiplier (1.0 = normal)
- `PALWORLD_PAL_EXP_RATE` - Pal experience multiplier
- `PALWORLD_PLAYER_EXP_RATE` - Player experience multiplier
- `PALWORLD_PAL_CAPTURE_RATE` - Capture difficulty (higher = easier)

#### PvP & Combat
- `PALWORLD_IS_PVPABLE` - Enable/disable PvP
- `PALWORLD_ENABLE_PLAYER_TO_PLAYER_DAMAGE` - Player damage to players
- `PALWORLD_ENABLE_FRIENDLY_FIRE` - Friendly fire enabled
- `PALWORLD_DEATH_PENALTY` - Item / ItemAndEquipment / All / None

#### Damage Multipliers
- `PALWORLD_PAL_DAMAGE_RATE_ATTACK` - Pal attack damage
- `PALWORLD_PAL_DAMAGE_RATE_DEFENCE` - Pal defense
- `PALWORLD_PLAYER_DAMAGE_RATE_ATTACK` - Player attack damage
- `PALWORLD_PLAYER_DAMAGE_RATE_DEFENCE` - Player defense

#### Other Settings
- `PALWORLD_DROP_ITEM_MAX_NUM` - Max dropped items on map
- `PALWORLD_BASECAMPWORKER_MAXNUM` - Max base workers
- `PALWORLD_CLAN_PLAYER_MAX_NUM` - Max players per clan
- `PALWORLD_WORK_SPEED_PAL` - Pal work speed multiplier

### Tailscale Configuration

If you want to connect this server via Tailscale VPN:

1. Create a Tailscale auth key at https://login.tailscale.com/admin/settings/keys
2. Set the `TAILSCALE_AUTHKEY` environment variable
3. The server will automatically join your Tailscale network

## Docker Image

This image is based on `thijsvanloef/palworld-server-docker:latest` and adds:
- Tailscale VPN support
- Pre-configured environment variable handling
- Railway deployment compatibility

## Ports

Expose these UDP ports:
- `8211` - Game server port
- `27015` - Query/discovery port

## File Structure

```
.
├── Dockerfile          - Container definition with Tailscale
├── entrypoint.sh       - Startup script (Tailscale + Palworld)
├── .env.example        - Configuration template (all options)
├── .env.production     - Production configuration
└── README.md           - This file
```

## Railway Deployment

When deploying on Railway:

1. The platform will automatically read the variables
2. Expose ports 8211 and 27015 as UDP
3. All configuration happens through Railway's Variables section
4. Changes take effect after redeploy

## Troubleshooting

### Server not appearing in server list?
- Check `PALWORLD_QUERY_PORT` (default 27015)
- Verify UDP ports are properly exposed
- Check Tailscale connection if using VPN

### Connection refused?
- Verify ports 8211 and 27015 are open
- Check server logs for startup errors
- Ensure sufficient memory allocation

### Performance issues?
- Reduce `PALWORLD_PAL_SPAWN_NUM_RATE`
- Lower `PALWORLD_DROP_ITEM_MAX_NUM`
- Check CPU/memory allocation

## License

Based on [thijsvanloef/palworld-server-docker](https://github.com/thijsvanloef/palworld-server-docker)

## Support

For issues, create a GitHub issue or check the Palworld server documentation.

