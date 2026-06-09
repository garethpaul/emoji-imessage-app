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
    var stickers = [MSSticker]()
    
    func loadStickers() {
        stickers.removeAll()

        guard let docsPath = Bundle.main().resourcePath else {
            return
        }

        let fileManager = FileManager.default()

        do {
            let directoryContents = try fileManager.contentsOfDirectory(atPath: docsPath).sorted()
            for file in directoryContents where isPNGResource(file) {
                let asset = (file as NSString).deletingPathExtension
                createSticker(asset: asset, localizedDescription: asset)
            }
        } catch {
            return
        }
    }

    private func isPNGResource(_ file: String) -> Bool {
        return (file as NSString).pathExtension.lowercased() == "png"
    }
    
    func createSticker(asset:String, localizedDescription: String) {
        guard let stickerPath = Bundle.main().pathForResource(asset, ofType: "png") else {
            return
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        let sticker: MSSticker
        do {
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
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
