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
            if let sourceIndexPath = item.sourceIndexPath {
                if let image = item.dragItem.localObject as! ImageInfo? {
                    collectionView.performBatchUpdates( { imageInfo.remove(at: sourceIndexPath.item); imageInfo.insert(image, at: destinationIndexPath.item) ; collectionView.deleteItems(at: [sourceIndexPath]); collectionView.insertItems(at: [destinationIndexPath]) } )
                    
                    print(image)
                    collectionView.reloadData()
                }
                
            } else {
                //TODO: Add images from seperate app(safari) into our app. Below is a placeholder.
                let placeHolderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "placeholderCell")
                )
                item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (providor, error) in
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                        let url = providor?.imageURL
                            let imageInfo = try? Data(contentsOf: url!)
 
                            let newImage = UIImage(data: imageInfo!)
                        let imageWidth = newImage?.size.width ?? 100
                            let imageHeight = newImage?.size.height ?? 100

                        DispatchQueue.main.async {
                            
                            if let attributedString = providor {
                                let imageRatio = Double(imageHeight / imageWidth)
                                placeHolderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                    self?.imageInfo.insert(ImageInfo(imageUrl: attributedString.absoluteString, imageRatio: imageRatio), at: insertionIndexPath.item)
                                })
                            } else {
                                placeHolderContext.deletePlaceholder()
                            }
                        }
                        
                    }
                    
                    
                }
//                imageInfo.append(ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", imageRatio: 400))
//                collectionView.reloadData()
            }
            

        }
        
        
        
    }
    
    
    
    //TODO Fill out our save function to store json data. Currently we are just printing out the data to console
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        for image in imageInfo {
            if let json = image.json {
                if let jsonString = String(data: json, encoding: .utf8) {
                    print(jsonString)
                }
                
            }
        }
        
        
    }
    
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let imageCell = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageInfo {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageCell))
            dragItem.localObject = imageCell
            return [dragItem]
        } else {
            return []
        }
    }

    
//    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
//        if let image = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.cellImageView.image {
//            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
//            dragItem.localObject = image
//            print([dragItem])
//            return [dragItem]
//        } else {
//            return []
//        }
//    }
    
    
    //100 width constant. And aspect ratio determined from raw image size.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
        return CGSize(width: 100, height: 100 * imageInfo[indexPath.item].imageRatio!)
//            imageSizes[indexPath.item] * 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
      
    
    
    var image: UIImage?
    
    var imageSize: Int?
    
    //Currently storing images after the fetchImagesFromURL pulls the data
    var images = [UIImage]()
    
    //Currently storing image aspect ratios
    var imageSizes = [CGFloat]()
    
    
    var imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg")
    
    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"), URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/2b/Jupiter_and_its_shrunken_Great_Red_Spot.jpg"), URL(string: "https://solarsystem.nasa.gov/system/content_pages/main_images/1530_49_PIA14909_768.jpg"), URL(string: "https://images.alphacoders.com/241/24151.jpg"), URL(string: "https://images2.alphacoders.com/685/685536.jpg"), URL(string: "https://images.unsplash.com/photo-1527445741084-0d3c140baf80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1166&q=80")]
    
    var imageStrings = ["https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg"]
    
    
    var imageInfo = [ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg", imageRatio: 1), ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg", imageRatio: 1), ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", imageRatio: 1), ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg", imageRatio: 1)]
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: ImageInfo.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        

        
        if imageURLs.count > indexPath.item {

            cell.imageInfo = imageInfo[indexPath.item]
        }
        
//        cell.imageInfo = ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/e1/FullMoon2010.jpg", imageRatio: 100)
        
//        cell.imageURL = imageURLs[2]
        
        
        return cell
    }
    
    
    //MARK: Using viewdidload here just to test things for now. Our async function to pull datas from urls is currently being called from here.
//    override func viewDidLoad() {
//        super.viewDidLoad()
////
////        for image in imageURLs {
////            fetchImageFromURL(url: image!)
////        }
//
//
//    }
    
    //MARK: Storyboard outlet ffor collection view
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
        }
    }
    
    //MARK: Our main async function to pull image data from a url. The async function has been been moved to our collectionviewcell so this has been commented out but kept just in case
    
//    private func fetchImageFromURL(url: URL) {
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            let imageData = try? Data(contentsOf: url)
//            let image = UIImage(data: imageData!)
//
//            DispatchQueue.main.async {
//                self.image = image
//                self.images.append(image!)
//
//                //Determining aspect ratio from image
//                if let mySize = self.image?.size {
//                    let height = mySize.height
//                    let width = mySize.width
//
//                    let ratio = height / width
//                    self.imageSizes.append(ratio)
//                }
//
//                self.collectionView.reloadData()
//
//            }
//
//        }
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageZoom" {
            var zoomUrl = String()
            if let zoomImage = sender as? ImageCollectionViewCell {
//                image.backgroundImage = zoomImage.image.image
                zoomUrl = zoomImage.imageURL?.absoluteString ?? "https://images.unsplash.com/photo-1464817739973-0128fe77aaa1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"
            }
            
            if let zoomVC = segue.destination as? ScrollViewController {
                zoomVC.imageURL = URL(string: zoomUrl)
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
