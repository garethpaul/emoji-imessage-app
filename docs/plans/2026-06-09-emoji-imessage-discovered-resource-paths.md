# Emoji iMessage Discovered Resource Paths

status: completed

## Context

Sticker discovery filtered bundle files by case-insensitive PNG path extension,
but sticker creation still reopened each image with `pathForResource` and a
fixed lowercase `"png"` type. That made discovery and loading disagree for any
valid bundled PNG whose filename casing differed from the lookup type.

## Objectives

- Keep deterministic sticker discovery by sorted bundle filename.
- Load stickers from the exact discovered PNG file path.
- Preserve localized sticker descriptions based on the filename without its
  extension.
- Extend the static baseline and docs so discovery and loading stay aligned.

## Work Completed

- Changed sticker loading to pass each discovered filename and bundle resource
  path into sticker creation.
- Built sticker URLs with `appendingPathComponent(file)` instead of
  reconstructing a `pathForResource` lookup with fixed extension casing.
- Kept localized descriptions derived by stripping only the filename extension.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`

Full Xcode project parsing is still skipped locally because `xcodebuild` is
not installed in this environment.
