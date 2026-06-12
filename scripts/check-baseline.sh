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
PRIVACY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-privacy-source-guard.md"
ASSET_NAME_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-asset-name-normalization.md"
PNG_EXTENSION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-png-extension-filter.md"
RESOURCE_PATH_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-discovered-resource-paths.md"
SIGNING_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-signing-artifact-guard.md"
LOGGING_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-debug-logging-guard.md"
LOAD_RELOAD_PLAN="$ROOT_DIR/docs/plans/2026-06-09-emoji-imessage-load-reload-ownership.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-emoji-imessage-ci-baseline.md"
PNG_INTEGRITY_PLAN="$ROOT_DIR/docs/plans/2026-06-10-emoji-png-integrity.md"
SWIFT5_PLAN="$ROOT_DIR/docs/plans/2026-06-12-swift5-xcode-build-gate.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"

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
  ".github/workflows/check.yml" \
  "Twemoji.xcodeproj/project.pbxproj" \
  "Twemoji/Info.plist" \
  "Twemoji/Assets.xcassets/AppIcon.appiconset/Contents.json" \
  "MessagesExtension/Info.plist" \
  "MessagesExtension/Base.lproj/MainInterface.storyboard" \
  "MessagesExtension/MessagesViewController.swift" \
  "MessagesExtension/TwemojiBrowserViewController.swift" \
  "docs/plans/2026-06-09-emoji-imessage-privacy-source-guard.md" \
  "docs/plans/2026-06-09-emoji-imessage-asset-name-normalization.md" \
  "docs/plans/2026-06-09-emoji-imessage-png-extension-filter.md" \
  "docs/plans/2026-06-09-emoji-imessage-discovered-resource-paths.md" \
  "docs/plans/2026-06-09-emoji-imessage-signing-artifact-guard.md" \
  "docs/plans/2026-06-09-emoji-imessage-debug-logging-guard.md" \
  "docs/plans/2026-06-09-emoji-imessage-load-reload-ownership.md" \
  "docs/plans/2026-06-09-emoji-imessage-child-lifecycle.md" \
  "docs/plans/2026-06-10-emoji-imessage-ci-baseline.md" \
  "docs/plans/2026-06-10-emoji-png-integrity.md" \
  "docs/plans/2026-06-12-swift5-xcode-build-gate.md" \
  "docs/plans/2026-06-08-emoji-imessage-sticker-reload.md" \
  "docs/plans/2026-06-08-emoji-imessage-app-maintenance-baseline.md"; do
  require_file "$path"
done

if ! grep -Fq "make check" "$README" ||
  ! grep -Fq "Twemoji image set" "$README" ||
  ! grep -Fq "iMessage extension" "$README" ||
  ! grep -Fq ".mobileprovision" "$README" ||
  ! grep -Fq "debug logging" "$README" ||
  ! grep -Fq "case-insensitive PNG path" "$README" ||
  ! grep -Fq "no network or analytics behavior" "$README" ||
  ! grep -Fq "Swift 5" "$README" ||
  ! grep -Fq "simulator build" "$README"; then
  printf '%s\n' "README must document the extension scope, asset set, privacy posture, debug logging guard, signing artifact guard, and check command." >&2
  exit 1
fi

for workflow_contract in \
  "runs-on: macos-15" \
  "permissions:" \
  "contents: read" \
  "workflow_dispatch:" \
  "cancel-in-progress: true" \
  "timeout-minutes: 10" \
  "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" \
  "run: make check" \
  "run: make xcode-build"; do
  if ! grep -Fq "$workflow_contract" "$CI_WORKFLOW"; then
    printf '%s\n' "GitHub Actions Xcode baseline is missing: $workflow_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "Signing certificates" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "archives, and build outputs" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "path extension case-insensitively" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "debug logging" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document signing, debug logging, and local Xcode artifact exclusions." >&2
  exit 1
fi

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "xcode-build:" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "Twemoji.xcodeproj -target Twemoji -sdk iphonesimulator" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "CODE_SIGNING_ALLOWED=NO" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "ONLY_ACTIVE_ARCH=NO" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=YES" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build aliases for the baseline gate." >&2
  exit 1
fi

for ignore_entry in "*.xcarchive" "*.mobileprovision" "*.provisionprofile" "*.p12" "*.cer" "xcuserdata/" "DerivedData/"; do
  if ! grep -Fxq "$ignore_entry" "$ROOT_DIR/.gitignore"; then
    printf '%s\n' ".gitignore must exclude signing and Xcode local artifacts: $ignore_entry" >&2
    exit 1
  fi
done

tracked_signing_artifacts=$(git -C "$ROOT_DIR" ls-files | grep -Ei '(\.mobileprovision$|\.provisionprofile$|\.p12$|\.cer$|\.xcarchive(/|$)|xcuserdata/|DerivedData/)' || true)
if [ -n "$tracked_signing_artifacts" ]; then
  printf '%s\n%s\n' "Signing or local Xcode artifacts must not be tracked:" "$tracked_signing_artifacts" >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$VISION" ||
  ! grep -Fq "deterministic sticker loading" "$VISION" ||
  ! grep -Fq "case-insensitive PNG path extension" "$VISION" ||
  ! grep -Fq "debug logging" "$VISION"; then
  printf '%s\n' "VISION must include the baseline command, debug logging posture, and current sticker-loading posture." >&2
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
add_child = source.find("self.addChild(browserViewController)")
add_subview = source.find("self.view.addSubview(browserViewController.view)")
did_move = source.find("browserViewController.didMove(toParent: self)")
if -1 in (add_child, add_subview, did_move) or not (add_child < add_subview < did_move):
    print("Messages view must add the child controller, add its view, then call didMove.", file=sys.stderr)
    raise SystemExit(1)
PY

if ! grep -Fq "guard let docsPath = Bundle.main.resourcePath" "$BROWSER_VIEW" ||
  ! grep -Fq "let fileManager = FileManager.default" "$BROWSER_VIEW" ||
  ! grep -Fq "stickers.removeAll()" "$BROWSER_VIEW" ||
  ! grep -Fq "defer {" "$BROWSER_VIEW" ||
  ! grep -Fq "stickerBrowserView.reloadData()" "$BROWSER_VIEW" ||
  ! grep -Fq ".sorted()" "$BROWSER_VIEW" ||
  grep -Fq "resourcePath!" "$BROWSER_VIEW" ||
  grep -Fq 'localizedDescription: "asset"' "$BROWSER_VIEW"; then
  printf '%s\n' "Sticker loading must avoid force unwraps, clear previous data, reload the browser, sort resources, and use per-asset descriptions." >&2
  exit 1
fi

if grep -Fq "browserViewController.stickerBrowserView.reloadData()" "$MESSAGES_VIEW"; then
  printf '%s\n' "MessagesViewController must let loadStickers own sticker browser reloads." >&2
  exit 1
fi

if ! grep -Fq "(file as NSString).deletingPathExtension" "$BROWSER_VIEW" ||
  grep -Fq 'replacingOccurrences(of: ".png", with: "")' "$BROWSER_VIEW"; then
  printf '%s\n' "Sticker loading must derive asset names by stripping only the path extension." >&2
  exit 1
fi

if ! grep -Fq "private func isPNGResource" "$BROWSER_VIEW" ||
  ! grep -Fq 'pathExtension.lowercased() == "png"' "$BROWSER_VIEW" ||
  grep -Fq 'file.hasSuffix(".png")' "$BROWSER_VIEW"; then
  printf '%s\n' "Sticker loading must filter PNG resources by case-insensitive path extension." >&2
  exit 1
fi

if ! grep -Fq "createSticker(file: file, resourcePath: docsPath)" "$BROWSER_VIEW" ||
  ! grep -Fq "func createSticker(file: String, resourcePath: String)" "$BROWSER_VIEW" ||
  ! grep -Fq "appendingPathComponent(file)" "$BROWSER_VIEW" ||
  grep -Fq 'pathForResource(asset, ofType: "png")' "$BROWSER_VIEW"; then
  printf '%s\n' "Sticker creation must use exact discovered PNG file paths instead of reconstructing resource lookups." >&2
  exit 1
fi

python3 - "$BROWSER_VIEW" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
clear = source.find("stickers.removeAll()")
defer = source.find("defer {")
reload = source.find("stickerBrowserView.reloadData()")
guard = source.find("guard let docsPath = Bundle.main.resourcePath")
if -1 in (clear, defer, reload, guard) or not (clear < defer < reload < guard):
    print("Sticker loading must clear stale stickers and schedule reload before resource resolution.", file=sys.stderr)
    raise SystemExit(1)
PY

if [ "$(grep -Fc "SWIFT_VERSION = 5.0;" "$PROJECT")" -ne 4 ] ||
  grep -Fq "SWIFT_VERSION = 3.0;" "$PROJECT" ||
  [ "$(grep -Fc "IPHONEOS_DEPLOYMENT_TARGET = 12.0;" "$PROJECT")" -ne 2 ] ||
  grep -Fq "IPHONEOS_DEPLOYMENT_TARGET = 10.0;" "$PROJECT" ||
  ! grep -Fq "MessagesViewController.swift in Sources" "$PROJECT" ||
  ! grep -Fq "TwemojiBrowserViewController.swift in Sources" "$PROJECT"; then
  printf '%s\n' "Xcode project must preserve the Swift 5 / iOS 12 extension baseline." >&2
  exit 1
fi

python3 - "$ROOT_DIR" <<'PY'
import sys
from pathlib import Path

root = Path(sys.argv[1])
logging_tokens = {
    "print(": "debug print",
    "debugPrint(": "debug print",
    "NSLog": "NSLog call",
}

logging_violations = []
for path in sorted((root / "MessagesExtension").glob("*.swift")):
    source = path.read_text(encoding="utf-8")
    for token, reason in logging_tokens.items():
        if token in source:
            logging_violations.append(f"{path.relative_to(root)} contains {token} ({reason})")

if logging_violations:
    print("Messages extension Swift sources must not log bundle paths, asset names, or errors.", file=sys.stderr)
    for violation in logging_violations:
        print(f"- {violation}", file=sys.stderr)
    raise SystemExit(1)

forbidden_tokens = {
    "URLSession": "network session",
    "NSURLConnection": "network connection",
    "WKWebView": "embedded web view",
    "UIWebView": "embedded web view",
    "http://": "cleartext URL literal",
    "https://": "network URL literal",
    "CLLocation": "location API",
    "AVCapture": "camera or microphone capture API",
    "ASIdentifierManager": "advertising identifier API",
    "AdSupport": "advertising support framework",
    "Analytics": "analytics API or label",
    "Telemetry": "telemetry API or label",
}

violations = []
for path in sorted((root / "MessagesExtension").glob("*.swift")):
    source = path.read_text(encoding="utf-8")
    for token, reason in forbidden_tokens.items():
        if token in source:
            violations.append(f"{path.relative_to(root)} contains {token} ({reason})")

if violations:
    print("Messages extension Swift sources must stay free of network, analytics, and permission APIs.", file=sys.stderr)
    for violation in violations:
        print(f"- {violation}", file=sys.stderr)
    raise SystemExit(1)
PY

python3 - "$ROOT_DIR" <<'PY'
import json
import plistlib
import struct
import sys
import zlib
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
    data = path.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        bad.append(f"{path.name}: invalid signature")
        continue

    offset = 8
    chunks = []
    error = None
    while offset < len(data):
        if offset + 12 > len(data):
            error = "truncated chunk header"
            break
        length = struct.unpack(">I", data[offset:offset + 4])[0]
        chunk_type = data[offset + 4:offset + 8]
        chunk_end = offset + 12 + length
        if chunk_end > len(data):
            error = "truncated chunk data"
            break
        if not all(65 <= byte <= 90 or 97 <= byte <= 122 for byte in chunk_type):
            error = "invalid chunk type"
            break

        payload = data[offset + 8:offset + 8 + length]
        expected_crc = struct.unpack(">I", data[offset + 8 + length:chunk_end])[0]
        actual_crc = zlib.crc32(chunk_type + payload) & 0xFFFFFFFF
        if actual_crc != expected_crc:
            error = f"invalid {chunk_type.decode('ascii')} CRC"
            break

        chunks.append(chunk_type)
        if len(chunks) == 1:
            if chunk_type != b"IHDR" or length != 13:
                error = "missing initial IHDR"
                break
            width, height = struct.unpack(">II", payload[:8])
            if width == 0 or height == 0:
                error = "invalid zero dimensions"
                break

        offset = chunk_end
        if chunk_type == b"IEND":
            if length != 0 or offset != len(data):
                error = "invalid terminal IEND"
            break

    if error is None and b"IDAT" not in chunks:
        error = "missing IDAT"
    if error is None and (not chunks or chunks[-1] != b"IEND"):
        error = "missing terminal IEND"
    if error is not None:
        bad.append(f"{path.name}: {error}")
if bad:
    fail("Invalid bundled PNG data: " + ", ".join(bad[:10]))

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

if ! grep -Fq "status: completed" "$PRIVACY_PLAN"; then
  printf '%s\n' "Privacy source guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ASSET_NAME_PLAN"; then
  printf '%s\n' "Asset-name normalization plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PNG_EXTENSION_PLAN"; then
  printf '%s\n' "PNG extension filter plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$SIGNING_PLAN"; then
  printf '%s\n' "Signing artifact guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOGGING_PLAN"; then
  printf '%s\n' "Debug logging guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$LOGGING_PLAN"; then
  printf '%s\n' "Debug logging guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$LOAD_RELOAD_PLAN"; then
  printf '%s\n' "Load reload ownership plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$LOAD_RELOAD_PLAN"; then
  printf '%s\n' "Load reload ownership plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$CI_PLAN" ||
  ! grep -Fq "xcodebuild -list" "$CI_PLAN" ||
  ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must remain completed with hosted Xcode verification recorded." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$PNG_INTEGRITY_PLAN" ||
  ! grep -Fq "make check" "$PNG_INTEGRITY_PLAN" ||
  ! grep -Fq "CRC" "$PNG_INTEGRITY_PLAN"; then
  printf '%s\n' "PNG integrity plan must remain completed with CRC verification recorded." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$SWIFT5_PLAN" ||
  ! grep -Fq "Xcode 16.4" "$SWIFT5_PLAN" ||
  ! grep -Fq "BUILD SUCCEEDED" "$SWIFT5_PLAN"; then
  printf '%s\n' "Swift 5 build plan must remain completed with hosted Xcode verification recorded." >&2
  exit 1
fi

for png_integrity_contract in \
  "zlib.crc32" \
  "truncated chunk header" \
  "invalid chunk type" \
  "missing initial IHDR" \
  "missing IDAT" \
  "invalid terminal IEND"; do
  if ! grep -Fq "$png_integrity_contract" "$ROOT_DIR/scripts/check-baseline.sh"; then
    printf '%s\n' "PNG integrity contract is missing: $png_integrity_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "make check" "$SIGNING_PLAN"; then
  printf '%s\n' "Signing artifact guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$PNG_EXTENSION_PLAN"; then
  printf '%s\n' "PNG extension filter plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$RESOURCE_PATH_PLAN"; then
  printf '%s\n' "Discovered resource path plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$RESOURCE_PATH_PLAN"; then
  printf '%s\n' "Discovered resource path plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "exact discovered PNG file paths" "$README" ||
  ! grep -Fq "exact discovered bundle file paths" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact discovered PNG file paths" "$VISION"; then
  printf '%s\n' "Docs must describe exact discovered PNG resource path loading." >&2
  exit 1
fi

if ! grep -Fq "reloads the sticker browser after every load attempt" "$README" ||
  ! grep -Fq "reloads the sticker browser after every load attempt" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "reloads the sticker browser after every load attempt" "$VISION"; then
  printf '%s\n' "Docs must describe sticker browser reload ownership." >&2
  exit 1
fi

printf '%s\n' "emoji-imessage-app maintenance baseline checks passed."
