# Emoji iMessage PNG Extension Filter

status: completed

## Context

Sticker asset names were already derived by stripping only the PNG path
extension, but the resource loop still selected files with a literal `.png`
suffix check. That made discovery less consistent than the normalization path
and skipped bundled PNG resources with different extension casing.

## Objectives

- Keep deterministic sticker loading by sorted bundle filename.
- Filter sticker resources by path extension instead of literal suffix text.
- Treat PNG extension casing consistently.
- Extend the static baseline and docs so the resource filter remains visible.

## Work Completed

- Added an `isPNGResource(_:)` helper that checks the lowercased path
  extension.
- Replaced the literal `.png` suffix filter in sticker loading.
- Extended `scripts/check-baseline.sh` to require the path-extension filter and
  reject the old literal suffix check.
- Documented the guard in README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
