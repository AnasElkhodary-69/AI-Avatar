#!/bin/bash

# Digital Avatar - Service Startup Script (Remote Access Enabled)
# This script starts all required services for the Digital Avatar application

set -e

BASE_DIR="/workspace/digital-avatar-repo/usecases/ai/digital-avatar"
MICROSERVICES_DIR="/workspace/digital-avatar-repo/usecases/ai/microservices"
VENV_PATH="$BASE_DIR/venv/bin/activate"

# Load environment variables
if [ -f "$BASE_DIR/.env" ]; then
    export $(cat "$BASE_DIR/.env" | grep -v '#' | xargs)
fi

echo "==================================="
echo "Starting Digital Avatar Services"
echo "Server IP: ${SERVER_IP:-39.114.73.97}"
echo "==================================="

# Activate virtual environment
source "$VENV_PATH"

# 1. Start PostgreSQL (if not running)
echo "[1/7] Starting PostgreSQL..."
if ! pgrep -x postgres > /dev/null; then
    service postgresql start
fi
echo "✓ PostgreSQL started"

# 2. Start Ollama (if not running)
echo "[2/7] Starting Ollama..."
if ! pgrep -x ollama > /dev/null; then
    OLLAMA_HOST=0.0.0.0:${OLLAMA_PORT:-11434} ollama serve > /tmp/ollama.log 2>&1 &
    sleep 3
fi
echo "✓ Ollama started on 0.0.0.0:${OLLAMA_PORT:-11434}"

# 3. Start Lipsync Service (Wav2Lip)
echo "[3/7] Starting Lipsync Service (Wav2Lip)..."
cd "$BASE_DIR/backend/wav2lip"
SERVER_HOST=0.0.0.0 SERVER_PORT=${WAV2LIP_PORT:-8011} python main.py > /tmp/lipsync.log 2>&1 &
echo $! > /tmp/lipsync.pid
sleep 2
echo "✓ Lipsync started on 0.0.0.0:${WAV2LIP_PORT:-8011}"

# 4. Start TTS Service (Kokoro-TTS)
echo "[4/7] Starting TTS Service..."
cd "$MICROSERVICES_DIR/kokoro-tts"
SERVER_HOST=0.0.0.0 SERVER_PORT=${TTS_PORT:-8013} python main.py > /tmp/tts.log 2>&1 &
echo $! > /tmp/tts.pid
sleep 2
echo "✓ TTS started on 0.0.0.0:${TTS_PORT:-8013}"

# 5. Start STT Service (Whisper) - Already configured for 0.0.0.0
echo "[5/7] Starting STT Service..."
cd "$MICROSERVICES_DIR/speech-to-text"
python main.py > /tmp/stt.log 2>&1 &
echo $! > /tmp/stt.pid
sleep 2
echo "✓ STT started on 0.0.0.0:${STT_PORT:-5996}"

# 6. Start RAG Backend
echo "[6/7] Starting RAG Backend..."
cd "$BASE_DIR/backend/rag-backend"
SERVER_HOST=0.0.0.0 SERVER_PORT=${RAG_PORT:-8012} python main.py > /tmp/rag.log 2>&1 &
echo $! > /tmp/rag.pid
sleep 3
echo "✓ RAG Backend started on 0.0.0.0:${RAG_PORT:-8012}"

# 7. Start Frontend
echo "[7/7] Starting Frontend..."
cd "$BASE_DIR/frontend"
PORT=${FRONTEND_PORT:-3000} npm run dev > /tmp/frontend.log 2>&1 &
echo $! > /tmp/frontend.pid
sleep 3
echo "✓ Frontend started on 0.0.0.0:${FRONTEND_PORT:-3000}"

echo ""
echo "==================================="
echo "All Services Started Successfully!"
echo "==================================="
echo ""
echo "🌐 Access your Digital Avatar from anywhere:"
echo ""
echo "  Frontend:        http://${SERVER_IP:-39.114.73.97}:${FRONTEND_PORT:-3000}"
echo "  RAG Backend:     http://${SERVER_IP:-39.114.73.97}:${RAG_PORT:-8012}"
echo "  Lipsync:         http://${SERVER_IP:-39.114.73.97}:${WAV2LIP_PORT:-8011}"
echo "  TTS:             http://${SERVER_IP:-39.114.73.97}:${TTS_PORT:-8013}"
echo "  STT:             http://${SERVER_IP:-39.114.73.97}:${STT_PORT:-5996}"
echo "  Ollama:          http://${SERVER_IP:-39.114.73.97}:${OLLAMA_PORT:-11434}"
echo ""
echo "📋 Logs are in /tmp/*.log"
echo "🛑 To stop all services, run: ./stop-all-services.sh"
echo ""
echo "⚠️  Make sure these ports are open in your firewall:"
echo "   ${FRONTEND_PORT:-3000}, ${RAG_PORT:-8012}, ${WAV2LIP_PORT:-8011}, ${TTS_PORT:-8013}, ${STT_PORT:-5996}, ${OLLAMA_PORT:-11434}"
echo ""
