//
//  DocumentViewController.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//





import UIKit

class DocumentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
    
    
 
    //MARK: Drop Coordinator
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
                        if let imageInfo = try? Data(contentsOf: url!) {
                            if let newImage = UIImage(data: imageInfo) {
                                
                                DispatchQueue.main.async {
                                    
                                    if let attributedString = providor {
                                        let imageRatio = Double(newImage.size.height / newImage.size.width)
                                        placeHolderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                            self?.imageInfo.insert(ImageInfo(imageUrl: attributedString.absoluteString, imageRatio: imageRatio), at: insertionIndexPath.item)
                                        })
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    placeHolderContext.deletePlaceholder()
                                }
    
                            
                            }
                        }
   
                    }
                    
                    
                }
//                imageInfo.append(ImageInfo(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", imageRatio: 400))
//                collectionView.reloadData()
            }
            

        }
        
        
        
    }
    
    var document: Document?
    
    //TODO: Need to configure to save and load using document browser. May want to rethink my model?
    
    //A function to save a gallery as json data to disk. For now I am trying to keep our single custom class object beceause I belive I need to for it to remain draggable. So I have saved the actual array into a codable struct in our class. Not sure if this normal procedure, but it seems to be working. Not sure if this will cause trouble when using actual document browser. 
    
    var saveArray = [ImageInfo.GalleryInfo]()
    
    var thumbnail: UIImage?
    
    @IBAction func close(_ sender: Any) {
        save()
        
        document?.thumbnail =  self.view.snapshot   
        dismiss(animated: true, completion: {
            self.document?.close()
        })
        
    }
    
    
    
    func save() {
  

        for image in imageInfo {
            saveArray.append(ImageInfo.GalleryInfo(imageUrl: image.imageUrl, imageRatio: image.imageRatio))
        }
        
        document?.imageInfoArray = saveArray
        
        if document?.imageInfoArray != nil {
            document?.updateChangeCount(.done)
        }


        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        document?.open(completionHandler: { success in
            if success {
                
                self.title = self.document?.localizedName
                
                
                self.collectionView.performBatchUpdates({
                    
                    if let imageOpen = self.document?.imageInfoArray {
                        for image in imageOpen {
                            let indexPath = IndexPath(row: self.imageInfo.count, section: 0)
                            self.imageInfo.append(ImageInfo(imageUrl: image.imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", imageRatio: image.imageRatio ?? 1))
                            self.collectionView.insertItems(at: [indexPath])
                            
                        }
                    }
                    
                })
                
                
                
                
                
                
            } else {
                print("did not work")
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        document?.open(completionHandler: { success in
//            if success {
//
//                self.title = self.document?.localizedName
//
//
//                    self.collectionView.performBatchUpdates({
//
//                        if let imageOpen = self.document?.imageInfoArray {
//                            for image in imageOpen {
//                                let indexPath = IndexPath(row: self.imageInfo.count, section: 0)
//                                self.imageInfo.append(ImageInfo(imageUrl: image.imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/b/b2/Cassini_Saturn_Orbit_Insertion.jpg", imageRatio: image.imageRatio ?? 1))
//                                self.collectionView.insertItems(at: [indexPath])
//
//                            }
//                        }
//
//                    })
//
//
//
//
//
//
//            } else {
//                print("did not work")
//            }
//
//        })
        

    }
    
    //Creating a dragItem from our ImageInfo class
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let imageCell = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageInfo {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageCell))
            dragItem.localObject = imageCell
            return [dragItem]
        } else {
            return []
        }
    }

    


    
    
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
    
   
    
    
    var imageInfo = [ImageInfo]()
    
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
    
    
    
    //MARK: Storyboard outlet for collection view
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            
            //This needs to be explicitely set to true to enable collection view drag on iphone
            collectionView.dragInteractionEnabled = true
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageZoom" {
            var zoomUrl = String()
            if let zoomImage = sender as? ImageCollectionViewCell {
                zoomUrl = zoomImage.imageURL?.absoluteString ?? "https://images.unsplash.com/photo-1464817739973-0128fe77aaa1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"
            }
            
            if let zoomVC = segue.destination as? ScrollViewController {
                zoomVC.imageURL = URL(string: zoomUrl)
            }
            
            
        }
    }
    
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
   
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
