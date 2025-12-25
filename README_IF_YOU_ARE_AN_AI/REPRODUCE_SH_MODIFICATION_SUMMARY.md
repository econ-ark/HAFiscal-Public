# reproduce.sh Modification Summary

**Date:** 2025-10-20  
**Purpose:** Ensure computational results are reproduced before any LaTeX/document compilation

---

## Changes Made

### 1. `run_automatic_reproduction()` Function

**Location:** Line ~476

**OLD Execution Order:**
1. Documents (LaTeX compilation)
2. Subfiles (standalone LaTeX files)
3. Minimal computational results
4. All computational results

**NEW Execution Order:**
1. Minimal computational results ← **MOVED UP**
2. All computational results ← **MOVED UP**
3. Documents (LaTeX compilation) ← **MOVED DOWN**
4. Subfiles (standalone LaTeX files) ← **MOVED DOWN**

**Impact:** When `reproduce.sh` is run without arguments in non-interactive mode, computational code now runs strictly before any figure/document generation.

---

### 2. `process_reproduce_targets()` Function

**Location:** Line ~559

**OLD Execution Order:**
```bash
for ordered_target in docs comp all; do  # Note: this is the top-level --all action, not --comp scope
```

**NEW Execution Order:**
```bash
for ordered_target in comp docs all; do  # computation before documents
```

**Impact:** When using `REPRODUCE_TARGETS` environment variable (e.g., `REPRODUCE_TARGETS=comp,docs`), computational targets now execute before document targets regardless of order specified.

**Note:** As of 2025-10-27, `--comp all` has been renamed to `--comp full` to better describe that it produces all computational results needed for the printed document.

---

### 3. `reproduce_all_results()` Function

**Status:** No changes needed ✅

**Reason:** This function already had the correct order:
1. All computational results (first)
2. All documents (second, which depend on computation)

---

## Verification

✅ Script syntax validated with `bash -n reproduce.sh`  
✅ Step numbering correct (1, 2, 3, 4)  
✅ All step increments present (`((step++))`)  
✅ Final summary reflects new execution order  
✅ Comments updated to reflect "computation before documents"

---

## Backup

A backup of the original file was created:
- **Backup file:** `reproduce.sh.backup`
- **Location:** `/Volumes/Sync/GitHub/llorracc/HAFiscal-Latest/`

---

## Testing Recommendations

Before committing, test the following scenarios:

1. **No arguments:**
   ```bash
   ./reproduce.sh
   # (in non-interactive mode - should run comp before docs)
   ```

2. **With REPRODUCE_TARGETS:**
   ```bash
   REPRODUCE_TARGETS=docs,comp ./reproduce.sh
   # (should execute comp first, then docs)
   ```

3. **With --all flag:**
   ```bash
   ./reproduce.sh --all
   # (already correct, but verify it still works)
   ```

4. **Interactive mode:**
   ```bash
   ./reproduce.sh --interactive
   # (verify menu options work correctly)
   ```

---

## Rationale

The modification ensures that:
- **Computational outputs are generated first** (data, results, figures)
- **LaTeX compilation happens second** (documents that reference the outputs)
- **Dependency order is correct** (LaTeX needs computational results to exist)
- **No circular dependencies** (computation doesn't depend on compiled documents)

This prevents errors where LaTeX tries to include figures/tables that haven't been generated yet.

---

