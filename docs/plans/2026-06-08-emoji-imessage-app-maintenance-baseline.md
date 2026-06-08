---
title: Emoji iMessage App maintenance baseline
date: 2026-06-08
status: completed
execution: code
---

## Context

This repository is a Swift 3 / iOS 10-era iMessage extension that bundles a
large Twemoji PNG resource set. The previous README correctly identified the
Apple platform project but did not document the asset verification surface or a
repeatable baseline command.

Local verification found that `xcodebuild` is not installed in this environment,
so full simulator or device builds must be run on a macOS/Xcode machine.

## Goals

- Make sticker loading deterministic and avoid a bundle resource path force
  unwrap.
- Keep the sticker browser sized to the Messages extension container.
- Add a Linux-friendly baseline gate for project metadata, plists, source
  invariants, and bundled PNG assets.
- Document the iMessage extension scope, asset set, privacy posture, and Xcode
  verification expectations.

## Scope Boundaries

- Do not replace or bulk-update the Twemoji asset set in this pass.
- Do not modernize the project from Swift 3 to a newer Swift version without an
  Xcode migration pass.
- Do not add signing material, provisioning profiles, analytics, or network
  behavior.

## Implementation

- `MessagesViewController` sizes the sticker browser to `view.bounds` and gives
  it flexible autoresizing masks.
- `TwemojiBrowserViewController` guards the bundle resource path, clears stale
  sticker state, sorts bundled PNG resources, and uses the asset name as each
  sticker description.
- `scripts/check-baseline.sh` validates required files, project settings,
  plists, Swift source invariants, and PNG signatures. It runs `xcodebuild
  -list` when Xcode is available.
- `Makefile` exposes the baseline as `make check`.
- `README.md` and `VISION.md` document the current maintenance baseline.

## Verification

- `make check`
- `git diff --check`
- Full `xcodebuild` build not run locally because `xcodebuild` is unavailable.
