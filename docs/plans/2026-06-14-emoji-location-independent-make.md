# Make Verification Location Independent

status: completed

## Context

The documented Make targets invoke the baseline script and Xcode project with
paths relative to the caller's current directory. `make check` passes from the
repository root but fails when the same Makefile is invoked from an external
working directory, making automation dependent on ambient shell location.

## Requirements

- R1. Derive the repository root from the loaded Makefile path.
- R2. Prevent an environment variable from overriding the trusted root.
- R3. Resolve the baseline script and both Xcode project arguments from that
  root.
- R4. Preserve target names, simulator build flags, Swift/iOS settings, and
  hosted macOS coverage.
- R5. Add mutation-sensitive static contracts and completed plan evidence.

## Scope Boundaries

- Do not modify Swift, storyboard, project, workflow, asset, signing, or
  dependency behavior.
- Do not claim a local Xcode build on Linux where `xcodebuild` is not installed.
- Do not merge or close any stacked pull request without owner authorization.

## Implementation

- Define an override-protected absolute `ROOT` from `MAKEFILE_LIST`.
- Use `ROOT` for the portable checker and `Twemoji.xcodeproj` paths.
- Extend the baseline, contributor guidance, and change record for the
  location-independent contract.

## Verification

- Run `make check` from the repository root and an external working directory.
- Exercise `xcode-list` and `xcode-build` command construction with a bounded
  fake `XCODEBUILD` executable because xcodebuild is not installed locally.
- Run isolated hostile mutations for root derivation, script/project path use,
  documentation, and completed plan evidence.
- Audit the exact diff, generated artifacts, workflow/project preservation,
  and credential-like additions before committing.

## Work Completed

- Added an override-protected absolute repository root derived from the loaded
  Makefile path.
- Resolved the portable baseline script and both Xcode project arguments from
  that root while preserving all existing target names and build flags.
- Added static contracts and synchronized contributor/change documentation for
  location-independent invocation.

## Verification Completed

- `make check` passed from the repository root and an external working
  directory with a poisoned `ROOT` environment value.
- A bounded fake Xcode driver captured absolute `Twemoji.xcodeproj` paths for
  both `xcode-list` and `xcode-build`, including every existing simulator and
  unsigned-build flag; xcodebuild is not installed on this Linux host, so no
  local Xcode build is claimed.
- Six isolated hostile mutations were rejected across root protection, script
  and project path resolution, documentation, and completed plan evidence.
- Exact-path diff, workflow/project preservation, generated-artifact,
  whitespace, shell, and credential-like addition audits passed.
