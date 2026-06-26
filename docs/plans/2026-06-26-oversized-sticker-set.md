# Oversized Sticker Set Implementation Plan

Status: Completed

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Reject sticker discovery when more than 1,024 valid PNG candidates exist instead of silently loading a partial set.

**Architecture:** `StickerResourcePolicy` will build the complete filtered and sorted direct-resource list, validate its count, and throw a dedicated error before returning. The existing controller catch/defer path will keep the browser empty and reload after rejection.

**Tech Stack:** Swift 5, Foundation, Messages framework, POSIX shell, Python 3, GNU Make, Docker

---

### Task 1: Establish the oversized-set regression

**Files:**
- Modify: `Tests/TwemojiDescriptionTests/main.swift`

1. Replace the current truncation expectation with an assertion that 1,025
   valid candidates throw `StickerResourcePolicyError.tooManyStickers`.
2. Add a separate exact-limit fixture proving 1,024 candidates are accepted.
3. Run the executable test under an official Swift container and confirm RED
   because the current implementation returns 1,024 entries.

### Task 2: Reject oversized discovery

**Files:**
- Modify: `MessagesExtension/StickerResourcePolicy.swift`

1. Add the dedicated policy error.
2. Materialize the filtered and sorted candidates before applying the count
   validation.
3. Throw when count exceeds the maximum and return the complete list otherwise.
4. Re-run the focused executable test and confirm GREEN.

### Task 3: Bind repository contracts

**Files:**
- Modify: `scripts/check-baseline.sh`
- Modify: `README.md`
- Modify: `SECURITY.md`
- Modify: `VISION.md`
- Modify: `CHANGES.md`
- Modify: `docs/plans/2026-06-26-oversized-sticker-set.md`

1. Require the error, exact-limit and oversized tests, completed plan evidence,
   and consistent fail-closed documentation.
2. Record RED/GREEN commands, mutation evidence, runtime boundaries, and hosted
   results.
3. Run focused tests, all Make aliases, external-directory verification, shell
   syntax, `git diff --check`, hosted Xcode/CodeQL, and exact-head review.

### Task 4: Publish

1. Commit the focused patch.
2. Push and open a PR against `master`.
3. Attempt Codex review; skip authentication-only failures as directed.
4. Merge only the exact hosted-green head SHA.

## Verification Evidence

- RED: under the official Swift 5.10 container, the current policy returned a partial 1,024-sticker set
  and the new oversized regression terminated at
  `expected discovery to fail`.
- GREEN: the same container printed `Twemoji description Swift tests passed.`
  after the dedicated error and exact-limit behavior were implemented.
- Boundary coverage: 1,024 valid candidates remain accepted; 1,025 valid
  candidates raise `StickerResourcePolicyError.tooManyStickers`.
- Mutation testing: hostile truncation mutations were rejected, including a
  restored first-1,024 partial result and an off-by-one rejection of the exact
  supported limit.
- Portable verification: repository and external-directory make check passed;
  the Swift container also executed the behavior test rather than taking the
  host compiler skip.
- Platform boundary: local `xcodebuild` is unavailable, so the exact-head
  hosted macOS unsigned simulator build is the required Apple-platform result.
