import Foundation

private func assertDescription(_ expected: String, file: String, caseName: String) {
    let actual = TwemojiDescription.localizedDescription(for: file)
    if actual != expected {
        fatalError("\(caseName): expected <\(expected)> but was <\(actual)>")
    }
}

assertDescription("\u{1F600}", file: "1f600.png", caseName: "single scalar")
assertDescription("\u{1F1FA}\u{1F1F8}", file: "1f1fa-1f1f8.png", caseName: "multi scalar")
assertDescription("\u{1F600}", file: "1f600.PNG", caseName: "uppercase extension")
assertDescription("\u{1F600}", file: "1f600", caseName: "missing extension")
assertDescription("not-hex", file: "not-hex.png", caseName: "invalid hexadecimal")
assertDescription("1f600-", file: "1f600-.png", caseName: "empty component")
assertDescription("d800", file: "d800.png", caseName: "surrogate scalar")
assertDescription("1f600.preview", file: "1f600.preview.png", caseName: "multi-dot fallback")
assertDescription("000a", file: "000a.png", caseName: "control scalar fallback")

private func assertEqual<T: Equatable>(_ expected: T, _ actual: T, caseName: String) {
    if actual != expected {
        fatalError("\(caseName): expected <\(expected)> but was <\(actual)>")
    }
}

private let fileManager = FileManager.default
private let fixtureURL = fileManager.temporaryDirectory
    .appendingPathComponent("twemoji-resource-policy-\(UUID().uuidString)", isDirectory: true)
try fileManager.createDirectory(at: fixtureURL, withIntermediateDirectories: true)
defer { try? fileManager.removeItem(at: fixtureURL) }

private func writeFixture(_ name: String, byteCount: Int = 1) throws -> URL {
    let url = fixtureURL.appendingPathComponent(name)
    try Data(repeating: 0x41, count: byteCount).write(to: url)
    return url
}

_ = try writeFixture("1f601.png")
_ = try writeFixture("1f600.PNG")
_ = try writeFixture("ignored.txt")
_ = try writeFixture("empty.png", byteCount: 0)
_ = try writeFixture("oversized.png", byteCount: StickerResourcePolicy.maximumStickerFileSize + 1)
try fileManager.createDirectory(at: fixtureURL.appendingPathComponent("directory.png"), withIntermediateDirectories: false)
let symlinkTarget = try writeFixture("1f602.png")
try fileManager.createSymbolicLink(
    at: fixtureURL.appendingPathComponent("linked.png"),
    withDestinationURL: symlinkTarget
)

let discovered = try StickerResourcePolicy.discoverStickerURLs(in: fixtureURL, fileManager: fileManager)
assertEqual(["1f600.PNG", "1f601.png", "1f602.png"], discovered.map(\.lastPathComponent), caseName: "bounded regular PNG discovery")
assertEqual(
    ["😀", "😁", "😂"],
    discovered.map { TwemojiDescription.localizedDescription(for: $0.lastPathComponent) },
    caseName: "deterministic accessible description order"
)

private let countFixtureURL = fileManager.temporaryDirectory
    .appendingPathComponent("twemoji-resource-count-\(UUID().uuidString)", isDirectory: true)
try fileManager.createDirectory(at: countFixtureURL, withIntermediateDirectories: true)
defer { try? fileManager.removeItem(at: countFixtureURL) }
for index in 0...StickerResourcePolicy.maximumStickerCount {
    let url = countFixtureURL.appendingPathComponent(String(format: "%04x.png", index))
    try Data([0x41]).write(to: url)
}
let bounded = try StickerResourcePolicy.discoverStickerURLs(in: countFixtureURL, fileManager: fileManager)
assertEqual(StickerResourcePolicy.maximumStickerCount, bounded.count, caseName: "sticker count bound")
