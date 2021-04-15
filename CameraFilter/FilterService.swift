//
//  FilterService.swift
//  CameraFilter
//
//  Created by Özgün Yildiz on 15.04.21.
//

import UIKit
import CoreImage

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    // function takes 2 arguments; the image the filter is being applied to and the image after the filter has been applied to it. The closure is giving us access to the filtered image
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
                
                
            }
            
        }
    
    }
}
