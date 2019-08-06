//
//  DocumentViewController.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//






import UIKit

class DocumentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    
    //TODO: Drop delegate setup that needs to be filled out 
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        for item in coordinator.items {
            print(item)
        }
        
        
    }
    
    
    
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
    
    
    //100 width constant. And aspect ratio determined from raw image size.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
        return CGSize(width: 100, height: 100)
//            imageSizes[indexPath.item] * 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
      
    
    
    var image: UIImage?
    
    //Currently storing images after the fetchImagesFromURL pulls the data
    var images = [UIImage]()
    
    //Currently storing image aspect ratios
    var imageSizes = [CGFloat]()
    
    
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg")
    
    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/Jupiter_and_its_shrunken_Great_Red_Spot.jpg"), URL(string: "https://solarsystem.nasa.gov/system/content_pages/main_images/1530_49_PIA14909_768.jpg"), URL(string: "https://images.alphacoders.com/241/24151.jpg"), URL(string: "https://images2.alphacoders.com/685/685536.jpg"), URL(string: "https://images.unsplash.com/photo-1527445741084-0d3c140baf80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1166&q=80")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
//        if images.count > 1 {
//            cell.image = images[1]
//        }
        
//        if images.count > indexPath.item {
////            cell.image = images[indexPath.item]
//            cell.imageURL = imageURLs[3]
//        }
        
        if imageURLs.count > indexPath.item {
            cell.imageURL = imageURLs[indexPath.item]
        }
        
//        cell.imageURL = imageURLs[2]
        
        
        return cell
    }
    
    
    //MARK: Using viewdidload here just to test things for now. Our async function to pull datas from urls is currently being called from here.
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        for image in imageURLs {
//            fetchImageFromURL(url: image!)
//        }
        
        
    }
    
    //MARK: Storyboard outlet ffor collection view
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
        }
    }
    
    //MARK: Our main async function to pull image data from a url
    private func fetchImageFromURL(url: URL) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: url)
            let image = UIImage(data: imageData!)
            
            DispatchQueue.main.async {
                self.image = image
                self.images.append(image!)
                
                //Determining aspect ratio from image
                if let mySize = self.image?.size {
                    let height = mySize.height
                    let width = mySize.width
                    
                    let ratio = height / width
                    self.imageSizes.append(ratio)
                }
                
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
