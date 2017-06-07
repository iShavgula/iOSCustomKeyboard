//
//  RealmKeyboardInfo.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RealmKeyboardInfo: Object, Mappable {
    dynamic var horizontalInset: Float = 0
    dynamic var verticalInset: Float = 0
    dynamic var height: Float = 0
    dynamic var width: Float = 0
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        horizontalInset     <-  map["horizontal_inset"]
        verticalInset       <-  map["vertical_inset"]
        height              <-  map["height"]
        width               <-  map["width"]
    }
}

extension RealmKeyboardInfo {
    class func initWithJsonString(jsonString: String) -> RealmKeyboardInfo? {
        return Mapper<RealmKeyboardInfo>().map(JSONString: jsonString)
    }
}
