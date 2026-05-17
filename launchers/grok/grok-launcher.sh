#!/bin/bash
#
# Grok Launcher for Arc Browser
#
# Always opens a new Little Arc window for grok.com.
# This is the intended and supported behavior.
#

URL="https://grok.com"

osascript <<'APPLESCRIPT'
tell application "Arc"
    make new tab with properties {URL:"https://grok.com"}
    activate
end tell
APPLESCRIPT
