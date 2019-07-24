//
//  DocumentViewController.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate {
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
    
    
    var higgins = UIImage(named: "higgins")
    
    var image: UIImage?
    
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg")
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.image = image
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImageFromURL()
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
        }
    }
    
    
   private func fetchImageFromURL() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: self.imageURL!)
            let image = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self.image = image
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
