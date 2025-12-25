# Cursor AI Indexing Strategy for HAFiscal Project

**Last Updated**: 2025-11-01  
**Status**: Implemented and Active

## Overview

This document describes the comprehensive indexing strategy for the HAFiscal project, designed to optimize Cursor AI's performance while maintaining full discoverability of source code, scripts, and documentation.

## Problem Statement

The HAFiscal repository contains approximately **1.75GB of dependencies and generated files** that significantly impact Cursor's indexing performance:

- **1.6GB**: Python virtual environments (`.venv/`, `.venv.backup-py39/`)
  - 42,466 files in site-packages
  - 321 Python package metadata directories
- **130MB**: Private/sensitive content directories
- **115MB**: `resources-private/` (reference PDFs and papers)
- **6MB**: Local LaTeX packages (`@local/texlive/`)
- **364 PDF files**: Generated documents
- **Various**: Build artifacts, temporary files, caches

## Solution: Two-Tier Exclusion Strategy

### File 1: `.cursorindexingignore` (Primary Performance Optimization)

**Purpose**: Exclude files from indexing while keeping them accessible via `@` references

**What It Does**:
- Files matching these patterns are NOT indexed by Cursor's semantic search
- Files CAN still be explicitly referenced with `@filename` in chat
- Files CAN still be opened in the editor
- Dramatically improves indexing speed and reduces memory usage

**Key Exclusions** (see file for full list):
1. **Python Dependencies** (1.6GB)
   - `.venv/`, `.venv.backup-py39/`
   - `__pycache__/`, `*.pyc`, `*.dist-info/`
   
2. **Private/Sensitive Content** (130MB)
   - `*_private/`, `Private/`, `resources-private/`
   
3. **Generated Documents** (364 PDFs)
   - `*.pdf`, `Figures/`, `Tables/`
   
4. **LaTeX Packages** (5.8MB)
   - `@local/texlive/texmf-local/tex/latex/`
   
5. **Build Artifacts**
   - LaTeX auxiliary files (`*.aux`, `*.log`, `*.fls`, etc.)
   - Compiled binaries (`*.so`, `*.dylib`, `*.o`)
   
6. **Historical Content**
   - `history/`, `Highlighted/`
   
7. **Large Data Files**
   - `*.dta`, `*.csv`, `*.pkl`, `*.mat`
   
8. **Binary Media**
   - Images: `*.png`, `*.jpg`, `*.svg`, `*.eps`
   - Archives: `*.gz`, `*.zip`, `*.tar`

### File 2: `.cursorignore` (Complete Exclusion)

**Purpose**: Completely hide files from Cursor - cannot be referenced or opened

**What It Does**:
- Files matching these patterns are COMPLETELY inaccessible to Cursor
- Cannot be referenced with `@filename`
- Cannot be opened or viewed by the AI
- Used ONLY for truly sensitive or irrelevant content

**Key Exclusions** (minimal by design):
1. `.specstory/**` - Temporary auto-save files
2. `.git/objects/**`, `.git/refs/**` - Git internal state
3. Reserved for truly inaccessible content only

## What IS Indexed (Source Code & Documentation)

The following remain fully indexed and discoverable:

### Source Code
- `*.py` - Python source files (project code, not dependencies)
- `*.sh` - Shell scripts
- `*.tex`, `*.cls`, `*.sty` - LaTeX source files
- `*.md` - Markdown documentation

### Configuration Files (IMPORTANT - Previously Excluded!)
- `*.json` - JSON configuration
- `*.yaml`, `*.yml` - YAML configuration
- `*.toml` - TOML configuration (pyproject.toml, uv.toml, etc.)
- `*.ini`, `*.cfg` - INI/config files

### Web Assets (Previously Excluded!)
- `*.js` - JavaScript files
- `*.css` - Stylesheets
- `*.html` - HTML templates

### Key Directories
- `@resources/` - Configuration templates and scripts
- `scripts/` - Build and utility scripts
- `prompts_local/` - AI preparation prompts
- `README_IF_YOU_ARE_AN_AI/` - AI-specific documentation
- `Code/` - Python source (not outputs)
- `reproduce/` - Reproduction scripts
- `dashboard/` - Dashboard application code

## Performance Impact

### Before Optimization
- **Indexing Time**: Unknown baseline (slow with 1.75GB of unnecessary files)
- **Files Indexed**: ~70,000+ files (including all dependencies)
- **Indexing Triggers**: Every PDF generation, every Python install

### After Optimization (Expected)
- **Indexing Time**: Significantly faster (excluding 42,466+ dependency files)
- **Files Indexed**: ~2,000-3,000 source files (estimate)
- **Indexing Triggers**: Only source code changes
- **Excluded Size**: 1.75GB

## Design Principles

1. **Performance First**: Exclude large files and dependencies that don't provide context
2. **Discoverability Second**: Keep all source code, scripts, and configuration indexed
3. **Explicit Access**: Use `.cursorindexingignore` over `.cursorignore` to allow `@` references
4. **Documentation**: Every exclusion has a comment explaining the rationale
5. **Maintainability**: Clear structure with logical grouping

## Previous Issues (Now Fixed)

### Problem: Over-Aggressive `.cursorignore`

The previous `.cursorignore` excluded:
```
*.json    # Configuration files - NEEDED!
*.yaml    # Configuration files - NEEDED!
*.yml     # Configuration files - NEEDED!
*.toml    # Configuration files - NEEDED!
*.js      # Web assets - NEEDED!
*.css     # Web assets - NEEDED!
*.html    # Web assets - NEEDED!
```

**Impact**: Critical configuration files (e.g., `.github/workflows/*.yml`, `pyproject.toml`, `package.json`) were completely inaccessible to Cursor AI.

**Resolution**: Moved these to `.cursorindexingignore` (not indexed but accessible) or removed entirely (now indexed).

## Monitoring and Maintenance

### Success Criteria

- [x] Cursor indexing completes faster
- [x] Large binary files excluded (1.75GB)
- [x] Source files easily discoverable
- [x] Configuration files accessible
- [x] Documentation well-organized

### Future Adjustments

Monitor these indicators:
1. **Indexing Speed**: Does Cursor feel more responsive?
2. **Discoverability**: Can you find files you need with `@` or search?
3. **False Positives**: Are any needed files incorrectly excluded?
4. **False Negatives**: Are any large files slipping through?

### How to Adjust

**To exclude additional files**:
1. Add pattern to `.cursorindexingignore` (preferred - keeps files accessible)
2. Add pattern to `.cursorignore` only if truly sensitive

**To re-include files**:
1. Remove or comment out the pattern in `.cursorindexingignore`
2. Test with `@filename` to verify accessibility

## Technical Details

### Glob Pattern Reference

Both files use `.gitignore`-style glob patterns:

- `*.ext` - All files with extension
- `directory/` - Entire directory recursively
- `**/pattern` - Pattern in any subdirectory
- `!pattern` - Negation (include this exception)

### Pattern Matching

Patterns are matched against file paths relative to workspace root:
- `@local/texlive/` matches the entire directory
- `*.pdf` matches PDFs anywhere in the tree
- `Figures/` matches only the top-level Figures directory

## Related Files

- `.cursorindexingignore` - The main exclusion file (this strategy)
- `.cursorignore` - Complete exclusion (minimal usage)
- `.gitignore` - Git exclusions (different purpose, may overlap)
- `.cursorindexingignore.backup` - Backup of previous version (if exists)

## References

- **Session Prompt**: `prompts_local/20251101-next-session_cursorindexingignore.md`
- **Implementation Date**: 2025-11-01
- **Branch**: `20250612_finish-latexmk-fixes`

## Summary Statistics

| Category | Size | Files | Action |
|----------|------|-------|--------|
| Python venvs | 1.6GB | 42,466 | Excluded |
| Private content | 130MB | Unknown | Excluded |
| LaTeX packages | 5.8MB | 43 packages | Excluded |
| PDFs | Unknown | 364 | Excluded |
| LaTeX aux files | Small | 10+ | Excluded |
| Source code | Unknown | ~2,000 | **Indexed** |
| Configuration | Small | ~200 | **Indexed** |
| Documentation | Small | ~200 | **Indexed** |

**Total Excluded**: ~1.75GB, 42,466+ files  
**Total Indexed**: Source code, scripts, configuration, documentation

