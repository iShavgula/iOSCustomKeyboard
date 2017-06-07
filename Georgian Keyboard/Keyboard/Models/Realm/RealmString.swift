//
//  RealmString.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmString: Object {
    dynamic var value: String?
    
    func setStringValue(value: String?) -> RealmString {
        self.value = value
        return self
    }
}
