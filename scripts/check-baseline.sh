#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
README="$ROOT_DIR/README.md"
VISION="$ROOT_DIR/VISION.md"
PROJECT="$ROOT_DIR/Twemoji.xcodeproj/project.pbxproj"
MESSAGES_VIEW="$ROOT_DIR/MessagesExtension/MessagesViewController.swift"
BROWSER_VIEW="$ROOT_DIR/MessagesExtension/TwemojiBrowserViewController.swift"
PLAN="$ROOT_DIR/docs/plans/2026-06-08-emoji-imessage-app-maintenance-baseline.md"
RELOAD_PLAN="$ROOT_DIR/docs/plans/2026-06-08-emoji-imessage-sticker-reload.md"
LIFECYCLE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-child-lifecycle.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "Twemoji.xcodeproj/project.pbxproj" \
  "Twemoji/Info.plist" \
  "Twemoji/Assets.xcassets/AppIcon.appiconset/Contents.json" \
  "MessagesExtension/Info.plist" \
  "MessagesExtension/Base.lproj/MainInterface.storyboard" \
  "MessagesExtension/MessagesViewController.swift" \
  "MessagesExtension/TwemojiBrowserViewController.swift" \
  "docs/plans/2026-06-09-emoji-imessage-child-lifecycle.md" \
  "docs/plans/2026-06-08-emoji-imessage-sticker-reload.md" \
  "docs/plans/2026-06-08-emoji-imessage-app-maintenance-baseline.md"; do
  require_file "$path"
done

if ! grep -Fq "make check" "$README" ||
  ! grep -Fq "Twemoji image set" "$README" ||
  ! grep -Fq "iMessage extension" "$README" ||
  ! grep -Fq "no network or analytics behavior" "$README"; then
  printf '%s\n' "README must document the extension scope, asset set, privacy posture, and check command." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$VISION" ||
  ! grep -Fq "deterministic sticker loading" "$VISION"; then
  printf '%s\n' "VISION must include the baseline command and current sticker-loading posture." >&2
  exit 1
fi

if ! grep -Fq "browserViewController.view.frame = self.view.bounds" "$MESSAGES_VIEW" ||
  ! grep -Fq "autoresizingMask = [.flexibleWidth, .flexibleHeight]" "$MESSAGES_VIEW" ||
  ! grep -Fq "private var browserViewController: TwemojiBrowserViewController?" "$MESSAGES_VIEW" ||
  grep -Fq "TwemojiBrowserViewController!" "$MESSAGES_VIEW"; then
  printf '%s\n' "Messages view must size the sticker browser to the container bounds with autoresizing." >&2
  exit 1
fi

python3 - "$MESSAGES_VIEW" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
add_child = source.find("self.addChildViewController(browserViewController)")
add_subview = source.find("self.view.addSubview(browserViewController.view)")
did_move = source.find("browserViewController.didMove(toParentViewController: self)")
if -1 in (add_child, add_subview, did_move) or not (add_child < add_subview < did_move):
    print("Messages view must add the child controller, add its view, then call didMove.", file=sys.stderr)
    raise SystemExit(1)
PY

if ! grep -Fq "guard let docsPath = Bundle.main().resourcePath" "$BROWSER_VIEW" ||
  ! grep -Fq "stickers.removeAll()" "$BROWSER_VIEW" ||
  ! grep -Fq ".sorted()" "$BROWSER_VIEW" ||
  grep -Fq "resourcePath!" "$BROWSER_VIEW" ||
  grep -Fq 'localizedDescription: "asset"' "$BROWSER_VIEW"; then
  printf '%s\n' "Sticker loading must avoid force unwraps, clear previous data, sort resources, and use per-asset descriptions." >&2
  exit 1
fi

python3 - "$BROWSER_VIEW" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
clear = source.find("stickers.removeAll()")
guard = source.find("guard let docsPath = Bundle.main().resourcePath")
if clear == -1 or guard == -1 or clear > guard:
    print("Sticker loading must clear stale stickers before resource resolution.", file=sys.stderr)
    raise SystemExit(1)
PY

if ! grep -Fq "SWIFT_VERSION = 3.0;" "$PROJECT" ||
  ! grep -Fq "IPHONEOS_DEPLOYMENT_TARGET = 10.0;" "$PROJECT" ||
  ! grep -Fq "MessagesViewController.swift in Sources" "$PROJECT" ||
  ! grep -Fq "TwemojiBrowserViewController.swift in Sources" "$PROJECT"; then
  printf '%s\n' "Xcode project must preserve the Swift 3 / iOS 10 extension baseline." >&2
  exit 1
fi

python3 - "$ROOT_DIR" <<'PY'
import json
import plistlib
import sys
from pathlib import Path

root = Path(sys.argv[1])

def fail(message):
    print(message, file=sys.stderr)
    raise SystemExit(1)

with (root / "MessagesExtension/Info.plist").open("rb") as fh:
    extension_plist = plistlib.load(fh)
extension = extension_plist.get("NSExtension", {})
if extension.get("NSExtensionPointIdentifier") != "com.apple.message-payload-provider":
    fail("Messages extension point identifier must remain the iMessage payload provider.")
if extension.get("NSExtensionMainStoryboard") != "MainInterface":
    fail("Messages extension must keep MainInterface as the extension storyboard.")

with (root / "Twemoji/Info.plist").open("rb") as fh:
    host_plist = plistlib.load(fh)
if host_plist.get("CFBundlePackageType") != "APPL":
    fail("Host app plist must keep APPL package type.")

with (root / "Twemoji/Assets.xcassets/AppIcon.appiconset/Contents.json").open("r", encoding="utf-8") as fh:
    icons = json.load(fh)
if icons.get("info", {}).get("author") != "xcode":
    fail("App icon catalog metadata must remain Xcode-authored.")

pngs = sorted((root / "MessagesExtension").glob("*.png"))
if len(pngs) < 800:
    fail(f"Expected the bundled Twemoji image set, found only {len(pngs)} png files.")

bad = []
for path in pngs:
    with path.open("rb") as fh:
        if fh.read(8) != b"\x89PNG\r\n\x1a\n":
            bad.append(path.name)
if bad:
    fail("Non-PNG or corrupt PNG signature detected: " + ", ".join(bad[:10]))

project = (root / "Twemoji.xcodeproj/project.pbxproj").read_text(encoding="utf-8")
resource_refs = project.count(".png in Resources")
if resource_refs < len(pngs):
    fail(f"Xcode resource phase references {resource_refs} png resources for {len(pngs)} bundled images.")
PY

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/Twemoji.xcodeproj" >/dev/null
else
  printf '%s\n' "Skipping xcodebuild project parse: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$RELOAD_PLAN"; then
  printf '%s\n' "Sticker reload plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LIFECYCLE_PLAN"; then
  printf '%s\n' "Child-controller lifecycle plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "emoji-imessage-app maintenance baseline checks passed."
