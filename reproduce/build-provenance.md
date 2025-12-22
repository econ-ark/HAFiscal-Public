# Build Provenance Record

**Built on:** 2025-12-22 00:12:18 UTC

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
HAFiscal-Latest    0030d596  2025-12-21 19:09:01  Sync: baseline checkpoint
HAFiscal-make      031fc66a  2025-12-21 19:09:01  Sync: baseline checkpoint
```

**Full commit hashes:**
- Latest: `0030d5966b222fc829b4afa42cd7177351eca452`
- Make: `031fc66ad4cae3bda617e7b9c56b2f5e6d64bfc6`

## How to Reproduce This Build

To recreate this exact version of HAFiscal-Public from source:

```bash
# 1. Clone the source repositories (if not already cloned)
git clone https://github.com/llorracc/HAFiscal-Latest.git
git clone https://github.com/llorracc/HAFiscal-make.git

# 2. Check out the exact commits used for this build
cd HAFiscal-Latest && git checkout 0030d5966b222fc829b4afa42cd7177351eca452
cd ../HAFiscal-make && git checkout 031fc66ad4cae3bda617e7b9c56b2f5e6d64bfc6

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
cd HAFiscal-Latest && git rev-parse HEAD  # Should output: 0030d5966b222fc829b4afa42cd7177351eca452
cd HAFiscal-make && git rev-parse HEAD    # Should output: 031fc66ad4cae3bda617e7b9c56b2f5e6d64bfc6
```

## Questions?

For questions about the source code or build process, please refer to:
- **HAFiscal-Latest**: Source files and research materials
- **HAFiscal-make**: Build scripts and workflow documentation
