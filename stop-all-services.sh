#!/bin/bash

# Digital Avatar - Service Stop Script

echo "Stopping all Digital Avatar services..."

# Stop services by PID files
for service in lipsync tts stt rag frontend; do
    if [ -f "/tmp/${service}.pid" ]; then
        PID=$(cat /tmp/${service}.pid)
        if ps -p $PID > /dev/null 2>&1; then
            echo "Stopping $service (PID: $PID)..."
            kill $PID
            rm /tmp/${service}.pid
        fi
    fi
done

# Stop Ollama
if pgrep -x ollama > /dev/null; then
    echo "Stopping Ollama..."
    pkill ollama
fi

# Optionally stop PostgreSQL
# service postgresql stop

echo "All services stopped."
