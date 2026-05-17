---
title: Grok Launcher for Arc
---

# Grok Launcher for Arc

A native macOS `.app` launcher for [grok.com](https://grok.com) that opens inside your existing **Arc Browser** using Little Arc windows.

## Why This Exists

Arc does not support traditional PWA / `--app` mode well. This launcher gives you the closest possible experience while staying 100% inside Arc:

- Dedicated icon in Dock and Applications
- Appears in Cmd+Tab
- Opens even when Arc is closed
- Uses Little Arc (the best focused-window experience Arc currently offers)

## Smart Focus Behavior

The launcher tries to be "single app"-like:

1. If a window or tab containing grok.com / grok.x.ai is already open → focus it
2. Otherwise → create a new Little Arc window

## Files

```
launchers/grok/
├── grok-launcher.sh          # The Platypus script (smart focus version)
├── README.md                 # This file
└── icon/
    └── create-icon.sh        # Converts WebP/PNG → proper .icns
```

## Build Instructions

### Prerequisites

- [Platypus](https://sveinbjorn.org/platypus) installed
- A source icon image (WebP or PNG) of the Grok / xAI logo

### Step 1: Prepare the Icon

1. Save a high-quality Grok or xAI logo as `.webp` or `.png` in the `icon/` folder (or anywhere).
2. Recommended names: `icon.webp`, `grok.webp`, `source.png`

3. Run the converter:

```bash
cd icon
./create-icon.sh
```

It will auto-detect your source image and produce `Grok.icns`.

**Manual usage:**
```bash
./create-icon.sh /path/to/your-logo.png
```

### Step 2: Create the .app with Platypus

Open **Platypus** and configure it exactly like this:

| Setting                                   | Value                              | Notes |
|-------------------------------------------|------------------------------------|-------|
| Script Type                               | Shell                              | — |
| Script Path                               | Select `grok-launcher.sh`          | — |
| App Name                                  | `Grok`                             | Becomes the .app filename |
| Interface                                 | **None**                           | **Critical** for clean launcher |
| Interpreter                               | `/bin/bash`                        | — |
| Remain running after script completes     | **Unchecked**                      | We want the script to exit |
| Bring to front                            | Checked                            | Good UX |
| Accept dropped items                      | Unchecked                          | Not needed |
| Run with root privileges                  | Unchecked                          | Never needed |

**Icon:** Drag `Grok.icns` from the `icon/` folder into Platypus's icon well.

Click **Create App** and save it somewhere as `Grok.app`.

### Step 3: Install the Launcher

```bash
# Copy to Applications
cp -R Grok.app /Applications/

# Remove macOS quarantine (first run only)
xattr -d com.apple.quarantine /Applications/Grok.app

# Optional: codesign for better Gatekeeper behavior
codesign --force --deep --sign - /Applications/Grok.app
```

Drag `Grok.app` from `/Applications` into your Dock.

## Testing

You can test the raw script without Platypus:

```bash
./grok-launcher.sh
```

## First Run Permissions

The first time the launcher runs, macOS may ask:

> "Terminal" wants to control "Arc"

or similar. Click **Allow**. This is required for AppleScript to tell Arc to open the URL.

Subsequent runs should be silent.

## Known Limitations

- Little Arc windows are the best Arc currently offers for focused experiences.
- Tab/window detection is best-effort (Arc's AppleScript dictionary is limited, especially for Little Arc).
- If detection fails, it will safely fall back to creating a new window.

## Customization

Want a different URL or multiple instances?

Edit the `URL=` line and the AppleScript domains array in `grok-launcher.sh`.

## Related

See the root [Mental Model](../../docs/mental-model.md) for why we chose this approach.
