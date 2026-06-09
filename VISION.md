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
- Sticker discovery uses deterministic sticker loading by sorted bundle
  filename and clears stale state before reloading.
- Sticker asset names are derived by stripping only the PNG path extension.
- The sticker browser is sized to the Messages extension container bounds and
  resizes with the host view.
- The sticker browser child controller is retained explicitly and follows the
  add-child, add-view, did-move lifecycle order.
- The checked-in Swift source has no network or analytics behavior.
- Sticker loading avoids debug logging of bundle paths, asset names, and local
  errors.
- The baseline scans Swift sources for network, analytics, ad identifier,
  camera, microphone, location, webview APIs, and debug logging.
- Signing/provisioning files, Xcode user data, archives, and build outputs stay
  ignored and untracked.

Next priorities:

- Document Xcode and iOS version expectations
- Clarify emoji asset licensing and update process
- Add manual verification notes for selecting and sending an emoji
- Modernize Swift and project settings in a dedicated pass if needed

Contribution rules:

- One PR = one focused asset, extension, build, or documentation change.
- Preserve license and attribution files.
- Run `scripts/check-baseline.sh` before pushing changes.
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
