import Foundation

enum StickerResourcePolicyError: Error {
    case tooManyStickers
}

enum StickerResourcePolicy {
    static let maximumStickerCount = 1024
    static let maximumStickerFileSize = 500 * 1024

    static func discoverStickerURLs(
        in resourceURL: URL,
        fileManager: FileManager = .default
    ) throws -> [URL] {
        let keys: [URLResourceKey] = [
            .isRegularFileKey,
            .fileSizeKey
        ]
        let standardizedResourceURL = resourceURL.standardizedFileURL
        let contents = try fileManager.contentsOfDirectory(
            at: standardizedResourceURL,
            includingPropertiesForKeys: keys,
            options: [.skipsHiddenFiles]
        )

        let stickerURLs = try contents
            .filter { url in
                guard url.pathExtension.lowercased() == "png",
                      url.deletingLastPathComponent().standardizedFileURL == standardizedResourceURL else {
                    return false
                }

                let values = try url.resourceValues(forKeys: Set(keys))
                guard values.isRegularFile == true,
                      let fileSize = values.fileSize else {
                    return false
                }
                return fileSize > 0 && fileSize <= maximumStickerFileSize
            }
            .sorted { $0.lastPathComponent < $1.lastPathComponent }

        guard stickerURLs.count <= maximumStickerCount else {
            throw StickerResourcePolicyError.tooManyStickers
        }
        return stickerURLs
    }
}
