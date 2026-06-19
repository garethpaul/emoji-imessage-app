---
title: Emoji Accessible Sticker Descriptions
type: accessibility
status: completed
date: 2026-06-13
---

# Emoji Accessible Sticker Descriptions

## Summary

Decode each bundled Twemoji filename into its Unicode scalar sequence before
creating `MSSticker` so assistive technologies receive the emoji itself rather
than a hexadecimal asset identifier such as `1f600`.

## Priority

1. Replace opaque hexadecimal sticker labels with meaningful Unicode content.
2. Preserve deterministic discovery and exact discovered-resource loading.
3. Fail closed to the existing asset stem when a future filename cannot be
   decoded, rather than dropping the sticker or crashing.

## Requirements

- R1. Strip only the final path extension before interpreting an asset name.
- R2. Split the asset stem on hyphens and decode every component as a Unicode
  scalar value.
- R3. Return the complete emoji scalar sequence only when every component is
  valid; otherwise return the original asset stem.
- R4. Use the decoded value as `MSSticker.localizedDescription` without
  changing the exact discovered file URL.
- R5. The static gate must validate that all 834 checked-in PNG stems are
  decodable and must preserve the fallback implementation contract.
- R6. The macOS hosted build must continue compiling the Swift 5 host app and
  Messages extension without weakening existing PNG, privacy, signing, or
  workflow checks.

## Non-Goals

- Renaming or regenerating the Twemoji PNG corpus.
- Providing English CLDR names or adding a localization catalog.
- Changing sticker ordering, size, extension lifecycle, or reload ownership.
- Claiming simulator VoiceOver interaction without Apple-platform tooling.

## Implementation Units

### 1. Unicode Description Decoder

Files: `MessagesExtension/TwemojiBrowserViewController.swift`

- Add a private helper that derives the extensionless asset stem.
- Decode every hyphen-separated hexadecimal component into a Unicode scalar.
- Return the original stem for empty or invalid component sequences.
- Pass the decoded string to `MSSticker` while retaining the existing file URL.

### 2. Static Corpus and Source Contracts

Files: `scripts/check-baseline.sh`

- Require the decoder and fallback source structure.
- Parse every checked-in PNG stem and reject nonhexadecimal, out-of-range, or
  surrogate scalar components.
- Require the completed plan and verification evidence.

### 3. Project Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

- Document the accessibility label boundary and filename fallback.
- Keep Apple-platform runtime verification limitations explicit.

## Verification

- Linux portable verification: `make check`, `make lint`, `make test`, and
  `make build` passed.
- All 834 PNG stems decoded to valid Unicode scalar sequences, including 11
  multi-scalar keycap filenames.
- Replacing the decoder call with the raw asset stem failed the static gate.
- Removing the invalid-input filename fallback failed the static gate.
- `git diff --check` passed.
- Local UIKit compilation and simulator VoiceOver interaction were unavailable
  without Xcode; the exact pushed head requires the bounded hosted macOS build
  snapshot before aggregate promotion.

## Work Completed

- Added an all-components-valid Unicode scalar decoder with an asset-stem
  fallback.
- Passed decoded emoji sequences to `MSSticker.localizedDescription` while
  preserving exact discovered file URLs.
- Added source, corpus-count, scalar-range, surrogate, and completed-plan
  contracts to the portable gate.
- Updated accessibility, security, and maintenance guidance.
