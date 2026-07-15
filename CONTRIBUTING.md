# Contributing to crosshatch-pmos

Thank you for your interest in contributing! This project builds postmarketOS for the Google Pixel 3 XL using GitHub Actions.

## Ways to Contribute

- 🐛 **Report bugs** — Open an issue with your build log
- 📖 **Improve docs** — Fix typos or clarify steps in README
- 🔧 **Add kernel patches** — Submit patches that fix hardware issues
- 📦 **New packages** — Suggest or add support for additional packages

## Submitting a Patch

1. Fork the repository
2. Create a new branch: `git checkout -b fix/your-fix-name`
3. Make your changes and test by triggering a workflow run
4. Open a Pull Request with a clear description of the change and why it's needed

## Kernel Patch Guidelines

All kernel patches should be placed in `fix_dtsi.sh` or added as proper `.patch` files referenced in the `APKBUILD`. Please:

- Document **why** the patch is needed (link upstream bug if possible)
- Test that the patch applies cleanly to Linux 5.3-rc5
- Keep patches minimal — only change what's needed

## Code Style

- Shell scripts: follow existing `set -e` convention, use emoji prefixes for log lines (🔧, ✅, ❌)
- YAML workflows: keep steps clearly separated with comment headers

## Questions?

Open an issue and tag it with `question`.
