# Build Provenance Record

**Built on:** 2025-12-07 23:37:07 UTC

## About This Repository

This repository (HAFiscal-Public) is a **generated distribution** of the HAFiscal research project. It is automatically created by running the build workflow in the **HAFiscal-make** repository, which processes source files from the **HAFiscal-Latest** repository.

**This repository contains:**
- Transformed LaTeX source files (with private material removed)
- Compiled PDF of the paper
- HTML version for web viewing (on gh-pages branch)
- GitHub Actions workflow for automated deployment

**This repository does NOT contain:**
- Build scripts (those are in HAFiscal-make)
- Original development history (single-commit distribution)
- Private/internal research materials

## Source Commits

This build was generated from the following source repository commits:

```text
Repository         Hash      Date                 Commit Message
-----------------  --------  -------------------  ------------------------------------------------------------
HAFiscal-Latest    db2c412b  2025-12-07 18:36:01  QE-sync: file updates
HAFiscal-make      42224991  2025-12-07 18:36:01  QE-sync: file updates
```

**Full commit hashes:**
- Latest: `db2c412b040015df4178b54459f80dec743a5d58`
- Make: `42224991723a088f5cdb3efad1b2f38095d8291e`

## How to Reproduce This Build

To recreate this exact version of HAFiscal-Public from source:

```bash
# 1. Clone the source repositories (if not already cloned)
git clone https://github.com/llorracc/HAFiscal-Latest.git
git clone https://github.com/llorracc/HAFiscal-make.git

# 2. Check out the exact commits used for this build
cd HAFiscal-Latest && git checkout db2c412b040015df4178b54459f80dec743a5d58
cd ../HAFiscal-make && git checkout 42224991723a088f5cdb3efad1b2f38095d8291e

# 3. Run the build workflow
cd HAFiscal-make
./make-Latest-to-Public-to-QE.sh --omit-QE

# This executes the following sequence:
#   - ./make-Latest-to-Public.sh      (sync and transform source files)
#   - ./makePDF-Portable-Public.sh (compile PDF)
#   - ./makeWeb-HEAD-Public.sh    (generate HTML for web)
#   - ./postPublic-master.sh      (record provenance and push to remote)

# Result: ../HAFiscal-Public will match this exact build
```

## Verification

To verify your local repositories match the commits used for this build:

```bash
cd HAFiscal-Latest && git rev-parse HEAD  # Should output: db2c412b040015df4178b54459f80dec743a5d58
cd HAFiscal-make && git rev-parse HEAD    # Should output: 42224991723a088f5cdb3efad1b2f38095d8291e
```

## Questions?

For questions about the source code or build process, please refer to:
- **HAFiscal-Latest**: Source files and research materials
- **HAFiscal-make**: Build scripts and workflow documentation
