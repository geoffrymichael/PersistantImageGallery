//
//  ImageCollectionViewCell.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageURL: URL? {
        didSet {
            print("Helllllo")
            fetchImage()
            
        }
    }
    
    var image: UIImage? {
        didSet {
            cellImageView.image = image
            
        }
    }
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    func fetchImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: self.imageURL!)
            let fetchedImage = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self.image = fetchedImage
                
            }
        }
    }
    
}
