#!/bin/bash

# Digital Avatar - Avatar Upload Helper Script
# This script helps download and set up avatar videos

AVATAR_DIR="/workspace/digital-avatar-repo/usecases/ai/digital-avatar/assets/avatar-skins"
AVATAR_FILE="$AVATAR_DIR/default.mp4"

echo "========================================"
echo "Digital Avatar - Avatar Upload Helper"
echo "========================================"
echo ""

# Create directory if it doesn't exist
mkdir -p "$AVATAR_DIR"

# Check if avatar already exists
if [ -f "$AVATAR_FILE" ]; then
    echo "⚠️  An avatar video already exists at:"
    echo "   $AVATAR_FILE"
    echo ""
    ls -lh "$AVATAR_FILE"
    echo ""
    read -p "Do you want to replace it? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Upload cancelled."
        exit 0
    fi
fi

echo ""
echo "Choose upload method:"
echo ""
echo "1) Download from URL"
echo "2) Download sample stock video"
echo "3) Exit"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo ""
        read -p "Enter the direct download URL: " url
        if [ -z "$url" ]; then
            echo "❌ No URL provided. Exiting."
            exit 1
        fi

        echo ""
        echo "Downloading avatar video..."
        wget "$url" -O "$AVATAR_FILE"

        if [ $? -eq 0 ]; then
            echo "✅ Avatar video downloaded successfully!"
        else
            echo "❌ Download failed. Please check the URL and try again."
            exit 1
        fi
        ;;

    2)
        echo ""
        echo "Downloading sample stock video..."
        echo "(This is for testing purposes only)"
        echo ""

        # Download a sample talking head video
        # NOTE: This is a placeholder - replace with actual stock video URL
        wget "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" \
            -O "$AVATAR_FILE" 2>&1 | grep -v "%" || true

        if [ $? -eq 0 ]; then
            echo "✅ Sample video downloaded!"
            echo ""
            echo "⚠️  Note: This is just a test video."
            echo "   For best results, use a proper talking head video."
        else
            echo "❌ Download failed."
            exit 1
        fi
        ;;

    3)
        echo "Exiting."
        exit 0
        ;;

    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

# Verify the file
echo ""
echo "Verifying avatar video..."
if [ -f "$AVATAR_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$AVATAR_FILE" 2>/dev/null || stat -c%s "$AVATAR_FILE" 2>/dev/null)
    if [ $FILE_SIZE -gt 1000 ]; then
        echo "✅ Avatar video is ready!"
        echo ""
        echo "📁 Location: $AVATAR_FILE"
        echo "📊 Size: $(du -h "$AVATAR_FILE" | cut -f1)"
        echo ""
        echo "Next steps:"
        echo "1. Start the services: ./start-all-services.sh"
        echo "2. Access the app: http://39.114.73.97:3000"
        echo "3. Test your avatar!"
    else
        echo "⚠️  File seems too small. It might not be a valid video."
        echo "   Please check and try again."
    fi
else
    echo "❌ Avatar file not found. Something went wrong."
    exit 1
fi

echo ""
echo "========================================"
