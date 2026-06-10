# Emoji iMessage CI Baseline

Status: Completed

## Context

The repository had a comprehensive static `make check` gate and an optional
Xcode project parse, but no hosted workflow exercised either path.

## Changes

- Added a GitHub Actions workflow on the supported `macos-15` runner so
  `xcodebuild -list` validates the checked-in project alongside static guards.
- Pinned checkout by commit, granted read-only repository access, enabled
  stale-run cancellation, and limited the job to ten minutes.
- Extended the baseline checker and project documentation so the hosted Xcode
  parse remains part of the maintenance contract.

## Verification

- `make check`
- Workflow YAML parsing
- `git diff --check`
- Hosted macOS `xcodebuild -list` through `make check`
