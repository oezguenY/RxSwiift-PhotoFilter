//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Özgün Yildiz on 15.04.21.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()

    // this computed property will be set every time a segue to this VC is initiated
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }

    private var images = [PHAsset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
    }
    
    
    private func populatePhotos() {
        // we are making sure that no retain cycles occur with weak self
        // asking the user whether we may get access to his pictures
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                
                // access pictures
                // with: specifies the type of media that we access
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                // we are iterating over all objects in the mediaLibrary of the user
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                // we want the most recent pictures first, in chronological order
                self?.images.reverse()
                // when a collectionView is reloaded, some functions are being fired. One is numberOfRowsInSection, the other is itemForRowAt
                // changes to the UI have to always be called on the main thread
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
               
            }
        }
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PhotoCollectionViewCell else { fatalError("PhotoCollectionViewCell not found") }
        
        
        // we cant return the asset since its a PHAsset and not a picture
        let asset = self.images[indexPath.item]
        // that is why we use this to get the image
        let manager = PHImageManager.default()
       
        
        // in the closure we put an image and info, since that is what the function will return
        manager.requestImage(for: asset, targetSize: CGSize(width: 180, height: 180), contentMode: .aspectFill, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
            
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.item]
        // this function gives you the image and the info about the image
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) {
            [weak self] image, info in
            
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
