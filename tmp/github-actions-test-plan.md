# GitHub Actions Testing Plan

## Your Existing WSL2 Testing

The `.github/workflows/test-latex-compilation.yml` workflow already tests WSL2!

### What It Does

```yaml
matrix:
  os: [ubuntu-latest, macos-latest, windows-latest]  # ← Includes Windows

steps:
  - name: Set up WSL2 and Ubuntu (Windows)
    if: runner.os == 'Windows'
    uses: Vampire/setup-wsl@v2
    with:
      distribution: Ubuntu-22.04
      
  - name: Set up Python environment (WSL2)
    if: runner.os == 'Windows'
    shell: wsl-bash {0}  # ← Runs in actual WSL2
    run: bash ./reproduce/reproduce_environment_comp_uv.sh  # ← Tests your changes!
```

## To Test Your Changes

### Step 1: Push to a Branch
```bash
git checkout -b test-wsl2-improvements
git add reproduce.sh reproduce/reproduce_environment_comp_uv.sh
git commit -m "Improve WSL2 compatibility: fix detection, PATH deduplication, graceful symlink handling"
git push origin test-wsl2-improvements
```

### Step 2: Watch GitHub Actions
1. Go to: https://github.com/llorracc/HAFiscal-Latest/actions
2. Find your workflow run
3. Click on "windows-latest" job
4. Look for:
   - "Set up Python environment (WSL2)" step
   - Check if symlink warnings appear
   - Verify script completes successfully

### Step 3: What to Look For

#### ✅ Success Indicators
- "✅ Created symlink: .venv -> .venv-linux" (if not on Windows FS)
- OR "⚠️  WARNING: Cannot create symlink on Windows filesystem" (if on Windows FS)
- Followed by: "✅ Continuing with direct venv path (no symlink)"
- Script completes without exit 1
- UV sync completes
- LaTeX compilation works

#### ❌ Failure Indicators  
- "❌ ERROR: Failed to create symlink" followed by exit 1
- Script stops during environment setup
- PATH errors
- UV not found

### Step 4: Check PATH Duplication
In the workflow, add a diagnostic step:
```yaml
- name: Check PATH for duplicates (WSL2)
  if: runner.os == 'Windows'
  shell: wsl-bash {0}
  run: |
    echo "=== Checking PATH for duplicates ==="
    echo "$PATH" | tr ':' '\n' | grep -E "\.local/bin|\.cargo/bin" | sort | uniq -c
    echo "Expected: '1' for each directory (no duplicates)"
```

## Alternative: Create a PR

If you create a PR, the workflow runs automatically and you can see results without pushing to main.

```bash
# After pushing to branch:
gh pr create --title "Test: WSL2 improvements" --body "Testing WSL2 compatibility fixes"
```

Then check the PR page for test results.
