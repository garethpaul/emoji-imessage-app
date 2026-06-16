---
title: Twemoji Description Swift Test
type: testing
date: 2026-06-16
status: completed
execution: code
---

# Twemoji Description Swift Test

## Context

The Messages extension decodes hexadecimal Twemoji filenames into Unicode
localized descriptions, but the behavior is embedded in a UIKit/Messages view
controller and is protected only by static source and corpus contracts.

## Priority

Execute the accessibility-description behavior on a standard Swift toolchain
without requiring an iMessage host, simulator, signing identity, or network.

## Requirements

- Extract filename-to-description decoding into a framework-independent Swift
  source used directly by `TwemojiBrowserViewController`.
- Preserve final-extension removal, all-components-valid hexadecimal decoding,
  multi-scalar ordering, and exact asset-stem fallback behavior.
- Add executable cases for a single scalar, a multi-scalar sequence,
  case-insensitive extension handling, missing extension, invalid hexadecimal,
  empty components, surrogate values, and multi-dot fallback.
- Compile production and test sources into a temporary directory and remove it
  on success, failure, or signal.
- Make canonical `make check` execute the Swift behavior test when `swiftc` is
  available while retaining a truthful local skip on hosts without Swift.
- Keep the unsigned iOS Simulator framework build and every PNG, privacy,
  attribution, signing-artifact, and Messages lifecycle contract unchanged.

## Verification

- Repository and external-directory `make check` on Linux with the explicit
  Swift-unavailable boundary.
- Fake-compiler runner tests for successful invocation and temporary cleanup.
- Mutation-sensitive contracts for controller wiring, decoder behavior, test
  cases, temporary cleanup, Make integration, workflow execution, docs, and
  completed plan evidence.
- Exact-head canonical macOS checks proving both Swift test execution and the
  existing unsigned iOS Simulator build.

## Scope Boundary

This change does not alter sticker discovery, ordering, file URLs, browser
reload ownership, extension lifecycle, bundled graphics, attribution, privacy,
network behavior, or Messages-host interaction.

## Verification Results

Completed on 2026-06-16:

- `sh -n scripts/check-baseline.sh scripts/test-twemoji-description.sh` passed.
- The fake-compiler success path executed the generated test binary and removed
  its temporary directory; compiler failure returned status 7 and signal
  handling returned status 143, with temporary output removed in both cases.
- Repository and external working directory `make check` passed on Linux.
- 13 hostile mutations were rejected across controller wiring, decoder
  semantics, executable cases, cleanup traps, Make integration, Xcode source
  membership, plan evidence, and maintained documentation.
- Local `swiftc is unavailable`, so the Make gate reported its explicit skip.
  Exact-head executable Swift and unsigned simulator-build evidence remains a
  required hosted macOS pre-merge gate and will be appended after push.
