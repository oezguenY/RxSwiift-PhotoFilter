//
//  ViewController.swift
//  CameraFilter
//
//  Created by Özgün Yildiz on 15.04.21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoIV: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segueway destination not found")
            
        }
        // when we are using the segue, we are subscribing to the selectedPhoto which is an observable. By the time we segue, we subscribe.
        photosCVC.selectedPhoto.subscribe(onNext: { photo in
            // and we set our image for our imageView
            DispatchQueue.main.async {
                self.updateUI(with: photo)
            }
            // ARC: We want to avoid memory leaks and strong refernce cycles. ARC is very easy with RxSwift
        }).disposed(by: disposeBag)
        
    }
    
    
    @IBAction func applyFilterButtonPressed() {
        guard let sourceImage = self.photoIV.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage) { filteredImage in
            DispatchQueue.main.async {
                self.photoIV.image = filteredImage
            }
        }
        
    }
    
    
    private func updateUI(with image: UIImage) {
        self.photoIV.image = image
        self.applyFilterButton.isHidden = false
    }
    
}

