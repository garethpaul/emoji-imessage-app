# Oversized Sticker Set Design

Status: Completed

## Evidence

- `StickerResourcePolicy.discoverStickerURLs` sorts valid PNG candidates and
  then applies `prefix(maximumStickerCount)`, silently loading a partial set.
- The existing executable test creates 1,025 candidates and currently expects
  1,024 results, proving truncation is intentional in the implementation.
- `VISION.md` states that discovery rejects more than 1,024 candidates, while
  `README.md` and `SECURITY.md` describe only a cap. The implementation and
  maintained documentation therefore disagree about whether an oversized
  bundle is accepted partially or rejected.
- `TwemojiBrowserViewController.loadStickers` clears existing stickers before
  discovery, catches discovery errors, and reloads in `defer`, so a thrown
  policy error already produces a fail-closed empty browser without stale UI.

## Considered Approaches

### Document silent truncation

This matches current behavior but hides packaging mistakes and weakens the
existing fail-closed policy for invalid or oversized resources.

### Reject the complete oversized candidate set

Filter and sort valid direct PNG resources, then throw a dedicated policy
error when their count exceeds 1,024. This matches the vision, uses the
controller's existing error path, and prevents a partially presented bundle.

### Load 1,024 and expose a warning

This preserves partial availability but requires new UI or logging. Logging is
deliberately prohibited, and adding user-facing warning state is unnecessary
for a malformed application bundle.

## Decision

Reject the complete oversized candidate set with a dedicated
`StickerResourcePolicyError.tooManyStickers` error. Keep exactly 1,024 valid
stickers accepted, preserve deterministic sorting, and leave invalid individual
files filtered as before.

## Validation

- Change the executable Swift test to require an error for 1,025 candidates
  and watch it fail against the current truncating implementation.
- Add an exact-limit fixture proving 1,024 candidates remain accepted.
- Run the test under an official Swift container when host `swiftc` is absent.
- Run repository and external-directory `make check`, isolated hostile
  mutations, hosted Xcode build, and CodeQL before merge.

The implemented design preserves exact-limit acceptance and rejects the entire
oversized candidate set through the controller's existing fail-closed path.
