# Emoji Sticker PNG Integrity

## Status: Completed

## Goal

Detect malformed or corrupted bundled sticker images before the Messages
extension reaches `MSSticker` creation and silently skips the affected asset.

## Changes

- Parse every bundled PNG as a sequence of length-delimited chunks instead of
  checking only the eight-byte file signature.
- Reject truncated chunk headers or payloads and non-alphabetic chunk types.
- Verify every chunk CRC with the Python standard library.
- Require an initial 13-byte `IHDR` with positive dimensions, at least one
  `IDAT`, and a zero-length terminal `IEND` with no trailing bytes.
- Keep the existing corpus-count and Xcode resource-reference checks.
- Document and baseline the stronger asset integrity contract.

## Verification

- `make check`
- `git diff --check`
- All 834 bundled sticker images pass full structural and CRC validation.
- Corrupting an `IDAT` byte in a temporary working copy causes `make check` to
  fail with the affected file and CRC error.
