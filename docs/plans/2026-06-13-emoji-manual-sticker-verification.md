---
title: Emoji iMessage Manual Sticker Verification
type: documentation
date: 2026-06-13
status: planned
---

# Emoji iMessage Manual Sticker Verification

## Summary

Document a bounded, reproducible Messages verification checklist for opening
the extension, selecting a bundled sticker, sending it, and checking the
accessible description without conflating those manual results with the hosted
unsigned build.

## Problem Frame

The repository has a portable static gate and an Xcode 16.4 unsigned simulator
build, but its usage guidance stops at opening the project and running a scheme.
The vision still calls for manual notes covering the user-visible sticker flow.
This Linux environment cannot launch Messages or VoiceOver, so the checklist
must clearly separate required steps from locally unperformed platform results.

## Requirements

- R1. State the maintained Swift 5, iOS 12 minimum, and Xcode 16.4 verification
  baseline without claiming broader runtime support.
- R2. Identify the host app and Messages extension flow needed to expose the
  sticker browser in a simulator or device conversation.
- R3. Require selecting a bundled emoji, confirming its preview, sending it,
  and confirming it appears in the transcript.
- R4. Include a VoiceOver/accessibility-description check for at least one
  single-scalar and one multi-scalar sticker.
- R5. Include failure notes for an empty browser, missing stickers, send
  failures, stale content, crashes, path/error logging, and unexpected network
  or permission behavior.
- R6. Keep `make check` and `make xcode-build` as prerequisites, and state that
  they do not prove Messages-host interaction.
- R7. Enforce the checklist, roadmap update, and truthful completed evidence in
  the static repository gate.

## Implementation Units

### U1. Add Manual Verification Guidance

- **Files:** `README.md`, `AGENTS.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`
- **Goal:** Document the supported toolchain and exact user-visible verification
  flow, expected results, and failure-reporting boundary.
- **Covers:** R1, R2, R3, R4, R5, R6

### U2. Enforce Truthful Documentation Evidence

- **Files:** `scripts/check-baseline.sh`, this plan
- **Goal:** Require the checklist and prevent static/build results from being
  described as completed simulator interaction.
- **Covers:** R7

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` on Linux.
- Apply isolated mutations for removed select/send, accessibility, failure,
  prerequisite, platform-limitation, roadmap, and plan-evidence guidance.
- Inspect exact paths, signing/secret-like additions, generated artifacts, and
  staged files before committing.
- Do not claim local Xcode, simulator, Messages, VoiceOver, or device execution;
  require the hosted macOS build before completing exact-head evidence.

## Risks

- Simulator and device behavior can vary by Xcode and iOS runtime; the checklist
  records the reviewed Xcode 16.4/iOS 12 baseline and asks contributors to state
  the exact runtime they exercised.
- Documentation cannot replace UI automation or XCTest coverage, neither of
  which is currently present.
