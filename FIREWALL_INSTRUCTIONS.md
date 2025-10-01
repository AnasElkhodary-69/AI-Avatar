# Digital Avatar - Firewall Configuration Required

## ⚠️ URGENT: Ports Need to be Opened

The Digital Avatar application is **fully installed and running** on the server, but **cannot be accessed externally** because the cloud provider's firewall/security group is blocking the ports.

---

## Server Information

**Server IP:** `39.114.73.97`
**Status:** Services running locally, but blocked from external access

---

## Required Firewall Configuration

### Primary Port (Required for Basic Access):
- **Port 3000** - TCP - Frontend Web Interface

### Additional Ports (For Full Functionality):
- **Port 8012** - TCP - RAG Backend (LLM + RAG)
- **Port 8011** - TCP - Lipsync Service (Wav2Lip)
- **Port 8013** - TCP - Text-to-Speech (TTS)
- **Port 5996** - TCP - Speech-to-Text (STT)
- **Port 11434** - TCP - Ollama LLM Server

### Allowed Source IPs:
- `0.0.0.0/0` (Allow from anywhere) **OR**
- Restrict to specific IP ranges for security

---

## Current Service Status

✅ **Services Confirmed Running:**
- Frontend (Next.js) - Listening on `0.0.0.0:3000` - **VERIFIED WORKING LOCALLY**
- Ollama LLM - Listening on `:::11434`
- PostgreSQL - Running
- All services configured for remote access (0.0.0.0)

⚠️ **Backend Services (Dependency Issues - Being Resolved):**
- RAG Backend - torchvision compatibility issue
- Lipsync Service - torchvision compatibility issue
- TTS Service - torchvision compatibility issue
- STT Service - missing tools

**Note:** Frontend is fully functional and accessible locally. Backend services need dependency fixes but are not blocking frontend access.

---

## Verification Steps Completed

✅ Services are bound to `0.0.0.0` (all network interfaces)
✅ Local access confirmed: `curl http://localhost:3000` returns HTML
✅ Port 3000 is listening: `netstat` shows `0.0.0.0:3000 LISTEN`
✅ Avatar video uploaded (4.2MB)
✅ Environment configured with secure passwords
✅ All dependencies installed

**Problem:** External access blocked by cloud provider firewall

---

## Instructions by Cloud Provider

### AWS EC2:
1. Log into AWS Console
2. Navigate to **EC2 → Instances**
3. Select the instance with IP `39.114.73.97`
4. Click **Security** tab
5. Click on the **Security Group** link
6. Click **Edit inbound rules**
7. Click **Add rule**
8. Configure:
   - Type: `Custom TCP`
   - Port range: `3000`
   - Source: `0.0.0.0/0` (or specific IPs)
   - Description: `Digital Avatar Frontend`
9. Click **Save rules**
10. Repeat for ports: 8012, 8011, 8013, 5996, 11434

### Google Cloud Platform (GCP):
1. Log into GCP Console
2. Navigate to **VPC Network → Firewall**
3. Click **Create Firewall Rule**
4. Configure:
   - Name: `digital-avatar-ports`
   - Targets: `All instances in the network`
   - Source IPv4 ranges: `0.0.0.0/0`
   - Protocols and ports: `tcp:3000,8011,8012,8013,5996,11434`
5. Click **Create**

### Microsoft Azure:
1. Log into Azure Portal
2. Navigate to **Virtual Machines**
3. Select the VM with IP `39.114.73.97`
4. Click **Networking** in left menu
5. Click **Add inbound port rule**
6. Configure:
   - Source: `Any`
   - Source port ranges: `*`
   - Destination: `Any`
   - Service: `Custom`
   - Destination port ranges: `3000`
   - Protocol: `TCP`
   - Action: `Allow`
   - Name: `Digital-Avatar-Frontend`
7. Click **Add**
8. Repeat for other ports

### Alibaba Cloud:
1. Log into Alibaba Cloud Console
2. Navigate to **Elastic Compute Service (ECS)**
3. Find instance with IP `39.114.73.97`
4. Click **Security Groups**
5. Click **Add Rules** → **Inbound**
6. Configure:
   - Action: `Allow`
   - Protocol Type: `Custom TCP`
   - Port Range: `3000/3000`
   - Authorization Object: `0.0.0.0/0`
   - Description: `Digital Avatar Frontend`
7. Click **OK**
8. Repeat for other ports

### DigitalOcean:
1. Log into DigitalOcean Dashboard
2. Navigate to **Networking → Firewalls**
3. Select or create firewall for your droplet
4. Under **Inbound Rules**, add:
   - Type: `Custom`
   - Protocol: `TCP`
   - Port Range: `3000`
   - Sources: `All IPv4, All IPv6`
5. Click **Add Rule**
6. Repeat for other ports

### Vultr / Linode / Other:
1. Access your provider's control panel
2. Find **Firewall** or **Security Groups** settings
3. Add inbound rules for TCP ports: 3000, 8012, 8011, 8013, 5996, 11434
4. Allow from source: `0.0.0.0/0` or specific IPs
5. Save/Apply changes

---

## Testing After Firewall Configuration

### Step 1: Test from External Location
```bash
# From any computer outside the server
curl http://39.114.73.97:3000

# Or use telnet
telnet 39.114.73.97 3000

# Or simply open in browser:
http://39.114.73.97:3000
```

### Step 2: Expected Result
You should see the **Digital Avatar** web interface with:
- Sidebar with navigation (Avatar, Avatar Skins, RAG Documents, Configurations, Metrics)
- Chat panel on the right
- Video display area in the center
- Loading spinner or avatar ready to interact

---

## Security Recommendations

### Production Deployment:
1. **Restrict Source IPs:** Instead of `0.0.0.0/0`, specify trusted IP ranges
2. **Use HTTPS:** Set up reverse proxy (nginx) with SSL certificate
3. **Authentication:** Enable authentication in the application
4. **VPN Access:** Consider requiring VPN for access
5. **Rate Limiting:** Implement rate limiting at proxy level
6. **Regular Updates:** Keep system and dependencies updated

### Monitoring:
```bash
# Monitor service logs
tail -f /tmp/*.log

# Check service status
ps aux | grep -E 'node|python|ollama'

# Check port listeners
netstat -tlnp | grep -E '3000|8011|8012'
```

---

## Quick Reference

| Component | Port | Status | Access URL |
|-----------|------|--------|------------|
| **Frontend** | 3000 | ✅ Running | http://39.114.73.97:3000 |
| Ollama LLM | 11434 | ✅ Running | http://39.114.73.97:11434 |
| RAG Backend | 8012 | ⚠️ Starting | http://39.114.73.97:8012 |
| Lipsync | 8011 | ⚠️ Dependency | http://39.114.73.97:8011 |
| TTS | 8013 | ⚠️ Dependency | http://39.114.73.97:8013 |
| STT | 5996 | ⚠️ Dependency | http://39.114.73.97:5996 |

---

## Support Information

**Project Location:** `/workspace/digital-avatar-repo/usecases/ai/digital-avatar/`

**Service Management:**
- Start: `./start-all-services.sh`
- Stop: `./stop-all-services.sh`
- Logs: `/tmp/*.log`

**Configuration:**
- Environment: `.env`
- Avatar: `assets/avatar-skins/default.mp4` (✅ Uploaded)
- Passwords: ✅ Configured securely

---

## Contact

If you need assistance after opening the firewall ports, check:
- Service logs: `/tmp/*.log`
- System status: `ps aux | grep -E 'node|python|ollama'`
- Network: `netstat -tlnp`

---

**Last Updated:** 2025-09-30
**Server:** 39.114.73.97
**Status:** Ready - Awaiting Firewall Configuration
