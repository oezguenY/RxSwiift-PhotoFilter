//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Özgün Yildiz on 15.04.21.
//

import Foundation
import UIKit
import Photos

class PhotosCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }
    
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                
                // access pictures
                
            }
        }
    }
    
}
