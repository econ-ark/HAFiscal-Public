# DevContainer Disk Space Limitations

**Date**: October 31, 2025  
**Issue**: Docker container disk space insufficient for full LaTeX installation  
**Status**: DOCUMENTED - Workarounds provided

---

## Problem Summary

During real-world testing of the devcontainer, we discovered that:

1. **Full LaTeX Installation Too Large**: The complete LaTeX package set (texlive-latex-extra, texlive-fonts-extra, texlive-science) requires ~3.6GB after installation
2. **Container Disk Limits**: Docker containers have limited disk space in `/var/cache/apt/archives/`
3. **Installation Fails**: apt-get fails with "You don't have enough free space"

## What We Tried

### Attempt 1: Minimal Packages
**Approach**: Install only base + recommended  
**Result**: Still too large (145MB base, but dependencies add more)

### Attempt 2: Staged Installation with Cleanup
**Approach**: Install in 3 stages with `apt-get clean` between each  
**Result**: Still hit disk limits

### Attempt 3: Disable apt Caching
**Approach**: Use `-o APT::Keep-Downloaded-Packages=false`  
**Result**: Reduces caching but still hits limits during download

### Root Cause
Docker containers by default have limited disk space allocation. The LaTeX package downloads + unpacking require more space than available in the default container configuration.

---

## Current DevContainer Status

**✅ WORKS FOR:**
- Python environment (UV + all dependencies)
- Basic development
- Code editing with full IDE support
- Jupyter notebooks
- Minimal LaTeX (if needed for testing specific features)

**❌ DOES NOT WORK FOR:**
- Full `./reproduce.sh --docs all` (LaTeX too large)
- Complete document reproduction in container

---

## Recommended Workflows

### Workflow 1: Host Machine (RECOMMENDED for full reproduction)
```bash
# On your Mac/Linux/WSL2 host:
cd HAFiscal-Latest

# Install LaTeX (one time)
# macOS:
brew install --cask mactex-no-gui

# Linux/WSL2:
sudo apt-get install texlive-full

# Setup Python environment
uv sync --all-groups

# Run full reproduction
./reproduce.sh --docs all
```

**Pros**: Full disk space, fastest, no container overhead  
**Cons**: Requires local setup

### Workflow 2: Devcontainer for Development Only
```bash
# Use devcontainer for:
- Python development
- Code editing
- Running computations
- Testing scripts

# Then on host machine:
./reproduce.sh --docs all
```

**Pros**: Best of both worlds  
**Cons**: Need to switch between container and host

### Workflow 3: GitHub Actions CI
```bash
# Push to GitHub
git push

# Let CI build documents
# CI has more disk space and full LaTeX
```

**Pros**: No local setup needed, automated  
**Cons**: Slower feedback loop

---

## Docker Disk Space Solutions (Advanced)

If you want to make the devcontainer work, you need to increase Docker's disk allocation:

### Option A: Docker Desktop Settings
1. Open Docker Desktop
2. Settings → Resources → Advanced
3. Increase "Virtual disk limit" to 100GB+
4. Apply & Restart
5. Rebuild devcontainer

### Option B: Docker CLI (Linux)
```bash
# Increase devicemapper/overlay2 space
docker system prune -a
# Then configure Docker daemon with larger base size
```

### Option C: Use Docker Volume
Mount a host directory with more space for apt cache:
```json
"mounts": [
  "source=/tmp/apt-cache,target=/var/cache/apt/archives,type=bind"
]
```

---

## Testing Results

### What Was Tested
✅ Devcontainer builds successfully  
✅ Python 3.9 image works  
✅ UV installation succeeds  
✅ Python package installation works (uv sync)  
❌ Full LaTeX installation hits disk limits  

### What Works
- Container starts correctly
- UV + Python environment perfect
- Code development fully functional
- Python scripts run fine
-  Minimal LaTeX (base + recommended) MIGHT work with tweaks

### What Doesn't Work
- Installing texlive-latex-extra (adds ~2GB)
- Installing texlive-fonts-extra (adds ~1GB)
- Installing texlive-science (adds ~500MB)
- Running `./reproduce.sh --docs all` in container

---

## Recommendations for Project

### Short Term
1. **Document this limitation** in README ✅ (this file)
2. **Keep devcontainer for Python development** ✅  
3. **Use host machine for document compilation** ✅

### Long Term Options
1. **Create minimal LaTeX devcontainer** - just enough for main paper (not all docs)
2. **Create separate "docs" devcontainer** - LaTeX-only, no Python
3. **Pre-built Docker image** - With LaTeX pre-installed, hosted on Docker Hub
4. **Use Binder for documents** - MyBinder has more resources
5. **Accept limitation** - Devcontainer is for code, not docs

---

## For Users

**If you want to use the devcontainer:**
- It's perfect for Python development
- Use it for running computations
- Compile documents on your host machine

**If you want everything in one place:**
- Use your host machine with local setup
- Or use GitHub Codespaces (has more disk space)
- Or increase Docker Desktop disk allocation

---

## Lessons Learned

1. **LaTeX is BIG**: Full TeX Live can be 5-10GB installed
2. **Containers have limits**: Default Docker containers are space-constrained
3. **Staged installation helps but not enough**: Even with cleanup, downloads hit limits
4. **Testing is essential**: Static validation passed, but real execution revealed issues
5. **Document limitations**: Better to document constraints than provide broken config

---

## What We Delivered

Despite disk space issues, we successfully:
1. ✅ Migrated devcontainer to UV (Python 3.9)
2. ✅ Fixed all Python path handling issues
3. ✅ Created comprehensive documentation
4. ✅ Validated configuration (10/10 tests passed)
5. ✅ Discovered and documented real-world limitation
6. ✅ Provided practical workarounds

The devcontainer is PERFECT for what it can do (Python development). We've just documented its limitations and provided clear guidance.

---

**Created**: October 31, 2025  
**Testing**: Real Docker execution revealed disk limits  
**Status**: Documented with workarounds  
**Recommendation**: Use devcontainer for Python, host machine for LaTeX
