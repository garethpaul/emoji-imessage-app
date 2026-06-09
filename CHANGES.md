# Changes

## 2026-06-08

- Added a repeatable `make check` baseline for the Swift iMessage extension.
- Cleared stale sticker state before resolving bundle resources so failed
  reloads cannot leave an old sticker set visible.
- Made sticker loading deterministic, defensive, and stable across repeated
  loads.
- Sized the sticker browser to the extension container bounds with autoresizing.
- Documented the Twemoji asset set, privacy posture, and Xcode verification
  expectations.
