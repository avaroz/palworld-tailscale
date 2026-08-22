# Tailscale Configuration Guide

This document explains how to set up and configure Tailscale for your Palworld server.

## What is Tailscale?

Tailscale is a VPN service that creates a secure mesh network between your devices. By using Tailscale with your Palworld server, you can:
- Access your server through a private VPN connection
- Bypass firewall restrictions
- Play securely without exposing your server to the public internet
- Access from anywhere with an internet connection

## Prerequisites

1. A Tailscale account (free at https://tailscale.com)
2. Access to your Tailscale admin panel (https://login.tailscale.com/admin)

## Step-by-Step Setup

### Step 1: Generate Tailscale Auth Key

1. Go to https://login.tailscale.com/admin/settings/keys
2. Click **"Generate auth key"** button
3. Configure the key options:
   - ☑️ **Reusable** - Allow the same key to be used multiple times (recommended for servers)
   - ☑️ **Ephemeral** - Optional: Auto-remove device when disconnected (recommended for containers)
   - Optionally set an expiration date
4. Click **"Generate key"**
5. **Copy the key** - It will look like: `tskey-auth-XXXXXXXXXXXXXXXXXXXXX`

### Step 2: Add to Railway

#### Option A: Dashboard Configuration (Recommended)

1. Go to your Railway project: https://railway.com/project/8c6ce7ea-cfc7-48cd-88ea-6b5b332886ad
2. Select the `palworld-tailscale` service
3. Go to **Variables** section
4. Add a new variable:
   - **Name**: `TAILSCALE_AUTHKEY`
   - **Value**: Paste your auth key (tskey-auth-XXXXX)
5. Railway will automatically trigger a redeploy
6. Check the deployment logs to confirm connection

#### Option B: Local Development

1. Add to your `.env` file:
   ```bash
   TAILSCALE_AUTHKEY=tskey-auth-XXXXXXXXXXXXXXXXXXXXX
   ```

2. Build and run:
   ```bash
   docker build -t palworld-server .
   docker run -it --env-file .env palworld-server
   ```

### Step 3: Verify Tailscale Connection

1. Go to https://login.tailscale.com/admin/machines
2. Look for a device named **"palworld-server"** in your machines list
3. Once it appears and shows as "Online", Tailscale is working!

## Using Your Tailscale Server

### Connect to Your Server

Once the server appears in your Tailscale machines:

1. **Install Tailscale** on your client device:
   - Windows: https://tailscale.com/download/windows
   - macOS: https://tailscale.com/download/macos
   - Linux: https://tailscale.com/download/linux
   - Mobile: Search "Tailscale" in your app store

2. **Connect to Tailscale** on your client device

3. **Find your server's IP address**:
   - Go to https://login.tailscale.com/admin/machines
   - Find "palworld-server"
   - Copy its Tailscale IP (looks like: 100.x.x.x)

4. **Add to Palworld**:
   - In Palworld, go to Join Server
   - Server address: `100.x.x.x:8211` (use the Tailscale IP and port)
   - Password: Use your `PALWORLD_SERVER_PASSWORD`

### Example Connection

If your Tailscale IP is `100.64.123.45`:
```
Server Address: 100.64.123.45
Port: 8211
Password: [Your PALWORLD_SERVER_PASSWORD]
```

## Troubleshooting

### Server Not Appearing in Tailscale Machines

**Problem**: You've set the auth key but the server doesn't appear in your machines list

**Solutions**:
1. **Check Railway logs**:
   - Go to your service in Railway
   - Look at Deployment logs
   - Should show: `Tailscale connected successfully`

2. **Verify auth key is correct**:
   - Make sure the key starts with `tskey-auth-`
   - Check for copy/paste errors
   - Regenerate key if unsure

3. **Check if key expired**:
   - Go to https://login.tailscale.com/admin/settings/keys
   - Verify the key hasn't exceeded its expiration date
   - Generate a new key if needed

4. **Redeploy the service**:
   - Make a small change to trigger redeploy (e.g., add a space to a variable comment)
   - Or manually redeploy from Railway dashboard

### Can't Connect to Server via Tailscale

**Problem**: Machine appears online but you can't connect to the Palworld server

**Solutions**:
1. **Verify both devices are on Tailscale**:
   - Check client device is connected (Tailscale icon shows orange)
   - Check server appears in your machines list

2. **Test Tailscale connectivity**:
   ```bash
   ping 100.x.x.x  # Replace with server's Tailscale IP
   ```
   If ping fails, Tailscale isn't properly connected

3. **Check Palworld port**:
   - Ensure `PALWORLD_PORT=8211` is set
   - Try connecting to: `100.x.x.x:8211`

4. **Check server is running**:
   - Go to Railway dashboard
   - Verify service status is "Online"
   - Check deployment logs for errors

### High Latency or Connection Drops

**Problem**: Playing through Tailscale but experiencing lag or disconnections

**Solutions**:
1. **Use Tailscale Speed Test**:
   - Go to https://speed.tailscale.com
   - Measure latency to your server region

2. **Check network stability**:
   - Are you using WiFi or ethernet?
   - Run `ping` tests to rule out connection issues

3. **Consider using direct connection** (if server is publicly accessible):
   - Tailscale adds some latency compared to direct IP
   - For best performance, expose server publicly and use direct IP

## Security Considerations

### Auth Key Best Practices

1. **Use reusable keys for servers** ✓
2. **Use ephemeral keys for containers** ✓ (auto-remove when offline)
3. **Set key expiration dates** - Rotate keys periodically
4. **Regenerate if compromised** - Delete old key and create new one

### Access Control

1. Go to https://login.tailscale.com/admin/acls
2. Set up ACL rules to:
   - Allow only specific devices to access Palworld
   - Restrict who can connect to your network
   - Set different rules for different devices

## Advanced Configuration

### Disable Tailscale

To run without Tailscale:

1. Remove `TAILSCALE_AUTHKEY` variable from Railway
2. Redeploy
3. Server will start but won't join Tailscale network

### Custom Hostname

To change the hostname from "palworld-server", edit `entrypoint.sh`:
```bash
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=my-custom-name
```

## Additional Resources

- Tailscale Documentation: https://tailscale.com/kb/
- Tailscale Admin Panel: https://login.tailscale.com/admin
- Tailscale Networking Guide: https://tailscale.com/kb/1076/

## Support

For Tailscale-specific issues:
- Tailscale Support: https://tailscale.com/support
- Tailscale GitHub Issues: https://github.com/tailscale/tailscale/issues

For Palworld server issues:
- Create a GitHub issue in this repository

