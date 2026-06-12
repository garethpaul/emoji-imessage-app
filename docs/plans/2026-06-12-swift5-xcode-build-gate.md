# Emoji iMessage Swift 5 Build Gate

## Status: In Progress

## Goal

Compile the Messages extension with the current hosted Xcode toolchain instead
of preserving an unbuilt Swift 3 project indefinitely.

## Prioritized Engineering Work

1. **Migrate the small Swift surface to Swift 5 and build it in CI (this
   change).** Update the compiler setting and renamed UIKit/Foundation APIs,
   then add an unsigned iPhone Simulator build for the `Twemoji` target to the
   macOS verification gate.
2. **Document and exercise the Messages interaction manually (follow-up).** Add
   a concise device/simulator checklist for opening the sticker browser,
   selecting a sticker, and sending it in a conversation.
3. **Clarify asset licensing/update provenance (follow-up).** Record the exact
   Twemoji source version and a reproducible asset-refresh process before any
   corpus update.

## Requirements

- R1. All project configurations must use `SWIFT_VERSION = 5.0`.
- R2. Swift sources must use current `Bundle.main`, `FileManager.default`,
  `addChild`, and `didMove(toParent:)` APIs without changing sticker behavior.
- R3. The iOS 10 deployment target, bundle identifiers, resource references,
  signing exclusions, and privacy guard must remain unchanged.
- R4. `make xcode-build` must compile the `Twemoji` target for the iPhone
  Simulator with code signing disabled when Xcode is available.
- R5. GitHub Actions must run the static baseline and the new Xcode build on the
  pinned `macos-15` runner.
- R6. The baseline and maintenance documentation must reject regression to
  Swift 3 or project-parse-only CI.

## Verification

- `make check`
- `make xcode-build` on hosted macOS/Xcode
- `git diff --check`
- Mutation check: restoring `SWIFT_VERSION = 3.0` must fail the static baseline.
- Hosted branch/PR verification must be green before merging to `master`.

