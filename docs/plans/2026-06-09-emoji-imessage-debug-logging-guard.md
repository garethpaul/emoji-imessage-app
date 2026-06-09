---
title: Emoji iMessage Debug Logging Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

Sticker loading logged bundle paths, asset names, and local errors from the
Messages extension. The extension does not need those diagnostics in checked-in
source.

## Goals

- Remove `print`-style logging from Messages extension Swift sources.
- Keep sticker loading fail-closed when resources cannot be resolved or loaded.
- Extend the static baseline so future Swift source changes do not add debug
  logging.
- Expose standard `make lint`, `make test`, and `make build` aliases for the
  baseline gate.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Xcode project parsing is still skipped locally because `xcodebuild` is
not installed in this environment.
