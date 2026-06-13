## Emoji iMessage App Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Emoji iMessage App is a Swift iMessage extension that presents emoji assets for
use inside Messages.

The repository is useful as a compact iMessage app sample with bundled emoji
images, a screenshot, and Xcode project setup. Basic instructions live in
[`README.md`](README.md).

The goal is to keep the extension easy to open, run, and update while
preserving asset licensing and iMessage-specific behavior.

The current focus is:

Priority:

- Preserve the Twemoji-based asset set and Messages extension structure
- Keep the Xcode project runnable on simulator or device
- Avoid adding generated signing material or private assets
- Keep screenshot and README instructions aligned with the app

Current baseline:

- `scripts/check-baseline.sh` validates project metadata, extension plists,
  Swift source invariants, and Twemoji PNG signatures.
- The project uses Swift 5 and current UIKit/Foundation child-controller and
  bundle APIs with an Xcode 16-supported iOS 12 deployment target.
- Sticker discovery uses deterministic sticker loading by sorted bundle
  filename and clears stale state before reloading.
- Sticker discovery filters resources by case-insensitive PNG path extension.
- Sticker creation uses exact discovered PNG file paths so resource loading
  stays aligned with discovery.
- Sticker asset names are derived by stripping only the PNG path extension.
- Sticker accessibility descriptions decode valid hyphen-separated Unicode
  scalar stems into the emoji sequence with an asset-name fallback.
- Sticker loading reloads the sticker browser after every load attempt, including
  fail-closed resource lookup paths.
- The sticker browser is sized to the Messages extension container bounds and
  resizes with the host view.
- The sticker browser child controller is retained explicitly and follows the
  add-child, add-view, did-move lifecycle order.
- The extension storyboard has no template label or placeholder subview behind
  the programmatic sticker browser.
- The checked-in Swift source has no network or analytics behavior.
- Sticker loading avoids debug logging of bundle paths, asset names, and local
  errors.
- The baseline scans Swift sources for network, analytics, ad identifier,
  camera, microphone, location, webview APIs, and debug logging.
- Signing/provisioning files, Xcode user data, archives, and build outputs stay
  ignored and untracked.
- GitHub Actions runs `make check` and an unsigned simulator build on a fixed
  macOS runner so the Swift 5 host app and extension compile before review.
- The maintenance gate parses every bundled sticker PNG and verifies complete
  chunk structure and CRC integrity before review.
- Manual Messages verification is documented separately from static/build
  evidence and covers sticker selection, preview, send, transcript appearance,
  VoiceOver descriptions, stale content, logging, permissions, and networking.

Next priorities:

- Clarify emoji asset licensing and update process

Contribution rules:

- One PR = one focused asset, extension, build, or documentation change.
- Preserve license and attribution files.
- Run `scripts/check-baseline.sh` before pushing changes.
- Keep `.github/workflows/check.yml` aligned with the local maintenance gate.
- Verify the extension in Messages when changing UI or assets on a machine with
  Xcode.
- Keep generated build products and signing files out of git.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

iMessage extensions should not collect message content or user conversations.
Future features should avoid analytics or network behavior unless explicitly
documented and user-controlled.

## What We Will Not Merge (For Now)

- Private or unlicensed emoji/image assets
- Message-content collection or analytics
- Signing files, provisioning profiles, or build products
- Large asset updates without attribution and verification notes

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
