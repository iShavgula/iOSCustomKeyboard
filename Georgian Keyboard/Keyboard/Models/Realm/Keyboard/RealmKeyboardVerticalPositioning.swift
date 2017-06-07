//
//  RealmKeyboardVerticalPositioning.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmKeyboardVerticalPositioning: Object {
    dynamic var origin: Float = 0
    dynamic var height: Float = 0
}


extension RealmKeyboardVerticalPositioning {
    func precalculate(origin: Float, height: Float) {
        self.origin = origin
        self.height = height
    }
}
