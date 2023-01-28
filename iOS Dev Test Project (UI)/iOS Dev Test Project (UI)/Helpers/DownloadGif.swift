//
//  DownloadGif.swift
//  iOS Dev Test Project (UI)
//
//  Created by Христиченко Александр on 2023-01-28.
//

import Photos
import UIKit

class DownloadGif {
    
    //Singleton
    static let shared = DownloadGif()
    
    //Basic URLSession function
    private func getGifData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //Save gif to phone library
    func downloadGif(from url: URL) {
        getGifData(from: url) { data, _, error in
            guard let data = data, error == nil else { return }
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: nil)
            })
        }
    }
    
    //Copy gif to clipboard
    func copyGif(from url: URL) {
        getGifData(from: url) { data, _, error in
            guard let data = data, error == nil else { return }
            UIPasteboard.general.setData(data, forPasteboardType: "com.compuserve.gif")
        }
    }
}
