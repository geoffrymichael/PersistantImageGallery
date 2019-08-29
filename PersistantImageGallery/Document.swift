//
//  Document.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 7/23/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    var imageInfoArray: [ImageInfo.GalleryInfo]?
    
    
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
       
        if let myData = try? JSONEncoder().encode(imageInfoArray.self) {
            return myData
        } else {
            return Data()
        }
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let json = contents as? Data {
            imageInfoArray = try? JSONDecoder().decode([ImageInfo.GalleryInfo].self, from: json)
        } 
    }
}

