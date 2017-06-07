//
//  KeyboardKey.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit


// MARK: - Shape

enum KKeyShape: String {
    case none = "none"
    case globe = "globe"
    case shift = "shift"
    case delete = "delete"
}


// MARK: - Style

enum KKeyStyle: String {
    case light = "light"
    case dark = "dark"
    case blue = "blue"
}

enum KKeyType: String {
    case none = "none"
    case shift = "shift"
    case shiftNumbers = "shift_numbers"
    case delete = "delete"
    case numbers = "numbers"
    case language = "language"
    case returnn = "return"
    case space = "space"
    case shiftLeft = "shift_left"
    case shiftRight = "shift_right"
    case doubleShiftLeft = "double_shift_left"
    case doubleShiftRight = "double_shift_right"
    case dismiss = "dismiss"
}



struct KeyboardKey {
    var style: KKeyStyle
    var canPopup: Bool
    var canHiglight: Bool
    var type: KKeyType
    var isAlphabetKey: Bool
    var shape: KKeyShape
    var input: String
    var shiftInput: String
    var inputOptions: [String]
    
    var frame: [KOrientation: CGRect]
    var insetLeft: [KOrientation: CGFloat]
    var insetRight: [KOrientation: CGFloat]
}

extension KeyboardKey {
    init?(object: RealmKeyboardKey, heightPortrait: Float, heightLandscape: Float, isAlphabetKey: Bool) {
        guard
            let style = KKeyStyle(rawValue: object.style),
            let shape = KKeyShape(rawValue: object.shape),
            let type = KKeyType(rawValue: object.type),
            let horizontalPositioningPortrait = object.horizontalPositioningPortrait,
            let horizontalPositioningLandscape = object.horizontalPositioningLandscape
        else {
            return nil
        }
        
        self.style = style
        self.type = type
        self.shape = shape
        self.isAlphabetKey = isAlphabetKey
        self.canPopup = object.canPopup
        self.canHiglight = object.canHiglight
        self.input = object.input
        self.shiftInput = object.shiftInput
        self.inputOptions = object.inputOptions.reduce([]) {
            guard let val = $1.value else {
                return $0
            }
            return $0 + [val]
        }
        
        frame = [:]
        frame[.portrait] = CGRect(x: horizontalPositioningPortrait.origin.cgf, y: 0, width: horizontalPositioningPortrait.width.cgf, height: heightPortrait.cgf)
        frame[.landscape] = CGRect(x: horizontalPositioningLandscape.origin.cgf, y: 0, width: horizontalPositioningLandscape.width.cgf, height: heightLandscape.cgf)
        
        insetLeft = [:]
        insetLeft[.portrait] = horizontalPositioningPortrait.widthEmptyLeft.cgf
        insetLeft[.landscape] = horizontalPositioningLandscape.widthEmptyLeft.cgf
        insetRight = [:]
        insetRight[.portrait] = horizontalPositioningPortrait.widthEmptyRight.cgf
        insetRight[.landscape] = horizontalPositioningLandscape.widthEmptyRight.cgf
    }
}
