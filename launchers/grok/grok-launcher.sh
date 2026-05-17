#!/bin/bash
#
# Grok Launcher
# Opens grok.com (or grok.x.ai) in Arc using Little Arc.
# Tries to focus an existing window/tab with grok.com first.
# Falls back to creating a new Little Arc window if none exists.
#
# This script is designed to be wrapped with Platypus into a native .app

URL="https://grok.com"

osascript <<'APPLESCRIPT'
tell application "Arc"
    activate
    
    set targetDomains to {"grok.com", "grok.x.ai"}
    set found to false
    
    try
        repeat with theWindow in (every window)
            tell theWindow
                repeat with theTab in (every tab)
                    try
                        set tabURL to URL of theTab
                        repeat with domain in targetDomains
                            if tabURL contains domain then
                                set active tab of theWindow to theTab
                                set index of theWindow to 1
                                set found to true
                                exit repeat
                            end if
                        end repeat
                    end try
                    if found then exit repeat
                end repeat
            end tell
            if found then exit repeat
        end repeat
    on error errMsg
        -- If enumeration fails (common with Little Arc windows), just create new
        set found to false
    end try
    
    if not found then
        make new tab with properties {URL:"https://grok.com"}
    end if
end tell
APPLESCRIPT
