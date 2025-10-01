# Avatar Video Setup Guide

## What is an Avatar Video?

The avatar video is the face/person that will be animated with lip-sync to speak your AI's responses. This is the core visual element of your Digital Avatar.

---

## Avatar Video Requirements

### Technical Specifications

✅ **Format:** MP4 (H.264 codec recommended)
✅ **Resolution:** Minimum 720p (1280x720), Recommended 1080p (1920x1080)
✅ **Duration:** 5-30 seconds (the system will loop if needed)
✅ **Frame Rate:** 25-30 fps
✅ **Audio:** Not required (will be removed/replaced)

### Content Guidelines

**BEST PRACTICES:**
- **Frontal face view** - Person looking directly at camera
- **Good lighting** - Well-lit, even lighting on face
- **Neutral expression** - Slight smile or neutral face
- **Minimal movement** - Person should be mostly still (slight breathing is OK)
- **Plain background** - Solid color or simple background
- **High quality** - Clear, sharp video without blur
- **Close-up or medium shot** - Face should be clearly visible

**AVOID:**
- Side angles or profile shots
- Dark or poorly lit footage
- Excessive head movements
- Busy/distracting backgrounds
- Sunglasses or face coverings
- Low resolution or blurry video
- Fast movements or gestures

---

## Avatar Options

### Option 1: Use Your Own Face/Image

**YES!** You can use your personal image/video. This creates a personalized avatar that looks like you.

**How to create:**

**Method A: Record a Video**
1. Use your phone or webcam
2. Set up good lighting
3. Look directly at camera
4. Stay mostly still, neutral expression
5. Record 10-20 seconds
6. Export/save as MP4

**Method B: Convert Photo to Video**
1. Take a high-quality photo (frontal, well-lit)
2. Use a tool to convert photo to video:
   ```bash
   # Using ffmpeg (if installed)
   ffmpeg -loop 1 -i your_photo.jpg -c:v libx264 -t 10 -pix_fmt yuv420p -vf scale=1280:720 your_avatar.mp4
   ```

**Method C: Use AI to Generate from Photo**
- Tools like D-ID, Synthesia can create talking head videos from a single photo
- Follow their export instructions and save as MP4

### Option 2: Use Stock Footage

Download royalty-free stock footage of a person:
- **Pexels**: https://www.pexels.com/videos/
- **Pixabay**: https://pixabay.com/videos/
- **Unsplash**: https://unsplash.com/

Search for: "person talking camera", "portrait video", "headshot video"

### Option 3: Use Provided Sample (Demo Only)

For testing, you can use sample videos from the project's examples or create a simple test video.

---

## Uploading Your Avatar Video

Since you don't have direct file access, here are **3 methods** to upload:

### Method 1: Upload via URL (Recommended)

If your video is online (Google Drive, Dropbox, direct URL):

```bash
# I'll download it for you
# Just provide the direct download URL
```

**Example:**
```bash
wget "YOUR_VIDEO_URL" -O /workspace/digital-avatar-repo/usecases/ai/digital-avatar/assets/avatar-skins/default.mp4
```

### Method 2: Base64 Encoding

If you have a small video file (<10MB):
1. Encode it to base64 on your computer
2. Share the base64 string with me
3. I'll decode and save it

### Method 3: Upload After Services Start

Once services are running, you can upload via the web interface:
1. Start the services
2. Access http://39.114.73.97:3000
3. Use the admin panel to upload avatar video

---

## File Structure

Your avatar video should be placed at:
```
/workspace/digital-avatar-repo/usecases/ai/digital-avatar/assets/avatar-skins/default.mp4
```

You can have multiple avatars:
```
assets/avatar-skins/
├── default.mp4          # Main avatar
├── professional.mp4     # Alternative avatar
├── casual.mp4           # Another option
└── ...
```

To switch avatars, update the `AVATAR_SKIN` environment variable in `.env` or through the configuration API.

---

## Testing Your Avatar

After uploading:

1. **Check file exists:**
   ```bash
   ls -lh assets/avatar-skins/default.mp4
   ```

2. **Verify it's a valid video:**
   ```bash
   ffprobe assets/avatar-skins/default.mp4
   ```

3. **Start services and test:**
   ```bash
   ./start-all-services.sh
   ```

4. **Access the app** and try generating speech - you should see your avatar talking!

---

## Recommendations

### For Best Results:

**Personal Avatar:**
- Record a 10-second video of yourself
- Face camera directly, neutral expression
- Good lighting, plain background
- Export as MP4, 1080p

**Professional Avatar:**
- Hire a videographer for high-quality footage
- Or use AI services (D-ID, Synthesia, HeyGen)
- Ensure you have rights to use the footage

**Quick Test:**
- Download stock footage from Pexels/Pixabay
- Choose a clear frontal face video
- Download as MP4

---

## Example: Download Sample Avatar

Here's a sample command to download a test video:

```bash
# Download a sample portrait video (example)
cd /workspace/digital-avatar-repo/usecases/ai/digital-avatar/assets/avatar-skins

# Using a free stock video
wget "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4" -O default.mp4
```

**Note:** Replace with actual royalty-free video URL.

---

## Privacy & Security

⚠️ **Important:**
- Only use images/videos you have rights to use
- Don't use copyrighted material without permission
- If using your personal image, be aware it will be used for AI animation
- Consider privacy implications of using your own face

---

## Need Help?

**Ready to upload?** Tell me:
1. Do you want to use your own face or stock footage?
2. If you have a video ready, share:
   - A direct download URL, OR
   - Upload to a file sharing service and share the link

I'll help you get it set up! 🎬
