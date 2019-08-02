//
//  DocumentViewController.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout {
    
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.cellImageView.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            print([dragItem])
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
        return imageSizes[indexPath.item]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
      
    
    
    var image: UIImage?
    
    var images = [UIImage]()
    
    var imageSizes = [CGSize]()
    
    
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg")
    
    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/Jupiter_and_its_shrunken_Great_Red_Spot.jpg")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
//        if images.count > 1 {
//            cell.image = images[1]
//        }
        
        if images.count > indexPath.item {
            cell.image = images[indexPath.item]
        }
        
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchImageFromURL(url: imageURLs[1]!)
//        fetchImageFromURL(url: imageURLs[0]!)
        for image in imageURLs {
            fetchImageFromURL(url: image!)
        }
        
        
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
        }
    }
    
    
    private func fetchImageFromURL(url: URL) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: url)
            let image = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self.image = image
                self.images.append(image!)
                self.imageSizes.append(image?.size ?? CGSize(width: 500, height: 500))
                print(self.imageSizes)
                self.collectionView.reloadData()
                
            }
            
        }
        
    }
    
    
    
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
