#!/bin/bash
# Docker-based testing approach (limited)
# This tests the scripts but NOT WSL2-specific behavior

echo "=========================================="
echo "Docker-Based Testing"
echo "=========================================="
echo ""

# Test 1: Test scripts in Ubuntu container
echo "=== Test 1: Run in Ubuntu Container ==="
echo ""
echo "This tests:"
echo "  - Scripts don't break on regular Linux"
echo "  - PATH logic works"
echo "  - Automation environment detection works"
echo ""

cat > /tmp/test-in-docker.sh << 'DOCKER_EOF'
#!/bin/bash
set -e

cd /workspace

# Test 1: Check if scripts are valid bash
echo "Checking bash syntax..."
bash -n reproduce.sh
bash -n reproduce/reproduce_environment_comp_uv.sh
echo "✅ Syntax valid"
echo ""

# Test 2: Source functions and test
echo "Testing ensure_uv_in_path function..."
source <(sed -n '/^ensure_uv_in_path()/,/^}/p' reproduce/reproduce_environment_comp_uv.sh)

echo "PATH before:"
echo "$PATH" | tr ':' '\n' | grep -E "\.local/bin|\.cargo/bin" || echo "(none)"

# Call 4 times
ensure_uv_in_path
ensure_uv_in_path
ensure_uv_in_path
ensure_uv_in_path

echo ""
echo "PATH after 4 calls:"
DUPS=$(echo "$PATH" | tr ':' '\n' | grep -E "\.local/bin|\.cargo/bin" | sort | uniq -c | grep -v "^[[:space:]]*1 ")
if [[ -z "$DUPS" ]]; then
    echo "✅ No duplicates"
    echo "$PATH" | tr ':' '\n' | grep -E "\.local/bin|\.cargo/bin" | nl
else
    echo "❌ Duplicates found:"
    echo "$DUPS"
fi
DOCKER_EOF

chmod +x /tmp/test-in-docker.sh

echo "Running tests in Docker..."
echo "Command:"
echo "  docker run --rm -v \$(pwd):/workspace -w /workspace ubuntu:22.04 bash /tmp/test-in-docker.sh"
echo ""
echo "To run:"
echo "  cd /Volumes/Sync/GitHub/llorracc/HAFiscal-Latest"
echo "  docker run --rm -v \$(pwd):/workspace -w /workspace ubuntu:22.04 bash /tmp/test-in-docker.sh"
echo ""

# Test 2: Test automation environment detection
echo "=== Test 2: Automation Environment Detection ==="
echo ""
echo "Docker containers should be detected as automation environments"
echo ""
echo "To test:"
echo "  docker run --rm -v \$(pwd):/workspace -w /workspace ubuntu:22.04 bash -c 'cd /workspace && grep -A 20 \"is_automation_environment()\" reproduce.sh | head -30'"
echo ""

echo "=========================================="
echo "Limitations of Docker Testing"
echo "=========================================="
echo ""
echo "✅ Can test:"
echo "   - Script syntax"
echo "   - PATH deduplication logic"
echo "   - Automation detection"
echo "   - Regular Linux behavior"
echo ""
echo "❌ Cannot test:"
echo "   - WSL2 detection (Docker doesn't have WSL2 kernel)"
echo "   - Windows filesystem mounts (/mnt/c/)"
echo "   - Symlink behavior on Windows FS"
echo "   - TERM handling specific to WSL2"
echo ""
echo "For full testing, use GitHub Actions (Option 1)"
echo ""
