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
