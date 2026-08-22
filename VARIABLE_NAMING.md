# Variable Naming Guide - Palworld Server Configuration

This document explains the correct variable names and naming conventions used in this Palworld server Docker image.

## Important: Variable Naming Conventions

This image uses variables from two different sources:
1. **Base Image Variables** - From `thijsvanloef/palworld-server-docker`
2. **Palworld Game Variables** - Game-specific settings

Understanding the naming convention is **critical** for proper configuration.

## Base Image Variables

These variables are defined by the base Docker image and must use the **exact names** specified:

### Authentication
- `ADMIN_PASSWORD` ⭐ **REQUIRED** - Admin password for REST API access
  - ✅ Correct: `ADMIN_PASSWORD=mySecurePassword123`
  - ❌ Wrong: `PALWORLD_ADMIN_PASSWORD=...` (will NOT work)
  - Used for: REST API authentication, RCON commands
  - Default: None (server requires this)

### Server Information
- `SERVER_PASSWORD` - Password to join the server
  - Optional
  - Format: Plain text
- `SERVER_NAME` - Display name in server list
- `SERVER_DESCRIPTION` - Server description

### Networking
- `PORT` - Game server port
  - Default: `8211`
  - Format: `8211` (not `PALWORLD_PORT=8211`)
- `QUERY_PORT` - Query/discovery port
  - Default: `27015`

### REST API
- `REST_API_ENABLED` - Enable REST API
  - Values: `true` or `false`
- `REST_API_PORT` - REST API port
  - Default: `8212`

## Palworld Game Variables

These variables are Palworld-specific and use the `PALWORLD_` prefix:

### Game Settings
- `PALWORLD_MAX_PLAYERS` - Max concurrent players
- `PALWORLD_DIFFICULTY` - Easy / Normal / Hard
- `PALWORLD_GAME_SPEED` - Speed multiplier
- `PALWORLD_IS_PVPABLE` - Enable PvP
- `PALWORLD_DEATH_PENALTY` - Item / ItemAndEquipment / All / None

### Gameplay Rates
- `PALWORLD_PAL_EXP_RATE` - Pal experience multiplier
- `PALWORLD_PLAYER_EXP_RATE` - Player experience multiplier
- `PALWORLD_PAL_CAPTURE_RATE` - Capture difficulty
- `PALWORLD_PAL_SPAWN_NUM_RATE` - Spawn rate

### Combat Settings
- `PALWORLD_PAL_DAMAGE_RATE_ATTACK` - Pal attack damage
- `PALWORLD_PAL_DAMAGE_RATE_DEFENCE` - Pal defense
- `PALWORLD_PLAYER_DAMAGE_RATE_ATTACK` - Player attack damage
- `PALWORLD_PLAYER_DAMAGE_RATE_DEFENCE` - Player defense
- `PALWORLD_ENABLE_PLAYER_TO_PLAYER_DAMAGE` - PvP damage enabled
- `PALWORLD_ENABLE_FRIENDLY_FIRE` - Friendly fire
- `PALWORLD_ENABLE_DEFENSE_OTHER_PLAYER_PAL` - Defense vs other Pals

### Resources & Limits
- `PALWORLD_DROP_ITEM_MAX_NUM` - Max dropped items
- `PALWORLD_DROP_ITEM_MAX_NUM_UNKO_DEFAULT` - Max basic items
- `PALWORLD_BASECAMPWORKER_MAXNUM` - Max workers per base
- `PALWORLD_CLAN_PLAYER_MAX_NUM` - Max players per clan
- `PALWORLD_WORK_SPEED_PAL` - Pal work speed

## Common Mistakes

### ❌ Mistake #1: Using PALWORLD_ADMIN_PASSWORD

```bash
# WRONG - This will NOT work
PALWORLD_ADMIN_PASSWORD=myPassword123
# Error: REST accessed endpoint / Unauthorized (AdminPassword is empty)
```

```bash
# CORRECT - Use the exact base image name
ADMIN_PASSWORD=myPassword123
# ✅ Works correctly
```

### ❌ Mistake #2: Using PALWORLD_PORT

```bash
# WRONG - Base image doesn't recognize this
PALWORLD_PORT=8211
# Result: Port still defaults to 8211
```

```bash
# CORRECT - Use base image convention
PORT=8211
# ✅ Works correctly
```

### ❌ Mistake #3: Wrong Case or Typos

```bash
# WRONG - Case sensitive!
admin_password=myPassword  # lowercase = ignored
Admin_Password=myPassword  # mixed case = ignored
ADMINPASSWORD=myPassword   # no underscore = ignored
```

```bash
# CORRECT - Exact case
ADMIN_PASSWORD=myPassword
# ✅ Works correctly
```

## How to Check Your Variables

### In Railway Dashboard

1. Go to your service: `palworld-tailscale`
2. Click **Variables** tab
3. Verify:
   - ✅ `ADMIN_PASSWORD` exists (not `PALWORLD_ADMIN_PASSWORD`)
   - ✅ `TAILSCALE_AUTHKEY` exists (for VPN)
   - ✅ All `PALWORLD_*` variables with correct names

### In Docker Command

```bash
# Correct format
docker run \
  -e ADMIN_PASSWORD="myPassword123" \
  -e PORT=8211 \
  -e PALWORLD_MAX_PLAYERS=32 \
  -e PALWORLD_DIFFICULTY=Normal \
  palworld-tailscale
```

### In .env File

```bash
# .env file - MUST use exact variable names

# Base image variables (no PALWORLD_ prefix)
ADMIN_PASSWORD=mySecurePassword123
PORT=8211
QUERY_PORT=27015
SERVER_PASSWORD=serverPassword

# Palworld game variables (WITH PALWORLD_ prefix)
PALWORLD_MAX_PLAYERS=32
PALWORLD_DIFFICULTY=Normal
PALWORLD_GAME_SPEED=1.0
PALWORLD_IS_PVPABLE=false
```

## Debugging Variable Issues

### Symptom: "REST accessed endpoint / Unauthorized (AdminPassword is empty)"

**Causes:**
1. ✅ `ADMIN_PASSWORD` is not set
2. ✅ `PALWORLD_ADMIN_PASSWORD` is used instead (wrong name)
3. ✅ Variable is empty string
4. ✅ Variable has wrong case

**Solution:**
```bash
# Check current variables
# Go to Railway dashboard > Variables
# Verify: ADMIN_PASSWORD (not PALWORLD_ADMIN_PASSWORD)

# Or in Docker logs
docker logs palworld-server | grep "Admin password"
# Should show: "Admin password is configured"
```

### Symptom: Game setting changes not applied

**Cause:** Used wrong variable name prefix

**Solution:**
- Game settings MUST start with `PALWORLD_` prefix
- Examples: `PALWORLD_MAX_PLAYERS=32`, `PALWORLD_DIFFICULTY=Normal`

### Symptom: Port doesn't change

**Cause:** Used `PALWORLD_PORT` instead of `PORT`

**Solution:**
- Base image networking uses `PORT` (not `PALWORLD_PORT`)
- Correct: `PORT=8211`

## Variable Reference Summary

| Purpose | Correct Name | Wrong Names | Notes |
|---------|--------------|------------|-------|
| Admin REST API password | `ADMIN_PASSWORD` | `PALWORLD_ADMIN_PASSWORD`, `AdminPassword` | **REQUIRED** - Exact case |
| Server join password | `SERVER_PASSWORD` | `PALWORLD_SERVER_PASSWORD` | Optional |
| Game server port | `PORT` | `PALWORLD_PORT` | Base image convention |
| Max players | `PALWORLD_MAX_PLAYERS` | `MAX_PLAYERS` | Palworld-specific |
| Game difficulty | `PALWORLD_DIFFICULTY` | None | Palworld-specific |
| Experience rate | `PALWORLD_PLAYER_EXP_RATE` | `EXP_RATE` | Palworld-specific |

## Railway Specific

When deploying on Railway, use the exact variable names in the **Variables** section:

```
Name: ADMIN_PASSWORD
Value: ${{ secret(16) }}  # Railway generates random 16-char password

Name: TAILSCALE_AUTHKEY
Value: tskey-auth-XXXXX  # Your Tailscale key

Name: PALWORLD_MAX_PLAYERS
Value: 32

Name: PALWORLD_DIFFICULTY
Value: Normal
```

## Examples

### Complete Correct Configuration

```bash
# Base image variables (exact names, no PALWORLD_ prefix)
ADMIN_PASSWORD=AdminPass123!
SERVER_PASSWORD=ServerPass456!
PORT=8211
QUERY_PORT=27015
REST_API_ENABLED=true
REST_API_PORT=8212
SERVER_NAME=My Palworld Server
SERVER_DESCRIPTION=Community server

# Palworld game variables (WITH PALWORLD_ prefix)
PALWORLD_MAX_PLAYERS=32
PALWORLD_DIFFICULTY=Normal
PALWORLD_GAME_SPEED=1.0
PALWORLD_IS_PVPABLE=false
PALWORLD_PLAYER_EXP_RATE=1.0
PALWORLD_PAL_EXP_RATE=1.0
PALWORLD_PAL_CAPTURE_RATE=1.0
PALWORLD_DEATH_PENALTY=Item

# Tailscale
TAILSCALE_AUTHKEY=tskey-auth-XXXXX
```

## References

- Base Image: https://github.com/thijsvanloef/palworld-server-docker
- Base Image .env.example: https://github.com/thijsvanloef/palworld-server-docker/blob/main/.env.example
- Palworld Configuration: See `.env.example` in this repository

## Quick Checklist

Before deploying:
- [ ] `ADMIN_PASSWORD` is set (not `PALWORLD_ADMIN_PASSWORD`)
- [ ] `PORT=8211` (not `PALWORLD_PORT=8211`)
- [ ] All `PALWORLD_*` variables use correct case
- [ ] No typos in variable names
- [ ] Variables match `.env.example` format
- [ ] `TAILSCALE_AUTHKEY` is set if using Tailscale
- [ ] Passwords are not empty strings

## Support

If variables still aren't working:
1. Check this document for the correct name
2. Check `.env.example` for reference format
3. Review base image documentation: https://github.com/thijsvanloef/palworld-server-docker
4. Check Railway deployment logs for variable errors

