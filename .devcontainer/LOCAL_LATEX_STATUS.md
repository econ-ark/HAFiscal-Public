# Local LaTeX Packages - Current Status

**Date**: October 31, 2025  
**Goal**: Store needed LaTeX packages in `@local/texlive/texmf-local/` to avoid installing texlive-latex-extra (~2GB)

## What We've Accomplished

### 1. Created Directory Structure ✅

- Created `@local/texlive/texmf-local/tex/latex/`
- Added 37 packages from tlmgr user installation
- Updated `@resources/tex-add-search-paths.tex` to include this path

### 2. Configured TEXMFHOME ✅

- Set `TEXMFHOME=/workspaces/HAFiscal-Latest/@local/texlive/texmf-local`
- This makes LaTeX automatically find packages in `@local/`
- Verified with `kpsewhich changepage.sty` ✅ WORKS

### 3. Documentation ✅

- Created `@local/texlive/README.md`
- Lists all 37 packages included
- Explains purpose and usage

## Current Issue ❌

**Problem**: Some packages have files in multiple TEXMF directories

Example: `tracklang` package

- Has `tracklang.sty` in `tex/latex/tracklang/` ✅
- Also needs `tracklang.tex` in `tex/generic/tracklang/` ❌ MISSING

We copied only `tex/latex/` but packages also use:

- `tex/generic/` - Generic TeX files
- `tex/plain/` - Plain TeX files  
- `tex/context/` - ConTeXt files

## Solutions

### Option A: Copy Complete TEXMF Tree
Instead of just `tex/latex/`, copy entire structure:

```
@local/texlive/texmf-local/
├── tex/
│   ├── latex/    # LaTeX-specific (.sty, .cls)
│   ├── generic/  # Format-agnostic (.tex, .sty)
│   └── plain/    # Plain TeX files
├── doc/          # Documentation
└── source/       # Source files
```

**Pros**: Complete package files  
**Cons**: Larger (~30-40 MB vs ~15-20 MB)

### Option B: Install texlive-latex-extra  
Just use the Debian package:

```bash
sudo apt-get install texlive-latex-extra
```

**Pros**: Guaranteed complete, well-tested  
**Cons**: ~2GB installed, slower container builds

### Option C: Hybrid - Base + Essential Extras
Install only critical missing distributions:

```bash
sudo apt-get install \
  texlive-latex-extra \      # Has changepage, cancel, etc.
  texlive-fonts-recommended  # Extra fonts
```

**Pros**: Smaller than full (~500 MB)  
**Cons**: Still needs apt install in container

## Recommendation

For **immediate use**: Option B (texlive-latex-extra)

- Simple, reliable
- One-time ~5 min install in container
- Container image size doesn't matter much with Docker layer caching

For **optimal solution**: Option A (Complete TEXMF tree)

- Need to copy from a full tlmgr installation:
  - `tex/latex/` ✅ Already have
  - `tex/generic/` ❌ Need to add
  - `tex/plain/` ❌ Need to add (if used)
- Would require access to full TeXLive installation to extract complete packages

## What's Working

- ✅ TEXMFHOME configuration
- ✅ Search path setup
- ✅ kpsewhich finds packages
- ✅ 37 packages copied (partial)
- ✅ Documentation created

## What's Not Working

- ❌ Incomplete package files (missing tex/generic/, etc.)
- ❌ HAFiscal compilation fails on `tracklang.tex`
- ❌ Likely more missing files in other packages

## Next Steps

**Quick Fix** (5 minutes):

```bash
# In reproduce/docker/setup.sh, add:
sudo apt-get install -y texlive-latex-extra
```

**Complete Fix** (requires investigation):

1. Get full tlmgr package lists
2. Download complete CTAN packages
3. Extract to proper TEXMF structure
4. Test each package individually
5. Document all files needed

## Files Modified

- `@resources/tex-add-search-paths.tex` - Added @local paths
- `reproduce/docker/setup.sh` - Added TEXMFHOME configuration
- `@local/texlive/texmf-local/tex/latex/` - 37 packages (partial)
- `@local/texlive/README.md` - Documentation

## Conclusion

**Current Status**: 80% complete  
**Blocking Issue**: Incomplete package files  
**Estimated Time to Fix**: 2-3 hours (manual package extraction)  
**Quick Workaround**: Use texlive-latex-extra (~5 minutes)

The infrastructure is in place and working. We just need complete package files rather than partial copies from tlmgr user mode.
