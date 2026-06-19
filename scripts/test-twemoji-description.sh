#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}

if ! command -v "$SWIFTC" >/dev/null 2>&1; then
  printf '%s\n' "Swift compiler not found: $SWIFTC" >&2
  exit 1
fi

BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/twemoji-description-tests.XXXXXX")
cleanup() {
  rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

"$SWIFTC" \
  "$ROOT_DIR/MessagesExtension/TwemojiDescription.swift" \
  "$ROOT_DIR/MessagesExtension/StickerResourcePolicy.swift" \
  "$ROOT_DIR/Tests/TwemojiDescriptionTests/main.swift" \
  -o "$BUILD_DIR/twemoji-description-tests"
"$BUILD_DIR/twemoji-description-tests"

printf '%s\n' "Twemoji description Swift tests passed."
