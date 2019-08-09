//
//  ScrollViewController.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 8/8/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    
    var imageURL: URL? {
        didSet {
            fetchImage()
//            image = nil
//            if view.window != nil {     // we're on Screen!!
//                fetchImage()
//            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            
        }
    }
    
    var imageView = UIImageView()
    
    private func fetchImage() {
        if let url = imageURL {
             DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    //Make sure that the image after if the image loads if it is still the same one selected.
                    if let imageData = urlContents, url == self?.imageURL?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
                
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg")
        if imageURL == nil {
            imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
