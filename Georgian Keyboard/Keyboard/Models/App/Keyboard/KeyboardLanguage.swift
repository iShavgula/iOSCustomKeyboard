//
//  KeyboardLanguage.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct KeyboardLanguage {
    var name: String
    
    var alphabet: [KeyboardLine]
    var numbers: [KeyboardLine]
    
    var frame: [KOrientation: CGRect]
}


extension KeyboardLanguage {
    init?(object: RealmKeyboardLanguage) {
        guard
            let horizontalPositioningPortrait = object.horizontalPositioningPortrait,
            let horizontalPositioningLandscape = object.horizontalPositioningLandscape,
            let verticalPositioningPortrait = object.verticalPositioningPortrait,
            let verticalPositioningLandscape = object.verticalPositioningLandscape
            else {
                return nil
        }
        
        name = object.name
        
        alphabet = []
        for lineObject in object.alphabet {
            guard let line = KeyboardLine(object: lineObject, isAlphabetLine: true) else {
                return nil
            }
            alphabet.append(line)
        }
        
        numbers = []
        for lineObject in object.numbers {
            guard let line = KeyboardLine(object: lineObject, isAlphabetLine: false) else {
                return nil
            }
            numbers.append(line)
        }
        
        frame = [:]
        frame[.portrait] = CGRect(x: horizontalPositioningPortrait.origin.cgf,
                                  y: verticalPositioningPortrait.origin.cgf,
                                  width: horizontalPositioningPortrait.width.cgf,
                                  height: verticalPositioningPortrait.height.cgf)
        frame[.landscape] = CGRect(x: horizontalPositioningLandscape.origin.cgf,
                                  y: verticalPositioningLandscape.origin.cgf,
                                  width: horizontalPositioningLandscape.width.cgf,
                                  height: verticalPositioningLandscape.height.cgf)
    }
}
