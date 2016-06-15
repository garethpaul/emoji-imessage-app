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
        
        let docsPath = Bundle.main().resourcePath!
        print(docsPath)
        let fileManager = FileManager.default()

        do {
            let directoryContents = try fileManager.contentsOfDirectory(atPath: docsPath)
            for file in directoryContents {
                if file.hasSuffix(".png") {
                    createSticker(asset: file.replacingOccurrences(of: ".png", with: ""), localizedDescription: "asset")
                }
            }
        } catch {
            print("ERROR: Unable to read directory: \(docsPath)")
        }
        
    }
    
    func createSticker(asset:String, localizedDescription: String) {
        guard let stickerPath = Bundle.main().pathForResource(asset, ofType: "png") else {
            print("couldn't create the sticker path for", asset)
            return
        }
        let stickerURL = URL(fileURLWithPath: stickerPath)
        let sticker: MSSticker
        do {
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: localizedDescription)
            stickers.append(sticker)
        } catch {
            print(error)
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
