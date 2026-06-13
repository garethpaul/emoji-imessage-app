---
title: Emoji Extension Storyboard Placeholder Removal
type: accessibility
date: 2026-06-13
status: planned
execution: code
---

# Emoji Extension Storyboard Placeholder Removal

## Summary

Remove the Xcode template's `Hello World` label from the Messages extension
storyboard so the programmatic sticker browser is the sole visible and
accessibility-exposed content surface.

## Requirements

- R1. Remove the placeholder label and its center constraints from the root
  extension scene.
- R2. Preserve the storyboard scene, controller class, module, root view,
  layout guides, autoresizing behavior, and extension entry point.
- R3. Add a section-scoped XML contract that rejects labels, placeholder text,
  or stale constraint references in the extension storyboard.
- R4. Preserve all Swift source, sticker assets, Xcode target settings, and
  programmatic child-controller loading behavior.
- R5. Record static Linux verification separately from the hosted macOS build
  and unperformed Messages/VoiceOver runtime verification.

## Verification Plan

- Parse the storyboard as XML and assert its root view has no subviews or
  constraints referencing the removed template object.
- Run `make check`, `make lint`, `make test`, and `make build` on Linux.
- Reject hostile mutations that restore the label, placeholder text,
  constraints, or weaken completed plan evidence.
- Require the stacked pull request's bounded hosted macOS check to compile the
  host app and Messages extension.

## Non-Goals

- Changing sticker discovery, descriptions, layout, sizing, or send behavior.
- Editing PNG assets, screenshots, signing configuration, or deployment target.
- Claiming simulator/device Messages or VoiceOver verification from Linux.
