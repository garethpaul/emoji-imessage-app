# Changes

## 2026-06-26 05:46 - P1 - Reject oversized sticker bundles

### Summary
Closed a policy mismatch where runtime discovery silently loaded the first
1,024 stickers even though the maintained vision promised fail-closed rejection
of larger candidate sets.

### Work completed
- Added exact-limit and oversized-set executable Swift regressions.
- Replaced truncation with a dedicated `tooManyStickers` policy error.
- Aligned README, security, vision, and baseline contracts with complete-set
  rejection.

### Threads
- None; the cycle was implemented directly to avoid overlap.

### Files changed
- `MessagesExtension/StickerResourcePolicy.swift` — rejects more than 1,024 candidates.
- `Tests/TwemojiDescriptionTests/main.swift` — covers exact and exceeded limits.
- `scripts/check-baseline.sh` — rejects truncation and requires completed evidence.
- `README.md`, `SECURITY.md`, `VISION.md` — document fail-closed behavior.
- `docs/plans/2026-06-26-oversized-sticker-set*.md` — design and implementation record.

### Validation
- Official Swift 5.10 container — RED reproduced, then focused tests passed.
- Repository and external-directory `make check` — passed.
- Two hostile count-policy mutations — rejected.
- Implementation head `a6fedffc5656fdecfef4a768d67579a070a2f46f` — push and
  pull-request macOS checks passed executable Swift tests and unsigned builds;
  Actions and Swift CodeQL passed.
- Codex review — attempted and skipped after HTTP 401 authentication failure.
- Final evidence-only head — requires fresh hosted checks before merge.

### Bugs / findings
- P1: oversized valid bundles were partially presented, hiding packaging mistakes.

### Blockers
- Host `swiftc` and `xcodebuild` are unavailable; Swift container coverage
  passed and the Xcode build remains a hosted merge gate.

### Next action
- Record an exact upstream Twemoji revision during the next reviewed asset refresh.

## 2026-06-19

- Hardened runtime sticker discovery to accept only direct regular non-symlink
  PNG files, reject empty or oversized entries, and cap deterministic loading.
- Extended executable Swift coverage through the real resource policy and
  accessibility-description code paths.

## 2026-06-16

- Extracted Twemoji description behavior into framework-independent Swift and
  added executable valid-decoding and invalid-input fallback cases to
  `make check`.

## 2026-06-15

- Bundled Twemoji graphics are attributed in THIRD_PARTY_NOTICES.md under CC BY 4.0.
- Added a static 834-PNG inventory and attribution-retention boundary for future
  asset refreshes.

## 2026-06-14

- Made the portable checker and Xcode project targets resolve paths from the
  Makefile location so they work from external working directories.

## 2026-06-13

- Removed the Messages extension storyboard's template label and constraints so
  the programmatic sticker browser is the sole content surface.
- Added a version-recorded manual Messages checklist for sticker selection,
  preview, send, transcript, VoiceOver, privacy, logging, and failure evidence.
- Distinguished static and unsigned-build success from completed Messages-host
  interaction.
- Decode bundled Twemoji filename scalars into Unicode sticker accessibility
  descriptions instead of exposing hexadecimal asset identifiers.
- Validate all 834 asset stems and preserve a fail-closed filename fallback.

## 2026-06-12

- Migrated the project compiler setting and extension source from Swift 3-era
  API names to Swift 5 and raised the unsupported iOS 10 minimum to iOS 12.
- Added `make xcode-build` for an unsigned iPhone Simulator build of the host
  app and Messages extension.
- Extended macOS CI and the static baseline to reject project-parse-only or
  Swift 3 regressions.

## 2026-06-10

- Upgraded bundled sticker checks from PNG signature sniffing to complete chunk
  boundary, type, CRC, dimension, image-data, and terminal-marker validation.
- Added a mutation-tested plan and documentation for sticker resource
  integrity failures that would otherwise be skipped at runtime.
- Added a pinned, read-only `macos-15` GitHub Actions workflow that does not
  persist checkout credentials and runs the maintenance baseline and hosted
  Xcode project parse.
- Added cancellation and a ten-minute timeout, then made the workflow and CI
  plan part of the checked source contract.

## 2026-06-09

- Made sticker loading own browser reloads so failed load attempts clear stale
  visible stickers.
- Loaded stickers from exact discovered PNG resource paths instead of
  reconstructing resource lookups with fixed extension casing.
- Filtered sticker resources by case-insensitive PNG path extension.
- Removed sticker-loading debug logging and exposed `make lint`, `make test`,
  and `make build` aliases for the static baseline.
- Added a guard for signing, provisioning, Xcode user, archive, and build
  artifacts.
- Added a Swift source privacy guard for network, analytics, ad identifier,
  camera, microphone, location, and webview APIs.
- Made the sticker browser child controller optional instead of implicitly
  unwrapped.
- Added the child browser view before calling `didMove`, matching UIKit child
  controller lifecycle order.
- Added a static baseline guard for the child-controller setup.
- Normalized sticker asset names by stripping only the PNG path extension.

## 2026-06-08

- Added a repeatable `make check` baseline for the Swift iMessage extension.
- Cleared stale sticker state before resolving bundle resources so failed
  reloads cannot leave an old sticker set visible.
- Made sticker loading deterministic, defensive, and stable across repeated
  loads.
- Sized the sticker browser to the extension container bounds with autoresizing.
- Documented the Twemoji asset set, privacy posture, and Xcode verification
  expectations.
