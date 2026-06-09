---
title: Emoji iMessage Child Controller Lifecycle
date: 2026-06-09
status: completed
execution: code
---

## Context

`MessagesViewController` hosts the sticker browser as a child view controller.
The previous setup stored the child as an implicitly unwrapped optional and
called `didMove(toParentViewController:)` before adding the child view to the
container, which made the lifecycle less explicit than it needs to be.

## Goals

- Avoid implicitly unwrapped controller state in the Messages extension.
- Preserve the existing full-container sticker browser sizing.
- Follow the child-controller setup order: add child, add child view, then call
  `didMove`.
- Keep the guard available in environments without Xcode.

## Implementation

- Changed the browser controller property to an optional and used a local
  initialized controller inside `viewDidLoad`.
- Added the browser view before calling `didMove(toParentViewController:)`.
- Extended `scripts/check-baseline.sh` to preserve the optional property and
  child-controller lifecycle order.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode project parsing is still skipped locally because `xcodebuild` is
not installed in this environment.
