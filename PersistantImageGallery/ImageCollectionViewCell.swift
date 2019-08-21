//
//  ImageCollectionViewCell.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    var imageInfo: ImageInfo? {
        didSet {
            imageURL = URL(string: (imageInfo?.imageUrl)!)
        }
    }
    
    
    var imageURL: URL? {
        didSet {
            
            
            if imageURL != nil {
                fetchImage(url: imageURL!)
            }
            
            
        }
    }
    
    var image: UIImage? {
        didSet {
            cellImageView.image = image
            
        }
    }
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    func fetchImage(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let imageData = try? Data(contentsOf: url)
            let fetchedImage = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self?.image = fetchedImage
                
            }
        }
    }
    
}
