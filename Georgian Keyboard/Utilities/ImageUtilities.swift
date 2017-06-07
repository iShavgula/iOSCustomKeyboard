//
//  PhotoUtilities.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

class ImageUtilities {
    fileprivate static let instance = ImageUtilities()
    fileprivate final let dirImages: String
    fileprivate final var dirBackgroundImages: String
    
    fileprivate init() {
        dirImages = FileUtilities.documentsDirectory().appendingPathComponent("Images")
        dirBackgroundImages = dirImages.NS.appendingPathComponent("Background")
    }
    
    
    // MARK: - Paths
    
    fileprivate class func imagePath(name: String) -> String {
        return instance.dirImages.NS.appendingPathComponent(name)
    }
    
    fileprivate class func backgroundImagePath(name: String) -> String {
        return instance.dirBackgroundImages.NS.appendingPathComponent(name)
    }
    
    
    // MARK: - Retrieve
    
    class func image(name: String) -> UIImage? {
        return UIImage(contentsOfFile: imagePath(name: name))
    }
    
    class func backgroundImage(name: String) -> UIImage? {
        return UIImage(contentsOfFile: backgroundImagePath(name: name))
    }
    
    
    // MARK: - Save
    
    fileprivate class func save(image: UIImage, path: String) -> Bool {
        FileUtilities.deleteFile(path: path)
        do {
            try UIImagePNGRepresentation(image)?.write(to: path.url!, options: .atomic)
        } catch _ {
            return false
        }
        
        return true
    }
    
    class func saveImage(image: UIImage, withName name: String) -> Bool {
        return save(image: image, path: imagePath(name: name))
    }
    
    class func saveBackgroundImage(image: UIImage, withName name: String) -> Bool {
        return save(image: image, path: backgroundImagePath(name: name))
    }
    
    
    // MARK: - Delete
    
    class func deleteImage(name: String) {
        FileUtilities.deleteFile(path: imagePath(name: name))
    }
    
    class func deleteBackgroundImage(name: String) {
        FileUtilities.deleteFile(path: backgroundImagePath(name: name))
    }
    
    
    // MARK: - Rename
    
    class func renameImage(from: String, to: String) -> Bool {
        return FileUtilities.renameFile(name: imagePath(name: from), to: imagePath(name: to))
    }
    
    class func renameBackgroundImage(from: String, to: String) -> Bool {
        return FileUtilities.renameFile(name: backgroundImagePath(name: from), to: backgroundImagePath(name: to))
    }
}
