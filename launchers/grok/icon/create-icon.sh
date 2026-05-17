#!/bin/bash
#
# create-icon.sh
# Converts various image formats (WebP, PNG, JPG, HEIC, etc.) into a macOS .icns file.
#
# Features:
# - Auto-detects common image files in the parent directory
# - Automatically converts non-PNG images to PNG first
# - Uses the parent folder name as the app name (e.g. "grok" → Grok.icns)
# - Much better error messages and progress output
#
# Usage:
#   ./create-icon.sh                  # auto-detects best image in parent folder
#   ./create-icon.sh /path/to/image.webp
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Determine app name from parent folder (capitalized)
APP_NAME="$(basename "$PARENT_DIR" | sed -e 's/^./\U&/')"

# Allow overriding via argument
SOURCE=""

if [ -n "$1" ]; then
    SOURCE="$1"
else
    # Auto-detect best source image (prefer PNG > JPG > WebP > others)
    for ext in png jpg jpeg heic heif webp tiff; do
        for file in "$PARENT_DIR"/*."$ext" "$PARENT_DIR"/*."${ext^^}"; do
            if [ -f "$file" ]; then
                SOURCE="$file"
                break 2
            fi
        done
    done
fi

if [ -z "$SOURCE" ] || [ ! -f "$SOURCE" ]; then
    echo "❌ No suitable image file found."
    echo ""
    echo "Place one of these in the parent folder:"
    echo "   icon.png, icon.webp, icon.jpg, grok.png, logo.webp, etc."
    echo ""
    echo "Or run with a specific file:"
    echo "   ./create-icon.sh /path/to/your/image.webp"
    exit 1
fi

echo "✅ Found source image: $SOURCE"
echo "   App name will be: $APP_NAME"

# If the source is not PNG, convert it first
FINAL_SOURCE="$SOURCE"

if [[ ! "$SOURCE" =~ \.png$ ]]; then
    echo "🔄 Converting to PNG first (required for high-quality .icns)..."
    PNG_TEMP="$SCRIPT_DIR/${APP_NAME}-source.png"
    sips -s format png "$SOURCE" --out "$PNG_TEMP" > /dev/null
    FINAL_SOURCE="$PNG_TEMP"
    echo "   Converted → $FINAL_SOURCE"
fi

# Prepare iconset
ICONSET_DIR="$SCRIPT_DIR/${APP_NAME}.iconset"
rm -rf "$ICONSET_DIR"
mkdir -p "$ICONSET_DIR"

echo "📐 Generating all required icon sizes..."

# Generate all standard sizes + Retina versions
sips -z 16 16     "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_16x16.png"     > /dev/null
sips -z 32 32     "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_16x16@2x.png"  > /dev/null
sips -z 32 32     "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_32x32.png"     > /dev/null
sips -z 64 64     "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_32x32@2x.png"  > /dev/null
sips -z 128 128   "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_128x128.png"   > /dev/null
sips -z 256 256   "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_128x128@2x.png"> /dev/null
sips -z 256 256   "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_256x256.png"   > /dev/null
sips -z 512 512   "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_256x256@2x.png"> /dev/null
sips -z 512 512   "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_512x512.png"   > /dev/null
sips -z 1024 1024 "$FINAL_SOURCE" --out "$ICONSET_DIR/icon_512x512@2x.png"> /dev/null

echo "🛠️  Building .icns file..."

ICON_OUTPUT="$SCRIPT_DIR/${APP_NAME}.icns"
iconutil -c icns "$ICONSET_DIR" -o "$ICON_OUTPUT"

echo ""
echo "✅ Success! Created: $ICON_OUTPUT"
echo ""
echo "You can now drag this into Platypus, or copy it to:"
echo "   YourApp.app/Contents/Resources/${APP_NAME}.icns"
