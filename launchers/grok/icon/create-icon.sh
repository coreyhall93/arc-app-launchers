#!/bin/bash
#
# Grok Icon Converter
# Converts a source image (PNG, WebP, JPG) into a proper macOS .icns file
# for use with Platypus or manual embedding into a .app bundle.
#
# Usage:
#   ./create-icon.sh                    # auto-detects icon.* in parent dir
#   ./create-icon.sh /path/to/image.png

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Try to find source image
if [ -n "$1" ]; then
    SOURCE="$1"
else
    # Auto-detect common names
    for candidate in "icon.webp" "icon.png" "grok.webp" "grok.png" "source.webp" "source.png" "logo.webp" "logo.png"; do
        if [ -f "$PARENT_DIR/$candidate" ]; then
            SOURCE="$PARENT_DIR/$candidate"
            echo "Found source image: $SOURCE"
            break
        fi
    done
fi

if [ -z "$SOURCE" ] || [ ! -f "$SOURCE" ]; then
    echo "Error: No source image found."
    echo "Place a .png or .webp file named icon.webp / grok.webp / source.png etc. next to this script,"
    echo "or pass the path as argument: ./create-icon.sh /path/to/your-icon.webp"
    exit 1
fi

# Create iconset directory
ICONSET="$SCRIPT_DIR/Grok.iconset"
rm -rf "$ICONSET"
mkdir -p "$ICONSET"

echo "Converting $SOURCE → Grok.icns ..."

# Function to resize using sips
resize() {
    local size=$1
    local name=$2
    sips -z "$size" "$size" "$SOURCE" --out "$ICONSET/$name" >/dev/null 2>&1
}

# Generate all required sizes for a full .icns
# macOS .icns requires these (and @2x retina versions)

 echo "Generating icon sizes..."

# Standard sizes + Retina (@2x)
resize 16   "icon_16x16.png"
resize 32   "icon_16x16@2x.png"
resize 32   "icon_32x32.png"
resize 64   "icon_32x32@2x.png"
resize 128  "icon_128x128.png"
resize 256  "icon_128x128@2x.png"
resize 256  "icon_256x256.png"
resize 512  "icon_256x256@2x.png"
resize 512  "icon_512x512.png"
resize 1024 "icon_512x512@2x.png"

# Create the .icns file
ICON_OUTPUT="$SCRIPT_DIR/Grok.icns"
iconutil -c icns "$ICONSET" -o "$ICON_OUTPUT"

 echo "✅ Created: $ICON_OUTPUT"
 echo ""
 echo "You can now drag Grok.icns into Platypus, or copy it manually into:"
 echo "  Grok.app/Contents/Resources/Grok.icns"
