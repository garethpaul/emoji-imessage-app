# Changes

## 2026-06-09

- Added a Swift source privacy guard for network, analytics, ad identifier,
  camera, microphone, location, and webview APIs.
- Made the sticker browser child controller optional instead of implicitly
  unwrapped.
- Added the child browser view before calling `didMove`, matching UIKit child
  controller lifecycle order.
- Added a static baseline guard for the child-controller setup.
- Normalized sticker asset names by stripping only the PNG path extension.

## 2026-06-08

- Added a repeatable `make check` baseline for the Swift iMessage extension.
- Cleared stale sticker state before resolving bundle resources so failed
  reloads cannot leave an old sticker set visible.
- Made sticker loading deterministic, defensive, and stable across repeated
  loads.
- Sized the sticker browser to the extension container bounds with autoresizing.
- Documented the Twemoji asset set, privacy posture, and Xcode verification
  expectations.
