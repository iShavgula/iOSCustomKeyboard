//
//  KeyboardLine.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct KeyboardLine {
    var isAlphabetLine: Bool
    var keys: [KeyboardKey]
    
    var frame: [KOrientation: CGRect]
}

extension KeyboardLine {
    init?(object: RealmKeyboardLine, isAlphabetLine: Bool) {
        guard
            let horizontalPositioningPortrait = object.horizontalPositioningPortrait,
            let horizontalPositioningLandscape = object.horizontalPositioningLandscape,
            let verticalPositioningPortrait = object.verticalPositioningPortrait,
            let verticalPositioningLandscape = object.verticalPositioningLandscape
        else {
            return nil
        }
        
        self.isAlphabetLine = isAlphabetLine
        
        frame = [:]
        frame[.portrait] = CGRect(x: horizontalPositioningPortrait.origin.cgf,
                                  y: verticalPositioningPortrait.origin.cgf,
                                  width: horizontalPositioningPortrait.width.cgf,
                                  height: verticalPositioningPortrait.height.cgf)
        frame[.landscape] = CGRect(x: horizontalPositioningLandscape.origin.cgf,
                                  y: verticalPositioningLandscape.origin.cgf,
                                  width: horizontalPositioningLandscape.width.cgf,
                                  height: verticalPositioningLandscape.height.cgf)
        
        keys = []
        for objectKey in object.keys {
            guard let key = KeyboardKey(object: objectKey, heightPortrait: verticalPositioningPortrait.height, heightLandscape: verticalPositioningLandscape.height, isAlphabetKey: isAlphabetLine) else {
                return nil
            }
            keys.append(key)
        }
    }
}
