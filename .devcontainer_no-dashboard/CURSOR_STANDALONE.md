# Using Cursor with HAFiscal DevContainer (Standalone Mode)

## Overview

This guide explains how to use Cursor (or VS Code) to interact with the HAFiscal devcontainer as a completely **standalone system** that does NOT have access to your host machine's directory structure or LaTeX installation.

## Why Standalone Mode?

- **Reproducibility**: Container is identical across all machines
- **Isolation**: No dependencies on host machine's LaTeX or Python
- **Self-contained**: All tools (MiKTeX, Python, UV) installed inside container
- **Clean environment**: No conflicts with host software versions

---

## Prerequisites

1. **Install Cursor** (or VS Code): <https://cursor.sh/>
2. **Install Docker Desktop**: <https://www.docker.com/products/docker-desktop/>
3. **Install Dev Containers extension**:
   - Open Cursor
   - Press `Cmd+Shift+X` (macOS) or `Ctrl+Shift+X` (Windows/Linux)
   - Search for "Dev Containers"
   - Install "Dev Containers" by Microsoft

---

## Method 1: Open Repository in Container (Recommended)

This method clones the repository **inside** the container, keeping it completely isolated.

### Steps:

1. **Start Cursor/VS Code**

2. **Open Command Palette**:
   - macOS: `Cmd+Shift+P`
   - Windows/Linux: `Ctrl+Shift+P`

3. **Type and select**:

   ```
   Dev Containers: Clone Repository in Container Volume...
   ```

4. **Enter the Git URL**:

   ```
   https://github.com/llorracc/HAFiscal-Latest.git
   ```

   Or if you have SSH access:

   ```
   git@github.com:llorracc/HAFiscal-Latest.git
   ```

5. **Select the devcontainer configuration**:
   - Cursor will detect `.devcontainer/devcontainer.json`
   - Click "Open in Container"

6. **Wait for build** (first time: 10-15 minutes):
   - MiKTeX installation (~5 min)
   - UV and Python packages (~3-5 min)
   - Container initialization

7. **You're now in standalone mode!**
   - The repository exists ONLY inside the container
   - No connection to host filesystem
   - All changes are persisted in a Docker volume

### Important Notes:

- **Data persistence**: Files are stored in a Docker volume, not on your host machine
- **Container name**: Usually named `hafiscal-latest-...` (random ID)
- **Access container**: Can access it from Docker Desktop or command line
- **Backup**: Use git to push changes to GitHub regularly

---

## Method 2: Open Existing Container Folder (Alternative)

If you already have the repository on your host machine but want standalone mode:

1. **Open Cursor**

2. **Command Palette** (`Cmd+Shift+P` or `Ctrl+Shift+P`)

3. **Type and select**:

   ```
   Dev Containers: Open Folder in Container...
   ```

4. **Navigate to**:

   ```
   ~/projects/HAFiscal-Latest
   ```

   (or wherever your local clone is)

5. **Select "Open in Container"**

6. **Remove host mounts** (for true standalone mode):
   - Edit `.devcontainer/devcontainer.json`
   - Remove or comment out any `mounts` section
   - Rebuild container: `Cmd+Shift+P` → "Dev Containers: Rebuild Container"

**Note**: This method still connects to host filesystem by default. For true isolation, use Method 1.

---

## What's Inside the Container?

When you're in the devcontainer, you have:

✅ **Python 3.9** with UV package manager  
✅ **MiKTeX LaTeX distribution** (~500 MB, self-contained)  
✅ **All Python dependencies**: numpy, pandas, HARK, matplotlib, etc.  
✅ **Jupyter Lab** (port 8888 forwarded)  
✅ **Git + GitHub CLI**  
✅ **LaTeX tools**: pdflatex, bibtex, latexmk  
✅ **Auto-package installation**: MiKTeX downloads packages on-demand  

❌ **No access to host LaTeX**  
❌ **No access to host Python**  
❌ **No access to host filesystem** (in Method 1)  

---

## Working in the Container

### 1. Terminal Access

Open integrated terminal in Cursor:

- macOS: `` Ctrl+` ``
- Windows/Linux: `` Ctrl+` ``

You'll see:

```bash
vscode@container-id:/workspaces/HAFiscal-Latest$
```

This is **inside** the container, NOT your host machine.

### 2. Building HAFiscal PDF

```bash
# Navigate to build system (clone it if using Method 1)
cd /workspaces
git clone https://github.com/llorracc/HAFiscal-make.git

# Run the build
cd HAFiscal-make
./makePDF-Portable-Latest.sh
```

First run will be slower as MiKTeX downloads required packages.

### 3. Running Python Code

```bash
cd /workspaces/HAFiscal-Latest

# Activate virtual environment (automatically activated)
source .venv/bin/activate

# Run Python scripts
python Code/HA-Models/do_all.py

# Or use Jupyter
jupyter lab --ip=0.0.0.0 --port=8888
```

### 4. Editing Files

- Edit any file in Cursor as normal
- All changes are in container (Method 1) or host (Method 2)
- Use Git to commit/push changes

### 5. Git Workflow

```bash
# Check status
git status

# Stage and commit
git add .
git commit -m "Your message"

# Push to GitHub
git push origin your-branch
```

**Important**: In Method 1 (standalone), your changes only exist in the container until pushed to GitHub.

---

## Verifying Standalone Mode

Run these commands in the container terminal to verify isolation:

```bash
# Check LaTeX version (should be MiKTeX inside container)
pdflatex --version
# Output should mention "MiKTeX"

# Check LaTeX location
which pdflatex
# Output: /usr/bin/pdflatex (inside container)

# Check Python version
python --version
# Output: Python 3.9.x

# Check UV
uv --version
# Output should show UV version

# Try to access host filesystem (should fail in Method 1)
ls /Volumes/Sync
# Output: ls: cannot access '/Volumes/Sync': No such file or directory

# Check MiKTeX packages
mpm --list
# Shows installed MiKTeX packages
```

---

## Troubleshooting

### Container Build Fails

**Problem**: MiKTeX installation fails  
**Solution**:

```bash
# Rebuild without cache
Cmd+Shift+P → "Dev Containers: Rebuild Container Without Cache"
```

### Package Installation Errors

**Problem**: MiKTeX can't find packages  
**Solution**: Refresh package database

```bash
initexmf --update-fndb
mpm --update
```

### Container is Slow

**Problem**: Poor performance  
**Solutions**:

- Increase Docker Desktop resources (CPU, RAM)
- Close other heavy applications
- Use SSD for Docker storage

### Lost Changes

**Problem**: Closed container, can't find files  
**Solutions**:

- Method 1 (standalone): Find container volume:

  ```bash
  docker volume ls
  docker volume inspect <volume-name>
  ```

- Method 2: Files are on your host filesystem

### Port Already in Use

**Problem**: Jupyter port 8888 already taken  
**Solution**: Change port in devcontainer.json:

```json
"forwardPorts": [8889, 8866],
```

---

## Advantages vs. Host Machine

| Feature | Host Machine | Standalone Container |
|---------|-------------|----------------------|
| **LaTeX Version** | Whatever you installed | Fresh MiKTeX (latest) |
| **Python Version** | System Python | Python 3.9 (isolated) |
| **Package Conflicts** | Possible | None (clean env) |
| **Reproducibility** | Varies by machine | Identical everywhere |
| **Setup Time** | Manual install | Automated (one-time wait) |
| **Disk Space** | Shared with system | Isolated (~2GB) |
| **Performance** | Native speed | Near-native (Docker overhead) |

---

## Best Practices

1. **Commit frequently**: In standalone mode, only pushed changes are backed up
2. **Use branches**: Work on feature branches, merge to main when stable
3. **Sync regularly**: `git pull` before starting work, `git push` when done
4. **Monitor resources**: Keep an eye on Docker Desktop resource usage
5. **Clean up**: Remove old containers/volumes periodically:

   ```bash
   docker system prune
   ```

---

## Advanced: Accessing Container via Command Line

If you need to access the container directly:

```bash
# List running containers
docker ps

# Find your container ID
docker ps | grep hafiscal

# Execute commands in container
docker exec -it <container-id> bash

# Or using Docker Desktop:
# Open Docker Desktop → Containers → Click on HAFiscal container → Terminal
```

---

## Summary

**Method 1 (Recommended for Standalone)**:

1. Cursor → `Cmd+Shift+P` → "Clone Repository in Container Volume"
2. Enter: `https://github.com/llorracc/HAFiscal-Latest.git`
3. Wait for build (10-15 min first time)
4. Work entirely inside container
5. Git push to save changes

**What you get**:

- Complete isolation from host machine
- Fresh MiKTeX LaTeX (no host dependencies)
- Python 3.9 + UV + all packages
- Reproducible environment
- Ready to build HAFiscal PDF

**Next steps after setup**:

```bash
# Inside container terminal:
cd /workspaces
git clone https://github.com/llorracc/HAFiscal-make.git
cd HAFiscal-make
./makePDF-Portable-Latest.sh
```

First PDF build will take 10-15 minutes as MiKTeX downloads packages on-demand. Subsequent builds are much faster (~3-5 minutes).

---

## Questions?

- Check Docker Desktop for container status
- View container logs: Docker Desktop → Containers → HAFiscal → Logs
- Rebuild if issues: `Cmd+Shift+P` → "Rebuild Container Without Cache"
