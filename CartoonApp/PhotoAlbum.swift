//
//  PhotoAlbum.swift
//  CartoonApp
//
//  Created by Thanh Sau on 16/03/2024.
//

import Foundation
import SwiftUI
import Photos

enum CustomPhotoAlbum {

    static let albumName = "CartoonApp"

    private static func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title=%@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject
    }

    static func save(image: EFImage, finish: @escaping ((_ error: String?) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            if let assetCollection = fetchAssetCollectionForAlbum() {
                save(image: image, to: assetCollection, finish: finish)
            } else {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (success, error) in
                    if success {
                        save(image: image, finish: finish)
                    } else {
                        finish(error?.localizedDescription ??
                            NSLocalizedString("Can't create photo album", comment: ""))
                    }
                })
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in
                save(image: image, finish: finish)
            }
        case .restricted:
            finish(NSLocalizedString("You can't grant access to the photo library.", comment: ""))
        case .denied:
            finish(NSLocalizedString("You didn't grant access to the photo library.", comment: ""))
        @unknown default:
            finish("Error")
        }
    }
    
    private static func save(image: EFImage, to assetCollection: PHAssetCollection,
                             finish: @escaping ((_ error: String?) -> Void)) {
        var errored = false
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest: PHAssetChangeRequest?
            switch image {
            case .gif(let data):
                guard let documentsDirectoryURL = try? FileManager.default
                        .url(for: .documentDirectory, in: .userDomainMask,
                             appropriateFor: nil, create: true)
                else {
                        finish(NSLocalizedString("Can't create a temporary gif file for export",
                                                 comment: "FileURL is nil"))
                        errored = true
                        return
                }
                let fileURL = documentsDirectoryURL.appendingPathComponent("EFQRCode_temp.gif")
                try? data.write(to: fileURL)
                assetChangeRequest = .creationRequestForAssetFromImage(atFileURL: fileURL)
            case .normal(let image):
                assetChangeRequest = .creationRequestForAsset(from: image)
            }
            if let assetPlaceHolder = assetChangeRequest?.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                albumChangeRequest?.addAssets([assetPlaceHolder] as NSFastEnumeration)
            } else {
                finish(NSLocalizedString("Can't create a placeholder to export gif to", comment: "PlaceholderForCreatedAsset is nil!"))
                errored = true
            }
        }, completionHandler: { (success, error) in
            if errored { return }
            if success {
                finish(nil)
            } else {
                finish(error?.localizedDescription ?? "Error")
            }
        })
    }
}

enum EFImage {
    case normal(_ image: UIImage)
    case gif(_ data: Data)
    
    var isGIF: Bool {
        switch self {
        case .normal: return false
        case .gif: return true
        }
    }
}
