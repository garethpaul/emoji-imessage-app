---
title: Emoji iMessage Privacy Source Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The README and vision state that the checked-in Messages extension does not
include network or analytics behavior. The baseline verified project metadata,
sticker loading, and PNG assets, but did not enforce that privacy claim against
future Swift source changes.

## Goals

- Fail the baseline when extension Swift sources introduce network or webview
  APIs.
- Fail the baseline when Swift sources introduce analytics, telemetry, ad
  identifier, camera, microphone, or location APIs.
- Keep the check available without Xcode installed.
- Document the privacy source guard for future iMessage extension changes.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode project parsing is still skipped locally because `xcodebuild` is
not installed in this environment.
