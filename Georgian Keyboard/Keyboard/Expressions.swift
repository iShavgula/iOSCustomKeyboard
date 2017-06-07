//
//  Expressions.swift
//  Georgian keyboard
//
//  Created by Giorgi Shavgulidze on 29/08/15.
//  Copyright © 2015 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

extension String {
    func isEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
            options: [.caseInsensitive])
        
        return regex.firstMatch(in: self, options:[],
            range: NSMakeRange(0, utf16.count)) != nil
    }
    
    func isEndOfSentence() -> Bool {
        let regex = try! NSRegularExpression(pattern: "\\w+ \\z",
            options: [.caseInsensitive])
        
        return regex.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count)).count > 0
    }
    
    func lastWordSize() -> Int {
        let regex = try! NSRegularExpression(pattern: "\\w+[^\\w]*\\z",
            options: [.caseInsensitive])
        
        if let res = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) {
            return res.range.length
        }
        
        return self.characters.count
    }
    
    func jumpLeftSize() -> Int {
        let regex = try! NSRegularExpression(pattern: "\\w+[^\\w]*\\z",
            options: [.caseInsensitive]) //(\\w+\\s*|[^\\w\\s]\\s*)\\z
        
        if let res = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) {
            return res.range.length
        }
        
        return self.characters.count
    }
    
    func jumpRightSize() -> Int {
        let regex = try! NSRegularExpression(pattern: "^[^\\w]*\\w+",
            options: [.caseInsensitive])
        
        if let res = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) {
            return res.range.length
        }
        
        return self.characters.count
    }
    
    func lastWord() -> String {
        let regex = try! NSRegularExpression(pattern: "\\w+\\z",
            options: [.caseInsensitive])
        
        if let res = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) {
            return (self as NSString).substring(with: res.range)
        }
        
        return ""
    }
    
}
