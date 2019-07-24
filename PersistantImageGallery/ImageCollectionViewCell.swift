//
//  ImageCollectionViewCell.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    
    var image: UIImage? {
        didSet {
            cellImageView.image = image
            
        }
    }
    
    @IBOutlet weak var cellImageView: UIImageView! 
}
