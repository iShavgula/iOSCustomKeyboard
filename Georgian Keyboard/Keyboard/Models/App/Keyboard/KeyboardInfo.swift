//
//  KeyboardInfo.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation

struct KeyboardInfo {
    var horizontalInset: Float
    var verticalInset: Float
    var height: Float
    var width: Float
}

extension KeyboardInfo {
    init(object: RealmKeyboardInfo) {
        horizontalInset = object.horizontalInset
        verticalInset = object.verticalInset
        height = object.height
        width = object.width
    }
}
