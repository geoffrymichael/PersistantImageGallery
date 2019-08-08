//
//  File.swift
//  PersistantImageGallery
//
//  Created by Geoffry Gambling on 8/4/19.
//  Copyright © 2019 Geoffry Gambling. All rights reserved.
//

import Foundation
import MobileCoreServices

class ImageInfo: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading {
    
    
    
    var imageUrl: String?
    var imageRatio: Double?
    
    init(imageUrl: String, imageRatio: Double) {
        self.imageUrl = imageUrl
        self.imageRatio = imageRatio
    }
    
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return[(kUTTypeData) as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return progress
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        
        do {
            let myJSON = try decoder.decode(self, from: data)
            return myJSON
        } catch {
            fatalError("Err")
        }
        
    }
    
}
