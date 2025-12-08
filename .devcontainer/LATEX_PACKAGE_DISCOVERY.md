# LaTeX Package Discovery for HAFiscal

**Date**: October 31, 2025

## Objective
Discover the minimal set of LaTeX packages needed to compile HAFiscal.tex using tlmgr, rather than installing the massive `texlive-latex-extra` (~2GB).

## Discovery Process

### Base Installation

```bash
latexmk
texlive-latex-base
texlive-latex-recommended
```

### Discovered Missing Packages (via iterative compilation)

Through iterative compilation, we discovered these additional packages are needed:

1. **changepage** - Page layout modifications
2. **currfile** - File path/name information  
3. **cancel** - Math cancellation notation
4. **datetime2** - Date/time formatting
5. **tracklang** - Language tracking (dependency of datetime2)
6. **optional** - Optional compilation features
7. **footmisc** - Footnote customization
8. **ncctools** - Contains manyfoot.sty (footnote handling)
9. **perpage** - Per-page counters (in bigfoot or zref)
10. ... (discovery ongoing)

### Challenges Discovered

1. **Package Name Mismatches**:
   - File `manyfoot.sty` is in package `ncctools`, not `manyfoot`
   - File `perpage.sty` exists in multiple packages (bidi, bigfoot, zref, lwarp)

2. **Debian tlmgr Limitations**:
   - Debian's packaged TeXLive doesn't allow system-wide tlmgr installations
   - Forced to use "user mode" which installs to `~/texmf/`
   - Package search is slow and sometimes ambiguous

3. **Complexity**:
   - Iterative discovery requires many compilation cycles
   - Each missing package may have dependencies
   - Some packages contain multiple .sty files

## Current Status

**Packages successfully installed via tlmgr**:

- changepage
- currfile  
- cancel
- datetime2
- tracklang
- optional
- footmisc
- ncctools

**Stuck on**: perpage.sty (ambiguous - in multiple packages)

## Recommendations

### Option 1: Install texlive-latex-extra (Pragmatic)
**Pros**:

- Guaranteed to work
- No iteration needed
- Well-tested

**Cons**:

- ~2GB installed size
- Takes 5-10 minutes to install
- Requires significant Docker disk space

```bash
sudo apt-get install -y \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-fonts-extra \
  texlive-science \
  texlive-bibtex-extra \
  biber \
  ghostscript
```

### Option 2: Continue tlmgr Discovery (Ideal but Time-Consuming)
**Pros**:

- Minimal installation size (~200-300 MB)
- Only installs what's needed

**Cons**:

- Requires completing package discovery
- Complex due to package name mismatches
- May need 20-30 packages total

### Option 3: Hybrid Approach (Recommended)
Install core via apt (base + recommended), plus a curated short list via tlmgr:

```bash
# Base (already installed)
sudo apt-get install -y latexmk texlive-latex-base texlive-latex-recommended

# Additional via tlmgr (user mode)
tlmgr install \
  changepage currfile cancel datetime2 tracklang \
  optional footmisc ncctools bigfoot \
  [... complete list after full discovery ...]
```

## Next Steps

1. Complete package discovery (continue iteration)
2. Document full package list
3. Update `reproduce/required_latex_packages.txt`
4. Update `reproduce/docker/setup.sh` with complete list
5. Test full compilation in fresh container

## Files

- Discovery script: `/tmp/discover_packages.sh` (in container)
- Compile logs: `/tmp/compile_*.log`  (in container)
- Package list: `reproduce/required_latex_packages.txt` (incomplete - doesn't include changepage, currfile, etc.)

## Conclusion

**For immediate use**: Install `texlive-latex-extra` (~2GB) via apt

**For optimization**: Complete tlmgr discovery to create minimal package list

**Current blocker**: Mapping `.sty` files to correct tlmgr package names requires more investigation or brute-force testing of candidates.
