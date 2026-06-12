# Emoji iMessage Swift 5 Build Gate

## Status: Completed

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
- R3. The deployment target must move only as far as required by hosted Xcode;
  bundle identifiers, resource references, signing exclusions, and the privacy
  guard must remain unchanged.
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

## Hosted Finding

The first Xcode 16.4 build succeeded but reported that iOS 10 is outside its
supported simulator deployment range of iOS 12 through 18.5. The implementation
therefore raises the project minimum to iOS 12 instead of preserving an
unsupported warning-producing target.

The final Xcode 16.4 build also sets `ONLY_ACTIVE_ARCH=NO` and
`DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=YES`, removing command-line target
selection warnings. Existing asset-catalog assignment, PNG bit-depth, and
App Intents metadata warnings remain separate asset-maintenance work; they do
not prevent the application and Messages extension from compiling.

## Work Completed

- Migrated all project configurations from Swift 3 to Swift 5.
- Replaced renamed Foundation and UIKit APIs while preserving the existing
  sticker-browser lifecycle and resource lookup behavior.
- Raised the deployment target to the minimum supported by the hosted Xcode
  16.4 simulator SDK: iOS 12.
- Added an unsigned `Twemoji` simulator build to the pinned macOS CI job and
  made command-line architecture and target-order behavior explicit.
- Extended the static baseline and maintenance documentation to reject a
  return to Swift 3 or parse-only CI.

## Verification Completed

- `make check` passes locally; Xcode parsing is skipped locally because this
  Linux host does not provide `xcodebuild`.
- `git diff --check` passes.
- Restoring `SWIFT_VERSION = 3.0` makes `make check` fail as required.
- GitHub Actions push run `27391356123` passed.
- GitHub Actions pull-request run `27391356991` passed under Xcode 16.4 and
  ended with `BUILD SUCCEEDED` for the iPhone Simulator target.
