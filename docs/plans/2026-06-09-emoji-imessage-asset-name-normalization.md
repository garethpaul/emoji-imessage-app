---
title: Emoji iMessage Asset Name Normalization
date: 2026-06-09
status: completed
execution: code
---

## Context

`TwemojiBrowserViewController.loadStickers()` derived sticker asset names with
a string replacement that removed every `.png` substring, not just the file
extension. The bundled Twemoji filenames are simple today, but asset name
normalization should stay tied to the path extension.

## Goals

- Preserve deterministic sticker loading from bundled PNG files.
- Derive asset names by stripping only the path extension.
- Keep per-asset localized descriptions unchanged.
- Extend the SDK-free baseline so broad string replacement does not return.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
