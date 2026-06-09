---
title: Emoji iMessage Sticker Reload
date: 2026-06-08
status: completed
execution: code
---

## Context

`TwemojiBrowserViewController.loadStickers()` cleared its sticker array only
after resolving and reading the bundle resource directory. If a later reload
failed before that point, the browser could keep showing stale stickers from a
previous successful load.

## Goals

- Clear stale stickers before any bundle resource lookup can fail.
- Preserve deterministic filename sorting and per-asset descriptions.
- Keep verification available without Xcode installed.

## Implementation

- Moved `stickers.removeAll()` to the start of `loadStickers()`.
- Added a baseline assertion that the clear happens before bundle resource
  resolution.
- Recorded the behavior in `CHANGES.md`.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode build verification is still unavailable in this environment because
`xcodebuild` is not installed.
