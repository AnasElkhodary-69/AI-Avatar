# Digital Avatar - Remote Access Guide

## Server Information

**Server IP Address:** `39.114.73.97`

All services are configured to bind to `0.0.0.0` (all network interfaces) so they can be accessed remotely.

---

## Required Firewall Ports

Make sure the following ports are open in your firewall/security group:

| Service | Port | Protocol | Description |
|---------|------|----------|-------------|
| Frontend | 3000 | TCP | Next.js Web UI |
| RAG Backend | 8012 | TCP | LLM & RAG Service |
| Lipsync | 8011 | TCP | Wav2Lip Service |
| TTS | 8013 | TCP | Text-to-Speech |
| STT | 5996 | TCP | Speech-to-Text |
| Ollama | 11434 | TCP | LLM Inference |

### Opening Ports (Ubuntu/Debian with UFW)

```bash
# Allow specific ports
sudo ufw allow 3000/tcp
sudo ufw allow 8012/tcp
sudo ufw allow 8011/tcp
sudo ufw allow 8013/tcp
sudo ufw allow 5996/tcp
sudo ufw allow 11434/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

### Opening Ports (Cloud Provider)

If you're using a cloud provider (AWS, GCP, Azure, etc.):

1. Go to your instance's **Security Group** or **Firewall Rules**
2. Add **Inbound Rules** for the ports listed above
3. Set source to `0.0.0.0/0` for public access (or restrict to your IP)

---

## Access URLs

Once services are running, access them from **any device on the network** or **internet**:

### Main Application
```
http://39.114.73.97:3000
```

### API Endpoints

**RAG Backend:**
```
http://39.114.73.97:8012
```

**Lipsync Service:**
```
http://39.114.73.97:8011
```

**TTS Service:**
```
http://39.114.73.97:8013
```

**STT Service:**
```
http://39.114.73.97:5996
```

**Ollama:**
```
http://39.114.73.97:11434
```

---

## Starting Services

```bash
cd /workspace/digital-avatar-repo/usecases/ai/digital-avatar
./start-all-services.sh
```

The script will:
1. Load environment variables from `.env`
2. Start all services bound to `0.0.0.0`
3. Display access URLs with your server IP

---

## Stopping Services

```bash
cd /workspace/digital-avatar-repo/usecases/ai/digital-avatar
./stop-all-services.sh
```

---

## Checking Service Status

### View Logs
```bash
# View all logs
tail -f /tmp/*.log

# View specific service
tail -f /tmp/frontend.log
tail -f /tmp/rag.log
tail -f /tmp/lipsync.log
tail -f /tmp/tts.log
tail -f /tmp/stt.log
tail -f /tmp/ollama.log
```

### Check if Services are Running
```bash
# Check all running processes
ps aux | grep -E 'node|python|ollama'

# Check specific ports
netstat -tlnp | grep -E '3000|8011|8012|8013|5996|11434'
```

---

## Troubleshooting

### Cannot Access from Remote Machine

1. **Check if services are running:**
   ```bash
   ps aux | grep -E 'node|python|ollama'
   ```

2. **Verify services are bound to 0.0.0.0:**
   ```bash
   netstat -tlnp | grep -E '3000|8011|8012|8013|5996|11434'
   ```
   Look for `0.0.0.0:<port>` not `127.0.0.1:<port>`

3. **Check firewall rules:**
   ```bash
   sudo ufw status
   ```

4. **Test connectivity from server:**
   ```bash
   curl http://localhost:3000
   curl http://localhost:8012
   ```

5. **Test from remote machine:**
   ```bash
   curl http://39.114.73.97:3000
   telnet 39.114.73.97 3000
   ```

### Service Won't Start

Check logs for errors:
```bash
cat /tmp/<service>.log
```

Common issues:
- Port already in use
- Missing dependencies
- Incorrect environment variables

### Performance Issues

If the server is slow:
1. Check CPU usage: `top` or `htop`
2. Check memory: `free -h`
3. Check disk space: `df -h`
4. Review service logs for errors

---

## Security Considerations

⚠️ **Important Security Notes:**

1. **Change default passwords** in `.env`:
   - `POSTGRES_PASSWORD`
   - `FRONTEND_PAYLOAD_SECRET`

2. **Restrict access** by IP if possible:
   - Configure firewall to only allow specific IPs
   - Use VPN for secure access

3. **Use HTTPS** in production:
   - Set up reverse proxy (nginx/Apache)
   - Install SSL certificates (Let's Encrypt)

4. **Monitor logs** regularly:
   ```bash
   tail -f /tmp/*.log
   ```

5. **Keep services updated:**
   ```bash
   cd /workspace/digital-avatar-repo/usecases/ai/digital-avatar
   source venv/bin/activate
   pip install --upgrade -r backend/wav2lip/requirements.txt
   pip install --upgrade -r backend/rag-backend/requirements.txt
   ```

---

## Production Deployment (Optional)

For production use, consider:

1. **Process Manager** (PM2 for Node, systemd for Python)
2. **Reverse Proxy** (nginx with SSL)
3. **Domain Name** (instead of IP address)
4. **Load Balancer** (for multiple instances)
5. **Monitoring** (Prometheus, Grafana)
6. **Backup Strategy** (database, models, config)

---

## Support

For issues or questions:
- Check logs: `/tmp/*.log`
- Review GitHub Issues: https://github.com/intel/edge-developer-kit-reference-scripts/issues
- Documentation: Check README files in each service directory

---

## Quick Reference

| Task | Command |
|------|---------|
| Start all services | `./start-all-services.sh` |
| Stop all services | `./stop-all-services.sh` |
| View logs | `tail -f /tmp/*.log` |
| Check status | `ps aux \| grep -E 'node\|python\|ollama'` |
| Access frontend | `http://39.114.73.97:3000` |
| Open firewall ports | `sudo ufw allow <port>/tcp` |

---

**Last Updated:** 2025-09-30
**Server IP:** 39.114.73.97
