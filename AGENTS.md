# AGENTS.md

## Repository purpose

`garethpaul/emoji-imessage-app` is a Swift iMessage extension that presents a bundled Twemoji image set as Messages stickers. It is a legacy Swift 3 / iOS 10 Xcode project and has no network or analytics behavior in the checked-in source.

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
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- Local Apple development: `open Twemoji.xcodeproj`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- No dedicated test files were detected; treat `make check` as the minimum baseline.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- No required secret or credential file is used by this extension.
- Do not commit signing certificates, provisioning profiles, Xcode user data, build products, or private assets.
- `.gitignore` and `scripts/check-baseline.sh` guard common signing artifacts such as `.mobileprovision`, `.provisionprofile`, `.p12`, `.cer`, and `.xcarchive` files.
- Keep the extension free of message-content collection, analytics, and network behavior unless a future change documents the user value and privacy model.
- Keep sticker loading free of debug logging that reveals bundle paths, asset names, or local errors.
- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
