# Troubleshooting Guide - Palworld Server

This guide documents common issues and their solutions.

## Error: "REST accessed endpoint / Unauthorized (AdminPassword is empty)"

### What This Means
The Palworld REST API is rejecting requests because the admin password is not configured or incorrect.

### Root Cause

**This is usually caused by using the WRONG variable name:**
- ❌ `PALWORLD_ADMIN_PASSWORD` (WRONG - will not work)
- ✅ `ADMIN_PASSWORD` (CORRECT - base image expects this name)

### Solution

#### Step 1: Identify the Current Variable
Go to Railway dashboard → your service → Variables tab

Look for the variable. If you see:
- `PALWORLD_ADMIN_PASSWORD` → This is WRONG, delete it
- `ADMIN_PASSWORD` → This is correct, but may be misconfigured

#### Step 2: Remove Incorrect Variable (if present)
If `PALWORLD_ADMIN_PASSWORD` exists:
1. Go to Variables
2. Delete `PALWORLD_ADMIN_PASSWORD`
3. Do NOT replace it yet

#### Step 3: Add Correct Variable
1. Click "New Variable"
2. Name: `ADMIN_PASSWORD` (exact case)
3. Value: `${{ secret(16) }}` (generates random secure password)
   - OR use your own: `MySecurePassword123!`
4. Save

#### Step 4: Redeploy
1. Click "Redeploy" button in Railway
2. Wait for deployment to complete
3. Check logs for: `Admin password is configured`

### Verification

After redeploy, check the logs:
```
[LOG] Starting Palworld server...
Admin password is configured
Running Palworld dedicated server on :8081
```

If you still see the error, your deployment didn't apply the variable correctly. Retry steps 1-4.

## Error: Port Already in Use

### What This Means
The port 8211 or 27015 is already being used by another process.

### Solution

1. **Check if another container is running:**
   ```bash
   docker ps
   ```

2. **Stop conflicting container:**
   ```bash
   docker stop <container-id>
   docker rm <container-id>
   ```

3. **Or use different ports in `.env`:**
   ```bash
   PORT=8212
   QUERY_PORT=27016
   ```

## Error: Connection Refused

### What This Means
Players cannot connect to the server even though it's running.

### Causes and Solutions

#### Issue 1: Ports Not Exposed
Check Railway configuration:
1. Go to your service settings
2. Verify ports 8211/udp and 27015/udp are exposed
3. If missing, add them and redeploy

#### Issue 2: Server Not Fully Booted
The server takes time to start (1-3 minutes).
- Check deployment logs
- Wait for "Running Palworld dedicated server" message

#### Issue 3: Firewall Blocking
If using Tailscale:
1. Verify server appears in https://login.tailscale.com/admin/machines
2. Use Tailscale IP: `100.x.x.x:8211`

If public access:
1. Check your ISP/firewall settings
2. Verify port forwarding if needed

## Server Not Appearing in Palworld Server List

### Causes and Solutions

#### Issue 1: Query Port Wrong
The query port defaults to 27015. Check:
1. Go to Variables
2. Verify no `PALWORLD_QUERY_PORT` variable (use `QUERY_PORT`)
3. Or verify `QUERY_PORT=27015`

#### Issue 2: Server Not Fully Loaded
The server takes time to appear (2-5 minutes).
- Check logs for "Running Palworld server"
- Wait and refresh server list

#### Issue 3: Using Tailscale Only
Public servers won't appear if only Tailscale is set up.
- Add your server to Tailscale network
- Connect clients via Tailscale VPN
- Use Tailscale IP: `100.x.x.x:8211`

## Tailscale Connection Issues

### Server Not Appearing in Tailscale Machines

See [TAILSCALE_SETUP.md](TAILSCALE_SETUP.md) for detailed troubleshooting.

#### Quick Checks
1. Verify `TAILSCALE_AUTHKEY` is set (not empty)
2. Check logs for "Tailscale connected successfully"
3. Verify auth key hasn't expired
4. Check https://login.tailscale.com/admin/machines

## Performance Issues

### Server Running Slowly / High Latency

#### Solutions

1. **Reduce spawn rate:**
   ```
   PALWORLD_PAL_SPAWN_NUM_RATE=0.7
   ```

2. **Reduce item limit:**
   ```
   PALWORLD_DROP_ITEM_MAX_NUM=2000
   ```

3. **Check Railway resources:**
   - Go to service metrics
   - Check CPU and memory usage
   - If maxed out, upgrade plan

4. **Use Tailscale instead of public:**
   - Tailscale adds latency vs direct IP
   - For best performance, use direct connection if possible

### Out of Memory

Symptoms: Server crashes or slow response

Solutions:
1. Reduce `PALWORLD_PAL_SPAWN_NUM_RATE`
2. Reduce `PALWORLD_DROP_ITEM_MAX_NUM`
3. Reduce `PALWORLD_MAX_PLAYERS`
4. Check Railway memory allocation
5. Upgrade to higher plan if needed

## Configuration Issues

### Game Settings Not Applied

**Cause:** Wrong variable name

**Solution:** See `VARIABLE_NAMING.md` for correct names.

**Example:**
```
❌ PALWORLD_MAX_PLAYERS=32
✅ PALWORLD_MAX_PLAYERS=32

❌ MAX_PLAYERS=32
✅ PALWORLD_MAX_PLAYERS=32

❌ max_players=32 (wrong case)
✅ PALWORLD_MAX_PLAYERS=32
```

### Server Name Not Changing

**Cause:** Using `PALWORLD_SERVER_NAME` instead of `SERVER_NAME`

**Solution:**
```
❌ PALWORLD_SERVER_NAME=My Server
✅ SERVER_NAME=My Server
```

### Password Not Working

**Cause:** Wrong variable names or empty password

**Solution:**
1. Check `ADMIN_PASSWORD` is set (for REST API)
2. Check `SERVER_PASSWORD` is set (for joining)
3. Use quotes for passwords with spaces:
   ```
   SERVER_PASSWORD="My Password 123"
   ```

## Docker Local Deployment Issues

### Build Fails

**Error:** "Failed to build image"

**Solutions:**
1. Ensure Dockerfile is valid
2. Check internet connection (downloads base image)
3. Ensure Docker daemon is running
4. Try rebuild: `docker build --no-cache -t palworld-server .`

### Container Exits Immediately

**Cause:** ADMIN_PASSWORD not set

**Solution:**
```bash
docker run \
  -e ADMIN_PASSWORD="myPassword123" \
  -e TAILSCALE_AUTHKEY="tskey-auth-..." \
  -p 8211:8211/udp \
  -p 27015:27015/udp \
  palworld-server
```

### Can't Connect to Container Server

**Solutions:**
1. Verify ports are published: `docker ps`
2. Check firewall: `sudo ufw allow 8211/udp`
3. Use `localhost:8211` or `127.0.0.1:8211`

## Railway Specific Issues

### Deployment Fails

**Solutions:**
1. Check deployment logs for error message
2. Verify all variable names are correct
3. Ensure `ADMIN_PASSWORD` is set
4. Redeploy from main branch

### Variables Not Applying

**Solutions:**
1. Go to Variables section
2. Click "Redeploy" button
3. Wait for new deployment to complete
4. Verify changes in logs

### Out of Credits

**Solutions:**
1. Check account billing
2. Add payment method
3. Upgrade plan
4. Check usage limits

## Getting Help

### Before Asking for Help

1. Check this troubleshooting guide
2. Check `VARIABLE_NAMING.md` for variable names
3. Check `TAILSCALE_SETUP.md` for VPN issues
4. Check `.env.example` for configuration options
5. Review deployment logs

### How to Report Issues

When creating a GitHub issue, include:

1. **Error message:** Exact error text from logs
2. **Current variables:** List your configuration
3. **Steps to reproduce:** How to recreate the issue
4. **Environment:** Railway / Docker / Local
5. **Logs:** Relevant log output

### Example Issue Report

```
Title: Server shows "Unauthorized (AdminPassword is empty)" error

Error Message:
[LOG] REST accessed endpoint / Unauthorized (AdminPassword is empty)

Current Configuration:
- ADMIN_PASSWORD=testpass123 ✅
- TAILSCALE_AUTHKEY=tskey-auth-... ✅
- PALWORLD_MAX_PLAYERS=32 ✅

Steps:
1. Deployed service on Railway
2. Redeployed after adding ADMIN_PASSWORD
3. Still see error in logs

Environment: Railway / Ubuntu

Additional Context:
Deployment ID: 34d8fa20-e559-4d6c-b7bb-0973ae2f05f5
```

## Common Questions

### Q: Do I need to use Tailscale?
**A:** No, it's optional. Use it if you want a private VPN connection. You can use public access instead.

### Q: Can I change the port?
**A:** Yes, change `PORT=8211` to any available port.

### Q: How many players can I have?
**A:** Set with `PALWORLD_MAX_PLAYERS`. Default is 32. Check server load.

### Q: Can I enable PvP?
**A:** Yes, set `PALWORLD_IS_PVPABLE=true`

### Q: Where is my game data stored?
**A:** In the container's `/palworld` directory. Add a volume if you need persistence.

### Q: How do I backup my world?
**A:** Add backup settings to `.env`:
```
BACKUP_ENABLED=true
BACKUP_CRON_EXPRESSION=0 2 * * *
```

## Still Having Issues?

1. Check the error message carefully
2. Search this document
3. Check `VARIABLE_NAMING.md`
4. Review base image documentation: https://github.com/thijsvanloef/palworld-server-docker
5. Create a detailed GitHub issue with logs and configuration

