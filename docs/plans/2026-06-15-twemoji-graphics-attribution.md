---
title: Twemoji Graphics Attribution
type: compliance
status: in_progress
date: 2026-06-15
---

# Twemoji Graphics Attribution

## Problem Frame

The repository bundles 834 PNG files described as Twemoji graphics, but its
only license file is an unscoped CC0 text and project guidance contains no
upstream attribution. The authoritative Twemoji repository states that its
graphics are licensed under Creative Commons Attribution 4.0 and accepts a
README or application About/legal mention for attribution.

## Scope Boundaries

- Add an explicit third-party notice for the bundled Twemoji PNG graphics.
- Link the authoritative upstream project and CC BY 4.0 license, and retain the
  upstream copyright attribution.
- Clarify that the notice does not re-license repository code or resolve the
  provenance of any asset not sourced from Twemoji.
- Do not replace the root license, alter PNGs, change the Xcode project, or
  claim legal advice or a complete historical source-version reconstruction.
- Do not merge or close stacked pull requests without explicit authorization.

## Requirements

1. Add a repository-visible third-party notice naming Twemoji, the upstream
   repository, CC BY 4.0, and Twitter/contributors attribution.
2. Link the notice from README, contributor, security, vision, and change
   guidance without asserting that CC0 covers the graphics.
3. Require the notice and attribution fields in the portable baseline whenever
   bundled PNGs remain present.
4. Record the current 834-file inventory and require future asset refreshes to
   preserve attribution and source/version notes.
5. Add completed evidence and hostile mutations for missing notice, upstream,
   license, attribution, inventory, and documentation contracts.

## Verification Plan

- Run root and external-directory `make check`, `make lint`, `make test`, and
  `make build` on Linux.
- Parse the notice and assert the expected upstream/license URLs and inventory
  contract from the dependency-free baseline.
- Reject isolated hostile mutations across notice and documentation evidence.
- Audit exact intended paths, generated/signing artifacts, secrets, and PNG or
  Xcode-project drift.
- Retain Xcode/Messages runtime verification as not applicable to this
  documentation and static-contract change.
