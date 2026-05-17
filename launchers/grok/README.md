---
title: Grok Launcher for Arc
---

# Grok Launcher for Arc

A native macOS `.app` launcher for [grok.com](https://grok.com) that opens inside your existing **Arc Browser** using Little Arc windows.

## Current Behavior

- Every click opens a **new Little Arc window** (this is the supported and intentional behavior)
- Works even when Arc is completely closed
- Uses your existing Arc data, profiles, and logins

## Why This Exists

Arc does not support traditional Chromium `--app` / PWA mode well. This project gives you the closest possible native-app experience while staying 100% inside Arc.

## Files

```
launchers/grok/
├── grok-launcher.sh          # The script fed to Platypus
├── README.md
└── icon/
    └── create-icon.sh        # Smart icon converter (WebP, JPG, HEIC → PNG → .icns)
```

## Building the Launcher

### 1. Prepare Icon

Put any image (`grok.webp`, `icon.png`, `logo.jpg`, etc.) in the parent folder.

Then run:

```bash
cd icon
./create-icon.sh
```

The script will:
- Auto-detect the best image
- Convert it to PNG if needed (WebP, JPG, HEIC, etc.)
- Generate a proper `Grok.icns`

### 2. Create the .app in Platypus

| Setting                                   | Recommended Value             |
|-------------------------------------------|-------------------------------|
| Script Type                               | Shell                         |
| Script Path                               | `grok-launcher.sh`            |
| App Name                                  | `Grok`                        |
| Interface                                 | **None** (important)          |
| Interpreter                               | `/bin/bash`                   |
| Remain running after script completes     | **Unchecked**                 |

Drag the generated `Grok.icns` into Platypus.

Click **Create App**.

### 3. Install

```bash
cp -R Grok.app /Applications/
xattr -d com.apple.quarantine /Applications/Grok.app   # if needed
```

Drag it to your Dock.

## Testing

```bash
./grok-launcher.sh     # test the raw script
```

## Notes

- The first run may prompt for AppleScript permission ("Terminal wants to control Arc"). Allow it.
- This is the current recommended pattern for Arc-based launchers in this project.

See the main [Mental Model](../../docs/mental-model.md) for deeper context.
