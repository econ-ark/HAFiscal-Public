# HAFiscal Development Container (MiKTeX + Python)

**Purpose**: Complete development environment with MiKTeX LaTeX and Python UV  
**LaTeX**: MiKTeX (self-contained, no host dependencies)  
**Python**: Python 3.9 with UV package manager  
**Isolation**: Fully standalone, no host machine requirements

---

## 🚀 Quick Start

### Option A: Standalone Container (Recommended)

**Best for**: Reproducible, isolated environment

1. **Open Cursor** (or VS Code)
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
3. Type: **"Dev Containers: Clone Repository in Container Volume"**
4. Enter: `https://github.com/llorracc/HAFiscal-Latest.git`
5. Wait 10-15 minutes for first-time build
6. Start working!

**See detailed guide**: [CURSOR_STANDALONE.md](./CURSOR_STANDALONE.md)

### Option B: Local Folder in Container

**Best for**: Working with existing local clone

1. Open Cursor
2. Press `Cmd+Shift+P` → **"Dev Containers: Open Folder in Container"**
3. Select: `/path/to/HAFiscal-Latest`
4. Wait for container build

---

## 📦 What's Included

### LaTeX Environment

- ✅ **TeX Live 2025** - Comprehensive LaTeX distribution (scheme-basic + packages)
- ✅ **Auto-install packages** - Downloads LaTeX packages on-demand
- ✅ **pdflatex, bibtex, latexmk** - All standard tools
- ✅ **No host dependencies** - Works without host LaTeX installation
- ✅ **Fresh environment** - Clean TeX Live install every time

### Python Environment

- ✅ **Python 3.11** - Consistent across all platforms
- ✅ **UV package manager** - Fast, modern Python package management
- ✅ **Scientific stack** - numpy, pandas, scipy, matplotlib
- ✅ **econ-ark/HARK** - Economic modeling tools
- ✅ **Jupyter Lab** - Interactive notebooks (port 8888)

### Development Tools

- ✅ **Git + GitHub CLI** - Version control
- ✅ **VS Code extensions** - Python, LaTeX Workshop, Jupyter
- ✅ **Zsh + Oh My Zsh** - Enhanced shell

### Setup Scripts

- ✅ **Setup scripts** - Located in `reproduce/docker/` (part of reproduction infrastructure)
  - `setup.sh` - Main setup script (installs TeX Live + Python/UV)
  - `run-setup.sh` - Helper script to find and run setup.sh
  - `detect-arch.sh` - Architecture detection for TeX Live
  - Other utility scripts for Docker/container builds

---

## 🎯 What You Can Do

### Build HAFiscal PDF

```bash
# Inside container terminal:
cd /workspaces
git clone https://github.com/llorracc/HAFiscal-make.git
cd HAFiscal-make
./makePDF-Portable-Latest.sh
```

**First build**: 10-15 minutes (MiKTeX downloads packages)  
**Subsequent builds**: 3-5 minutes

### Run Python Code

```bash
cd /workspaces/HAFiscal-Latest

# Virtual environment is auto-activated
python Code/HA-Models/do_all.py

# Or use Jupyter
jupyter lab --ip=0.0.0.0 --port=8888
```

Access Jupyter at: <http://localhost:8888>

### Test LaTeX Compilation

```bash
cd /workspaces/HAFiscal-Latest
latexmk -pdf HAFiscal.tex
```

---

## 🔧 Architecture

### MiKTeX vs. TeXLive

This devcontainer uses **MiKTeX** instead of TeXLive because:

| Feature | MiKTeX | TeXLive |
|---------|--------|---------|
| **Size** | ~500 MB | ~4 GB (full) |
| **Package install** | On-demand | Manual or bulk |
| **Updates** | Automatic | Manual |
| **Cross-platform** | Excellent | Good |
| **Windows support** | Native | Via WSL |
| **Repository** | Official apt | Ubuntu packages |

### Filesystem Layout

```
/workspaces/
├── HAFiscal-Latest/           # Main repository (this one)
│   ├── .devcontainer/         # Container configuration
│   ├── .venv/                 # Python virtual environment (UV)
│   ├── Code/                  # Python code
│   ├── Figures/               # LaTeX figures
│   ├── Tables/                # LaTeX tables
│   └── HAFiscal.tex           # Main LaTeX document
└── HAFiscal-make/             # Build system (clone manually)
    ├── makePDF-Portable-Latest.sh
    ├── makeWeb-HEAD-Latest.sh
    └── scripts/
```

### Environment Variables

```bash
# MiKTeX configuration
MIKTEX_USERINSTALL=true
MIKTEX_USERCONFIG=$HOME/.miktex/texmfs/config
MIKTEX_USERDATA=$HOME/.miktex/texmfs/data

# Python
PYTHONUNBUFFERED=1

# Terminal
TERM=xterm-256color
```

---

## 🐛 Troubleshooting

### MiKTeX Package Errors

**Problem**: `! LaTeX Error: File 'package.sty' not found.`

**Solution**: MiKTeX should auto-install. If not:

```bash
mpm --install package-name
initexmf --update-fndb
```

### First Build is Slow

**Normal behavior**: First LaTeX compilation takes 10-15 minutes as MiKTeX downloads ~200 packages on-demand. Subsequent builds are much faster.

### Container Build Fails

**Solution**: Rebuild without cache

```bash
Cmd+Shift+P → "Dev Containers: Rebuild Container Without Cache"
```

### Jupyter Port Conflict

**Problem**: Port 8888 already in use

**Solution**: Change port in `.devcontainer/devcontainer.json`:

```json
"forwardPorts": [8889, 8866],
```

Then rebuild container.

### Python Package Issues

**Solution**: Resync UV environment

```bash
cd /workspaces/HAFiscal-Latest
uv sync --all-groups
source .venv/bin/activate
```

---

## 📊 Performance

### Expected Build Times

| Operation | First Time | Subsequent |
|-----------|-----------|------------|
| **Container build** | 10-15 min | <1 min (cached) |
| **First PDF compile** | 10-15 min | - |
| **Regular PDF compile** | 3-5 min | 3-5 min |
| **Python env setup** | 3-5 min | <1 min (cached) |

### Resource Usage

- **CPU**: 2-4 cores recommended
- **RAM**: 4-8 GB recommended
- **Disk**: ~2 GB total (MiKTeX + Python + packages)

Configure in Docker Desktop → Settings → Resources

---

## 🔄 Updates

### Updating Container

Pull latest devcontainer configuration:

```bash
cd /workspaces/HAFiscal-Latest
git pull origin main
```

Rebuild:

```bash
Cmd+Shift+P → "Dev Containers: Rebuild Container"
```

### Updating MiKTeX Packages

```bash
mpm --update
mpm --upgrade
initexmf --update-fndb
```

### Updating Python Packages

```bash
cd /workspaces/HAFiscal-Latest
uv sync --upgrade --all-groups
```

---

## 📚 Documentation

- **Standalone mode guide**: [CURSOR_STANDALONE.md](./CURSOR_STANDALONE.md) ⭐
- **Quick start**: [QUICKSTART.md](./QUICKSTART.md)
- **LaTeX environment**: [LATEX_ENVIRONMENT.md](./LATEX_ENVIRONMENT.md)
- **Cross-platform status**: [CROSS_PLATFORM_STATUS.md](./CROSS_PLATFORM_STATUS.md)

---

## 🆚 Comparison: Old vs. New

| Feature | Old (TeXLive + Host) | New (MiKTeX + Standalone) |
|---------|----------------------|---------------------------|
| **LaTeX size** | ~250 MB (minimal) | ~500 MB (complete) |
| **Host dependency** | Yes (host LaTeX) | No (fully contained) |
| **Package install** | Manual copying | Automatic download |
| **Reproducibility** | Medium (varies by host) | High (identical everywhere) |
| **First build** | 5-10 min | 10-15 min |
| **Setup complexity** | High | Low (fully automated) |
| **Cross-platform** | Fragile | Robust |

---

## ✅ Verification

After container starts, verify installation:

```bash
# Check LaTeX
pdflatex --version | head -3
# Should show: MiKTeX-pdfTeX

# Check Python
python --version
# Should show: Python 3.9.x

# Check UV
uv --version

# Check packages
python -c "import numpy, pandas, HARK; print('✅ All packages ready')"

# Check MiKTeX
mpm --list | head -10
```

All checks should pass without errors.

---

## 🎉 Benefits

### For Users

- No LaTeX installation required on host
- Consistent environment across all platforms
- Easy onboarding for new developers
- No "works on my machine" issues

### For Development

- Clean, reproducible builds
- No package conflicts
- Easy CI/CD integration
- Faster troubleshooting

### For CI/CD

- Identical to local environment
- Predictable builds
- Easy testing
- Reduced debugging time

---

## 🚀 Next Steps

1. **Start the container** (see Quick Start above)
2. **Clone HAFiscal-make**:

   ```bash
   cd /workspaces
   git clone https://github.com/llorracc/HAFiscal-make.git
   ```

3. **Build HAFiscal PDF**:

   ```bash
   cd HAFiscal-make
   ./makePDF-Portable-Latest.sh
   ```

4. **Start developing!**

---

## 📝 Notes

- **MiKTeX advantages**: Smaller footprint, better Windows support, automatic package management
- **First build**: Takes longer due to on-demand package downloads (normal behavior)
- **Persistence**: In standalone mode, changes only saved via git push
- **Performance**: Near-native speed with minimal Docker overhead

---

## 🆘 Getting Help

- **Container issues**: Rebuild with `Cmd+Shift+P` → "Rebuild Container Without Cache"
- **LaTeX issues**: Check MiKTeX logs: `cat ~/.miktex/texmfs/data/miktex/log/*`
- **Python issues**: `uv sync --all-groups` to resync environment
- **Documentation**: See `.devcontainer/*.md` files

---

**Version**: 2.0 (MiKTeX + UV)  
**Last updated**: November 2025  
**Maintained by**: HAFiscal Development Team
