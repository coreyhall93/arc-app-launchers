---
title: Arc App Launchers
---

# Arc App Launchers

> Creating native macOS `.app` launchers that open specific websites inside **Arc Browser** using Platypus.

**Built in public for deep learning.**

This repository documents the full mental model of how macOS application bundles, Platypus, AppleScript, and Arc Browser actually work — then applies that knowledge to build clean, reliable, Dock-ready launcher apps.

## Philosophy

- Understand *why* things work (or don't)
- Build tools that feel native on macOS
- Stay inside the existing Arc installation (no Chrome/Edge fallbacks)
- Document everything so the knowledge compounds

## Current Status

**Phase 0: Mental Model** — Writing the foundational technical document before building anything.

**Next:** Test Arc launch behavior, then create the first launcher (with full instructions).

## Repository Structure

```
arc-app-launchers/
├── README.md
├── docs/
│   └── mental-model.md     # The core teaching document
├── launchers/                 # One folder per launcher we build
├── scripts/                   # Helper scripts (icon conversion, etc.)
└─ icons/                     # Source icons and .icns files
```

## How to Follow Along

1. Read the [Mental Model](./docs/mental-model.md) first
2. Run the diagnostic commands yourself
3. Watch as we build real launchers with full explanations
4. Use the scripts and patterns for your own sites

## Goals

- Beautiful, maintainable `.app` files in `/Applications` and the Dock
- Reliable launching into Arc (even when Arc is closed)
- Best possible "PWA-like" experience Arc can actually deliver
- Complete transparency about tradeoffs and limitations

---

**Let's build this properly, with understanding.**
