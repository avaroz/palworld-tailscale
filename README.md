# Palworld Server with Tailscale - Railway Deployment

A containerized Palworld dedicated server with Tailscale VPN support, ready to deploy on Railway or any Docker-compatible platform.

## 🚀 Quick Start

### Option 1: Deploy on Railway (Recommended)

1. Click the Railway deploy button or connect your GitHub fork
2. Railway will automatically set up the environment variables from `.env.production`
3. Configure the Palworld settings in Railway's dashboard under Variables
4. Add your Tailscale Auth Key (see [Tailscale Setup](#tailscale-setup))
5. Deploy and enjoy!

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

3. Edit `.env` with your desired configuration (see [Configuration](#configuration) section below)

4. Build and run with Docker:
   ```bash
   docker build -t palworld-server .
   docker run -it \
     --env-file .env \
     -p 8211:8211/udp \
     -p 27015:27015/udp \
     palworld-server
   ```

## ⚙️ Configuration

All server settings are controlled via environment variables. Three configuration files are provided:

- **`.env.example`** - Complete reference with all available options and descriptions
- **`.env.production`** - Production-ready configuration
- **`TAILSCALE_SETUP.md`** - Detailed Tailscale VPN setup guide

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

## 🔐 Tailscale Setup

### What is Tailscale?

Tailscale creates a secure private VPN network between your devices. Connect your Palworld server to Tailscale to:
- ✅ Access your server from anywhere
- ✅ Bypass firewall restrictions
- ✅ Play securely without exposing your server publicly
- ✅ Use private Tailscale IPs (100.x.x.x)

### Quick Setup

1. **Generate Tailscale Auth Key:**
   - Go to https://login.tailscale.com/admin/settings/keys
   - Click "Generate auth key"
   - Make it **Reusable** ✓ and optionally **Ephemeral** ✓
   - Copy the key (looks like: `tskey-auth-XXXXX`)

2. **Add to Railway:**
   - Go to your `palworld-tailscale` service in Railway
   - Go to **Variables** section
   - Add new variable:
     - Name: `TAILSCALE_AUTHKEY`
     - Value: Paste your auth key
   - Railway auto-redeploys

3. **Verify Connection:**
   - Go to https://login.tailscale.com/admin/machines
   - Look for device named **"palworld-server"**
   - Once online, Tailscale is working!

4. **Connect to Server:**
   - Find your server's Tailscale IP (100.x.x.x)
   - In Palworld: `100.x.x.x:8211` with your password
   - Play securely over VPN!

**📖 Full Guide:** See [TAILSCALE_SETUP.md](TAILSCALE_SETUP.md) for detailed troubleshooting and advanced configuration.

## 🐳 Docker Image

This image is based on `thijsvanloef/palworld-server-docker:latest` and adds:
- Tailscale VPN support with automatic auth key handling
- Pre-configured environment variable handling
- Railway deployment compatibility
- Entrypoint script for seamless startup

## 🔌 Ports

Expose these UDP ports:
- `8211` - Game server port
- `27015` - Query/discovery port (server list)

## 📁 File Structure

```
.
├── Dockerfile           - Container definition with Tailscale
├── entrypoint.sh        - Startup script (Tailscale + Palworld)
├── .env.example         - Configuration template (all 28 options)
├── .env.production      - Production configuration
├── README.md            - This file
└── TAILSCALE_SETUP.md   - Detailed VPN setup guide
```

## 🚀 Railway Deployment

When deploying on Railway:

1. The platform automatically reads all variables from `.env.production`
2. Configure via Railway's **Variables** dashboard
3. Expose ports 8211 and 27015 as UDP
4. Add `TAILSCALE_AUTHKEY` for VPN support (see [Tailscale Setup](#tailscale-setup))
5. Changes take effect after redeploy

## 🐛 Troubleshooting

### Server not appearing in Tailscale machines?
- Verify `TAILSCALE_AUTHKEY` is set correctly
- Check Railway deployment logs
- Look for: "Tailscale connected successfully"
- See [TAILSCALE_SETUP.md](TAILSCALE_SETUP.md) for more help

### Server not appearing in Palworld server list?
- Check `PALWORLD_QUERY_PORT` (default 27015)
- Verify UDP ports are properly exposed
- Ensure server status is "Online" in Railway

### Connection refused?
- Verify ports 8211 and 27015 are open
- Check service logs for startup errors
- Ensure sufficient memory allocation
- Try direct connection if Tailscale fails

### Performance issues?
- Reduce `PALWORLD_PAL_SPAWN_NUM_RATE`
- Lower `PALWORLD_DROP_ITEM_MAX_NUM`
- Check Railway CPU/memory allocation

## 📚 Documentation

- **Palworld Server Config:** See `.env.example` for all options
- **Tailscale VPN:** See `TAILSCALE_SETUP.md` for detailed guide
- **Base Image:** https://github.com/thijsvanloef/palworld-server-docker
- **Tailscale Docs:** https://tailscale.com/kb/

## 📝 License

Based on [thijsvanloef/palworld-server-docker](https://github.com/thijsvanloef/palworld-server-docker)

## 💬 Support

For issues:
- Check [TAILSCALE_SETUP.md](TAILSCALE_SETUP.md) for Tailscale problems
- Create a GitHub issue for Palworld server issues
- Check Railway logs for deployment errors

