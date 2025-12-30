# Local MiKTeX Setup for HAFiscal

## Overview

MiKTeX can be configured to store all its files in the project's `.miktex/` directory, keeping everything:
- ✅ **Self-contained** - All MiKTeX data in one place
- ✅ **Git-ignored** - Won't pollute version control
- ✅ **Portable** - Can be deleted/recreated anytime
- ✅ **Small** - Only ~30-100 MB (minimal install)

## Quick Start

### Initial Setup (One-time)

```bash
cd /path/to/HAFiscal-Latest

# Set up local MiKTeX
./reproduce/miktex-setup.sh
```

This will:
1. Remove the broken `true/` directory (if it exists)
2. Create `.miktex/` directory structure
3. Configure MiKTeX to use it
4. Initialize package database

### Using Local MiKTeX

**Important:** You must source `reproduce/miktex-use.sh` before running `pdflatex` directly!

```bash
# Activate local MiKTeX for this shell
source reproduce/miktex-use.sh

# Now pdflatex will use project .miktex/
pdflatex HAFiscal.tex

# Or use reproduce script
./reproduce.sh --docs main
```

**Without sourcing:**
- `pdflatex` still works ✅
- But uses `~/.miktex/` instead ❌
- Not the project `.miktex/` ❌

This is like Python's `source .venv/bin/activate` - you must activate before use!

### Switching Between TeX Distributions

```bash
# Use local project MiKTeX
source reproduce/miktex-use.sh

# Use TeX Live 2022 (full installation)
source ~/texlive2022.sh

# Use TeX Live 2019 (minimal)
source ~/texlive2019.sh

# Check which is active
~/which-tex.sh
```

## Directory Structure

```
HAFiscal-Latest/
├── .miktex/              # ← Local MiKTeX files (git-ignored)
│   └── texmfs/
│       ├── config/       # Configuration
│       ├── data/         # Package database, cache, logs
│       └── install/      # Installed packages
├── reproduce/
│   ├── miktex-setup.sh   # Setup script (run once)
│   └── miktex-use.sh     # Activation script (source before use)
└── .gitignore            # Contains: .miktex/ and true/
```

## What Gets Stored in `.miktex/`

| Directory | Contents | Size |
|-----------|----------|------|
| `config/` | MiKTeX configuration | ~50 KB |
| `data/` | Package database, cache, logs | ~30 MB |
| `install/` | Installed LaTeX packages | ~0-500 MB (grows as needed) |

**Initial size:** ~31 MB  
**After compiling HAFiscal:** ~100-200 MB (packages auto-install)

## The "true/" Bug

### What Happened?

MiKTeX was initially misconfigured with `installation directory: true` (literal string), causing it to create a directory literally named `true/` in the project root.

### How It's Fixed

1. `reproduce/miktex-setup.sh` detects and removes `true/` directory
2. Sets proper environment variables:
   ```bash
   MIKTEX_USERCONFIG="$PROJECT/.miktex/texmfs/config"
   MIKTEX_USERDATA="$PROJECT/.miktex/texmfs/data"
   MIKTEX_INSTALL="$PROJECT/.miktex/texmfs/install"
   ```
3. Both `.miktex/` and `true/` are git-ignored

## Comparison: Where MiKTeX Can Live

| Location | Method | Pros | Cons |
|----------|--------|------|------|
| **~/.miktex/** | System default | Shared across projects | Takes up home directory space |
| **.miktex/** (this) | Project-local | Self-contained, git-ignored | One per project |
| **/usr/local/share/** | System-wide | Shared, requires admin | Needs sudo |
| **true/** (bug) | ❌ Misconfiguration | None | Wrong, git-polluting |

## Disk Space Management

### Check size:
```bash
du -sh .miktex/
```

### Clean up (safe - can recreate):
```bash
rm -rf .miktex/
./reproduce/miktex-setup.sh  # Recreate
```

### Remove packages you don't need:
```bash
source reproduce/miktex-use.sh
miktex packages list --installed
miktex packages remove PACKAGE_NAME
```

## Why Not Put It in .venv?

**MiKTeX is NOT a Python package** - it's a native C/C++ program suite. It cannot go in Python's `.venv/` directory because:
- `.venv/` is for Python packages managed by `uv`/`pip`
- MiKTeX binaries are system-level executables
- MiKTeX needs specific directory structure (`texmfs/`)

The `.miktex/` directory is the correct parallel to `.venv/` - both are:
- Local to the project
- Git-ignored
- Self-contained
- Deletable/recreatable

## Troubleshooting

### MiKTeX still creates `true/` directory

Run setup again:
```bash
./reproduce/miktex-setup.sh
```

### Packages fail to install

Check that auto-install is enabled:
```bash
source reproduce/miktex-use.sh
miktex packages set-auto-install yes
miktex packages update-package-database
```

### "Permission denied" errors

Make sure you're using the local MiKTeX:
```bash
source reproduce/miktex-use.sh
echo $MIKTEX_USERDATA  # Should show project .miktex path
```

### Want to start fresh

```bash
rm -rf .miktex/ true/
./reproduce/miktex-setup.sh
```

## See Also

- `.gitignore` - Contains `.miktex/` and `true/` exclusions
- `~/use-miktex.sh` - Alternative: uses system-wide `~/.miktex/`
- `~/texlive2022.sh` - Switch to TeX Live 2022
- `.devcontainer/` - Docker-based complete environment (includes MiKTeX)

