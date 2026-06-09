# Emoji iMessage Load Reload Ownership

Status: Completed
Date: 2026-06-09

## Goal

Keep the sticker browser UI synchronized with `loadStickers()` even when bundle
resource resolution or sticker creation fails closed.

## Changes

- Moved sticker browser reloading into `loadStickers()` with `defer`.
- Removed the parent controller's direct reload call after loading.
- Extended the static baseline to require load-owned browser reloads.
- Updated README, security notes, changelog, and vision with the reload ownership
  contract.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
