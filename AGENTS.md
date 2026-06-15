# AGENTS.md

## Repository purpose

`garethpaul/emoji-imessage-app` is a Swift 5 iMessage extension that presents a bundled Twemoji image set as Messages stickers. It targets iOS 12 and has no network or analytics behavior in the checked-in source.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Twemoji.xcodeproj` - Xcode project
- `MessagesExtension` - repository source or sample assets
- `screenshots` - repository source or sample assets
- `Twemoji` - repository source or sample assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Make targets resolve repository paths from the Makefile location and must
  remain callable from an external working directory.
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- Local Apple development: `open Twemoji.xcodeproj`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Preserve the Swift 5, iOS 12, unsigned simulator-build, and signing assumptions unless a change explicitly updates the supported Apple toolchain.

## Testing guidance

- No XCTest target is present; `make check` is the maintained static regression gate and also parses the Xcode project when `xcodebuild` is available.
- `make check` and `make xcode-build` do not prove Messages-host interaction; record the exact Xcode/iOS runtime and separately exercise sticker selection, preview, send, transcript, and VoiceOver behavior.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- Bundled Twemoji graphics are attributed in THIRD_PARTY_NOTICES.md under CC BY 4.0.
- Preserve the notice and document the exact upstream tag or commit before any
  asset refresh; the current historical import does not record one.
- No required secret or credential file is used by this extension.
- Do not commit signing certificates, provisioning profiles, Xcode user data, build products, or private assets.
- `.gitignore` and `scripts/check-baseline.sh` guard common signing artifacts such as `.mobileprovision`, `.provisionprofile`, `.p12`, `.cer`, and `.xcarchive` files.
- Keep the extension free of message-content collection, analytics, and network behavior unless a future change documents the user value and privacy model.
- Keep sticker loading free of debug logging that reveals bundle paths, asset names, or local errors.
- Preserve case-insensitive PNG discovery, exact discovered resource paths, extension-only asset-name normalization, and browser reload ownership after every load attempt.
- Keep every bundled sticker structurally valid. The baseline parses PNG chunks, verifies CRCs and boundaries, requires `IHDR`, image data, and terminal `IEND`, and rejects trailing bytes.
- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Manual verification must not be reported complete from static checks or an unsigned build alone.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
