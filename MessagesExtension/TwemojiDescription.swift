//
//  TwemojiDescription.swift
//  Twemoji
//

import Foundation

enum TwemojiDescription {
    static func localizedDescription(for file: String) -> String {
        let assetName = (file as NSString).deletingPathExtension
        let components = assetName.split(separator: "-", omittingEmptySubsequences: false)
        var description = ""

        for component in components {
            guard !component.isEmpty,
                  let value = UInt32(String(component), radix: 16),
                  let scalar = UnicodeScalar(value),
                  !isControlScalar(value) else {
                return assetName
            }
            description.unicodeScalars.append(scalar)
        }

        return description.isEmpty ? assetName : description
    }

    private static func isControlScalar(_ value: UInt32) -> Bool {
        return value < 0x20 || (0x7F...0x9F).contains(value)
    }
}
