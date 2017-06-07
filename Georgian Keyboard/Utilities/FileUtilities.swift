//
//  FileManager.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation

class FileUtilities {
    
    class func documentsDirectory() -> NSString {
        //        let str = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CustomKeyboard.Georgian")!.path!
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    }
    
    class func fileExists(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func createFolder(path: String) -> Bool {
        if !fileExists(path: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                return false
            }
        }
        
        return true
    }
    
    class func deleteFile(path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch _ {
            // TODO: Maybe do smth?
        }
    }
    
    class func renameFile(name: String, to newName: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: name, toPath: newName)
        } catch _ {
            return false
        }
        return true
    }
}
