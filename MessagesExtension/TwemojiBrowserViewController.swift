//
//  TwemojiBrowserViewController.swift
//  Twemoji
//
//  Created by Gareth on 6/15/16.
//  Copyright © 2016 RequestLabs. All rights reserved.
//

import Foundation
import UIKit
import Messages

class TwemojiBrowserViewController: MSStickerBrowserViewController {
    private var stickers = [MSSticker]()
    
    func loadStickers() {
        stickers.removeAll()
        defer {
            stickerBrowserView.reloadData()
        }

        guard let resourceURL = Bundle.main.resourceURL else {
            return
        }

        do {
            for stickerURL in try StickerResourcePolicy.discoverStickerURLs(in: resourceURL) {
                createSticker(at: stickerURL)
            }
        } catch {
            return
        }
    }

    private func createSticker(at stickerURL: URL) {
        let stickerDescription = TwemojiDescription.localizedDescription(for: stickerURL.lastPathComponent)
        let sticker: MSSticker
        do {
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: stickerDescription)
            stickers.append(sticker)
        } catch {
            return
        }
    }

    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return stickers[index]
    }
}
