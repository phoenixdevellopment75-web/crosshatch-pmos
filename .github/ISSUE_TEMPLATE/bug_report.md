---
name: Bug Report
about: Report a build failure or flashing issue
title: '[BUG] '
labels: bug
assignees: ''
---

## Describe the bug
A clear and concise description of what went wrong.

## Build or Flash Step
- [ ] GitHub Actions build failed
- [ ] Flashing with fastboot failed
- [ ] Boot issue (stuck on logo, kernel panic)
- [ ] SSH / networking issue
- [ ] Other

## Workflow Run Link
If the build failed on GitHub Actions, paste the link to the failed run here:
`https://github.com/phoenixdevellopment75-web/crosshatch-pmos/actions/runs/...`

## Error Output
```
Paste the relevant error lines from the build log here
```

## Environment
- OS: (e.g. Ubuntu 22.04, CachyOS, Windows WSL2)
- `fastboot` version: (run `fastboot --version`)
- Android platform tools version:

## Additional context
Any other details that might help diagnose the problem.
