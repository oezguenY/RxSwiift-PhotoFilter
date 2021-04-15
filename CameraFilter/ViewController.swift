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
        // when we are using the segue, we are subscribing to the selectedPhoto which is an observable.
        photosCVC.selectedPhoto.subscribe(onNext: { photo in
            
            self.photoIV.image = photo
            // ARC
        }).disposed(by: disposeBag)
        
    }
    
}

