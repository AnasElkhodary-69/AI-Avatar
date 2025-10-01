#!/bin/bash

# Digital Avatar - Firewall Setup Script
# Opens required ports for remote access

echo "========================================="
echo "Digital Avatar - Firewall Configuration"
echo "========================================="
echo ""

# Check if ufw is installed
if ! command -v ufw &> /dev/null; then
    echo "UFW (Uncomplicated Firewall) is not installed."
    echo "Installing UFW..."
    apt-get update && apt-get install -y ufw
fi

echo "Opening required ports..."
echo ""

# Open ports
echo "→ Opening port 3000 (Frontend)..."
ufw allow 3000/tcp

echo "→ Opening port 8012 (RAG Backend)..."
ufw allow 8012/tcp

echo "→ Opening port 8011 (Lipsync)..."
ufw allow 8011/tcp

echo "→ Opening port 8013 (TTS)..."
ufw allow 8013/tcp

echo "→ Opening port 5996 (STT)..."
ufw allow 5996/tcp

echo "→ Opening port 11434 (Ollama)..."
ufw allow 11434/tcp

echo ""
echo "Firewall rules configured!"
echo ""

# Show current status
echo "Current firewall status:"
ufw status

echo ""
echo "========================================="
echo "Firewall setup complete!"
echo "========================================="
echo ""
echo "Access your Digital Avatar at:"
echo "  http://39.114.73.97:3000"
echo ""
