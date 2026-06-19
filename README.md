# emoji-imessage-app

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/emoji-imessage-app` is a Swift iMessage extension that presents a
bundled Twemoji image set as Messages stickers. It uses Swift 5 with an iOS 12
deployment target and has no network or analytics behavior
in the checked-in source.

## Repository Contents

- `README.md` - project overview and local usage notes
- `CHANGES.md` - maintenance history
- `Makefile` - local verification entry points
- `MessagesExtension` - source or example code
- `SECURITY.md` - security reporting and disclosure guidance
- `Twemoji` - source or example code
- `Twemoji.xcodeproj` - Xcode project file
- `VISION.md` - project direction and maintenance guardrails

Additional project context:

- Source directories: MessagesExtension, Twemoji
- Dependency and build manifests: Makefile, Twemoji.xcodeproj
- Entry points or build surfaces: Twemoji.xcodeproj, Makefile
- Test-looking files: no obvious test files detected

## Third-Party Assets

Bundled Twemoji graphics are attributed in THIRD_PARTY_NOTICES.md under CC BY 4.0.
The original upstream tag or commit is not recorded, so future asset refreshes
must document their exact source revision before replacing the current corpus.

## Getting Started

### Prerequisites

- Git
- macOS with Xcode for building Apple platform projects
- Python 3 for the repository baseline script
- `make`

### Setup

```bash
git clone https://github.com/garethpaul/emoji-imessage-app.git
cd emoji-imessage-app
```

This project uses an iOS 12 deployment baseline with Swift 5 source and current
UIKit/Foundation API names. The reviewed hosted build uses Xcode 16.4; record
the exact Xcode and iOS runtime when performing manual verification.

## Running or Using the Project

- Open `Twemoji.xcodeproj` in Xcode, choose the app or sample scheme, and run it on the matching simulator/device.
- The Messages extension loads bundled PNG stickers from `MessagesExtension`
  deterministically by filename.
- Sticker discovery filters bundled resources by case-insensitive PNG path
  extension.
- Sticker creation uses exact discovered PNG file paths, keeping resource
  discovery and loading aligned with bundled filename casing.
- Sticker asset names are derived by stripping only the PNG path extension.
- Sticker loading reloads the sticker browser after every load attempt, including
  fail-closed resource lookup paths.
- The extension does not request device permissions and does not include network
  or analytics code in the checked-in Swift sources.
- Sticker loading fails closed without debug logging of bundle paths, asset
  names, or errors.

## Testing and Verification

Run the maintenance gate, including portable Twemoji description behavior tests
when `swiftc` is available:

```bash
make check
make lint
make test
make build
make xcode-build
```

`make check` validates the Xcode project references, extension plists, Swift
source invariants, child-controller setup order, and bundled Twemoji PNG
signatures. It also scans Swift sources for network, analytics, ad identifier,
camera, microphone, location, webview APIs, and debug logging. `make lint`,
`make lint` and `make build` run the static baseline. `make test` compiles the
framework-independent decoder and its executable cases with `swiftc`; it reports
a truthful skip when Swift is unavailable. Twemoji description behavior covers
valid single- and multi-scalar filenames plus invalid-input fallback cases.
When `xcodebuild` is installed, the baseline checks that Xcode can read
`Twemoji.xcodeproj`; `make xcode-build` performs an unsigned iPhone Simulator
build of the host app and Messages extension.

All Make targets resolve repository files from the Makefile location, so the
same commands also work when the Makefile is invoked from another directory.

Bundled sticker validation parses every PNG chunk, verifies chunk boundaries
and CRCs, requires a valid initial `IHDR`, positive dimensions, image data, and
a terminal `IEND`, and rejects trailing bytes. This catches resource corruption
before `MSSticker` silently skips an asset at runtime.
Sticker accessibility descriptions decode each hyphen-separated hexadecimal
asset stem into its Unicode emoji sequence. A future invalid stem falls back to
the extensionless filename instead of dropping the sticker or crashing.
Runtime discovery accepts only direct, regular, non-symlink PNG files between
1 byte and 500 KiB, sorts them by filename, and caps the browser at 1,024
stickers. Malformed image contents are skipped by `MSSticker` without leaving
stale browser data visible.
The extension storyboard contains no template label or placeholder subview;
the programmatic sticker browser is the sole content surface.

GitHub Actions runs `make check` and `make xcode-build` on a `macos-15` runner
for pushes, pull requests, and manual dispatches. The hosted job pins checkout
by commit, uses read-only repository permissions, does not persist checkout credentials,
and performs the simulator build that is unavailable on non-Apple development
machines.

For full Apple-platform verification, open `Twemoji.xcodeproj` in Xcode and run
the app/extension on an iOS simulator or device.

### Manual Messages Verification

The maintained baseline is Swift 5 with an iOS 12 minimum and a reviewed
Xcode 16.4 hosted build; record the exact runtime used because that build does not
establish behavior on every supported iOS version.

Complete `make check` and `make xcode-build` before testing the user-visible
flow. Those commands prove repository invariants and compilation, not Messages
host interaction.

1. Record the Xcode version, iOS simulator or device version, and device model.
2. Select and run the `MessagesExtension` scheme. When Messages opens, enter a
   test conversation, open the app drawer, and select the Twemoji extension.
3. Confirm the sticker browser is populated, scroll it, and reopen the extension
   to confirm stale or duplicated stickers do not appear.
4. Tap one bundled sticker and confirm it appears in the Messages input field.
   Use the Messages send control and confirm the same sticker appears in the
   conversation transcript. Also press and hold a sticker and drag it onto an
   existing message balloon to verify the standard sticker attachment path.
5. With VoiceOver enabled, focus one single-scalar sticker and one multi-scalar
   sticker such as a keycap. Confirm each accessible description announces the
   emoji rather than a raw hexadecimal asset stem.
6. Confirm the extension requests no permissions, performs no network activity,
   and prints no bundle paths, asset names, or local errors to the console.

Record failures with the exact toolchain/runtime and whether the browser was
empty, a sticker was missing, preview or send failed, stale content remained,
the extension crashed, a raw asset stem was announced, private path/error data
was logged, or unexpected permission/network behavior occurred. Do not mark
manual verification complete unless the selection, preview, send, transcript,
and accessibility checks were actually exercised.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file is used by this extension.
- Do not commit signing certificates, provisioning profiles, Xcode user data,
  build products, or private assets.
- `.gitignore` and `scripts/check-baseline.sh` guard common signing artifacts
  such as `.mobileprovision`, `.provisionprofile`, `.p12`, `.cer`, and
  `.xcarchive` files.

## Security and Privacy Notes

- Review changes touching sticker asset discovery, extension plist metadata,
  bundle resources, signing, and Messages extension lifecycle callbacks.
- Keep the extension free of message-content collection, analytics, and network
  behavior unless a future change documents the user value and privacy model.
- Keep sticker loading free of debug logging that reveals bundle paths, asset
  names, or local errors.
- Keep sticker loading responsible for its own browser reload so failed loads do
  not leave stale stickers visible.
- Preserve the runtime regular-file, symlink, path-containment, file-size, and
  sticker-count bounds when changing bundle resource discovery.
- Keep the bundled sticker corpus structurally valid; the baseline verifies PNG
  chunks and CRCs rather than accepting signature-only files.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `docs/plans/2026-06-08-emoji-imessage-app-maintenance-baseline.md` for
  the current baseline plan.
- See `docs/plans/2026-06-09-emoji-imessage-child-lifecycle.md` for the
  sticker browser child-controller lifecycle guard.
- See `docs/plans/2026-06-09-emoji-imessage-privacy-source-guard.md` for the
  Swift privacy source guard.
- See `docs/plans/2026-06-09-emoji-imessage-asset-name-normalization.md` for
  sticker asset-name normalization.
- See `docs/plans/2026-06-09-emoji-imessage-png-extension-filter.md` for the
  sticker PNG extension filter.
- See `docs/plans/2026-06-09-emoji-imessage-discovered-resource-paths.md` for
  exact discovered PNG resource path loading.
- See `docs/plans/2026-06-09-emoji-imessage-signing-artifact-guard.md` for the
  signing and local Xcode artifact guard.
- See `docs/plans/2026-06-09-emoji-imessage-debug-logging-guard.md` for the
  Swift debug logging guard.
- See `docs/plans/2026-06-09-emoji-imessage-load-reload-ownership.md` for sticker
  browser reload ownership during sticker loading.
- See `docs/plans/2026-06-10-emoji-imessage-ci-baseline.md` for the hosted macOS
  and Xcode project-parse baseline.
- See `docs/plans/2026-06-10-emoji-png-integrity.md` for complete bundled PNG
  structure and CRC validation.
- See `docs/plans/2026-06-12-swift5-xcode-build-gate.md` for the Swift 5
  migration and hosted simulator build contract.
- See `docs/plans/2026-06-13-emoji-accessible-sticker-descriptions.md` for the
  Unicode sticker accessibility label boundary.
- See `docs/plans/2026-06-13-emoji-manual-sticker-verification.md` for the
  Messages selection, send, and VoiceOver verification checklist.
- See `docs/plans/2026-06-13-emoji-storyboard-placeholder-removal.md` for the
  extension template-content boundary.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
