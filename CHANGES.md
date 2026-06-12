# Changes

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
