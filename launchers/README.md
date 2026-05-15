# Launchers

This directory will contain one subfolder per website launcher we create.

## Naming Convention

Use the desired app name in PascalCase or kebab-case.

Examples:

- `Gmail/`
- `Linear/`
- `Notion/`
- `Figma/`

## What Goes in Each Launcher Folder

```
Gmail/
├── README.md                 # How to build + maintain this specific launcher
├── gmail-launcher.sh         # The script we feed to Platypus
├── icon/                     # Source PNGs / SVGs
│   └── gmail.png
└── Gmail.app                 # (built artifact - usually gitignored)
```

## Process

1. We define the site + preferences
2. We generate the Platypus script
3. We document exact Platypus settings
4. We provide icon extraction + conversion steps
5. We test thoroughly
6. We move the final `.app` to `/Applications`

All of this will be written up in the individual `README.md` inside each launcher folder.
