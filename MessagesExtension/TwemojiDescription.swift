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
                  let scalar = UnicodeScalar(value) else {
                return assetName
            }
            description.unicodeScalars.append(scalar)
        }

        return description.isEmpty ? assetName : description
    }
}
