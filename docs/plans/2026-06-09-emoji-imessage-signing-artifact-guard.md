---
title: Emoji iMessage Signing Artifact Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The Messages extension does not need checked-in signing certificates,
provisioning profiles, Xcode user state, archives, or build products. Those
files are local machine artifacts and can leak account details or pollute the
portable sample baseline if they are committed.

## Goals

- Keep common signing and provisioning file extensions ignored.
- Keep Xcode user data, archives, and derived build output ignored.
- Fail the baseline if those artifacts become tracked.
- Document the guard for future local Xcode verification.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
