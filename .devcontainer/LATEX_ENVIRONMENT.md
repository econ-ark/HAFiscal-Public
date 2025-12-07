# LaTeX Environment in DevContainer

**Last Updated**: October 31, 2025

## Current Status

The devcontainer's LaTeX setup has evolved through testing to determine the actual minimum requirements for HAFiscal compilation.

---

## What's Included by Default (in setup.sh)

### Initial "Minimal" Configuration (145 MB)
```bash
latexmk
texlive-latex-base
texlive-latex-recommended
```

This provides:
- ✅ Basic LaTeX compilation (pdflatex, bibtex)
- ✅ Core LaTeX packages and fonts
- ✅ Common document classes (article, book, report, etc.)
- ✅ Standard packages (graphicx, color, hyperref, etc.)

### What This "Minimal" Setup Can Do
- ✅ Compile simple LaTeX documents
- ✅ Test basic LaTeX syntax
- ✅ Educational/learning purposes
- ❌ **NOT sufficient for HAFiscal.tex**

---

## What HAFiscal Actually Needs

### Testing Results

When attempting to compile `HAFiscal.tex` with minimal LaTeX:

**First Error:**
```
! LaTeX Error: File `changepage.sty' not found.
```
→ Requires: `texlive-latex-extra`

**Second Error (after adding latex-extra):**
```
! LaTeX Error: File `tracklang.sty' not found.
```
→ Likely requires: Additional packages from binder/apt.txt

### Complete Package List (from binder/apt.txt)

HAFiscal's MyBinder environment (which we know works) includes:

```bash
latexmk                      # Build automation
texlive-latex-base          # Core LaTeX
texlive-latex-recommended   # Common packages
texlive-latex-extra         # Extended packages (changepage, etc.)
texlive-fonts-recommended   # Recommended fonts
texlive-fonts-extra         # Additional fonts
texlive-science             # Math/science packages
texlive-bibtex-extra        # Bibliography tools
biber                       # Modern BibTeX replacement
ghostscript                 # PDF/PS processing
```

**Total Size**: ~3-4 GB installed

---

## Package Breakdown

### texlive-latex-base (~200 MB)
- Core LaTeX binaries and formats
- Essential document classes
- Basic font support
- Fundamental packages

### texlive-latex-recommended (~300 MB)
- Commonly used packages (graphics, hyperref, etc.)
- Standard fonts
- Color support
- Basic bibliography support

### texlive-latex-extra (~2 GB!)
- **Extended packages** including:
  - `changepage` (page layout)
  - `tikz` (graphics)
  - `beamer` (presentations)
  - `memoir` (book class)
  - Hundreds of additional style files
- This is the **LARGE** package

### texlive-fonts-extra (~1 GB)
- Additional font families
- Special symbols
- International character support

### texlive-science (~300 MB)
- Mathematical typesetting
- Algorithm packages
- Units and scientific notation
- Academic paper requirements

### texlive-bibtex-extra (~100 MB)
- Additional bibliography styles
- Citation management tools
- Journal-specific formats

---

## Docker Disk Space Considerations

### Why This Matters for DevContainers

**Docker Desktop VM**: Typically 59-64 GB total
- Base system: ~10-15 GB
- Python base image: ~500 MB
- Python packages (UV): ~300 MB
- **Full LaTeX**: ~4 GB
- Working space needed: ~5-10 GB

**Total**: ~20 GB minimum + working space

### Our Experience
During testing, Docker VM was 100% full (57GB/59GB), causing all installations to fail until we ran `docker system prune -af --volumes` to free ~29 GB.

---

## Current DevContainer Strategy

### Option 1: Minimal LaTeX (Current Default)
**Installed**: base + recommended only (145 MB)
**Good for**:
- Python development
- Jupyter notebooks  
- Computational work
- Testing environment

**NOT sufficient for**:
- Full HAFiscal.tex compilation
- LaTeX Workshop compilation
- Document generation

### Option 2: Full LaTeX (Manual Addition)
**Install in container**:
```bash
sudo apt-get update
sudo apt-get install -y \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-fonts-extra \
  texlive-science \
  texlive-bibtex-extra \
  biber \
  ghostscript
```

**Size**: ~4 GB
**Good for**:
- Full HAFiscal compilation
- LaTeX Workshop integration
- Complete document reproduction
- Self-contained environment

**Requirements**:
- Docker has sufficient disk space (check `docker system df`)
- Willing to wait for installation (~5-10 minutes)
- Won't need frequent container rebuilds

---

## Recommendations

### For Python Development (Current Setup)
**Use**: DevContainer with minimal LaTeX
```bash
# In VS Code: Reopen in Container
./reproduce.sh --envt comp_uv    # Test Python environment
./reproduce.sh --comp min         # Run computations
jupyter lab --ip=0.0.0.0          # Use Jupyter
```

**Compile documents on host**:
```bash
./reproduce.sh --docs main        # On macOS host
```

### For Full LaTeX Development
**Option A**: Add full LaTeX to devcontainer.json setup.sh

**Option B**: Use host machine for LaTeX
- Mac/Linux: Install texlive-full
- Already configured and working
- Faster builds (no container overhead)

**Option C**: Increase Docker disk space
```bash
# Docker Desktop → Settings → Resources → Disk image size
# Increase from 59GB to 100GB+
# Then add full LaTeX to devcontainer
```

---

## Testing What You Have

### Check Installed Packages
```bash
dpkg -l | grep texlive
```

### Test Basic Compilation
```bash
echo '\documentclass{article}\begin{document}Hello\end{document}' > test.tex
latexmk -pdf test.tex
```

### Test HAFiscal Compilation
```bash
cd /workspaces/HAFiscal-Latest
latexmk -pdf HAFiscal.tex 2>&1 | grep "Error\|not found"
```

If you see missing `.sty` files, you need more LaTeX packages.

---

## Summary

| Setup | Size | HAFiscal Compiles? | Use Case |
|-------|------|-------------------|----------|
| **Minimal** (base + recommended) | 145 MB | ❌ No | Python dev only |
| **+ latex-extra** | ~2 GB | ⚠️ Maybe | Most documents |
| **Full** (all binder packages) | ~4 GB | ✅ Yes | Complete reproduction |

**Current DevContainer Default**: Minimal (Python-focused)  
**For Full LaTeX**: See "Option 2" above or use host machine

---

## Files

- **Configuration**: `.devcontainer/devcontainer.json`
- **Setup Script**: `.devcontainer/setup.sh`
- **Reference**: `binder/apt.txt` (MyBinder working config)
- **LaTeX Workshop**: Configured but requires full LaTeX to work

**To modify**: Edit `.devcontainer/setup.sh` lines 10-19 to add more packages
