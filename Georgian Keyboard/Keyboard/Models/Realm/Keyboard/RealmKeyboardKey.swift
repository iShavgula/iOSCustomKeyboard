//
//  RealmKeyboardKey.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RealmKeyboardKey: Object, Mappable {
    dynamic var index: Int = 0
    dynamic var style: String = KKeyStyle.light.rawValue
    dynamic var canPopup: Bool = true
    dynamic var canHiglight: Bool = true
    dynamic var type: String = KKeyType.none.rawValue
    dynamic var shape: String = KKeyShape.none.rawValue
    dynamic var input: String = ""
    dynamic var shiftInput: String = ""
    let inputOptions = List<RealmString>()
    
    dynamic var horizontalPositioningPortrait: RealmKeyboardHorizontalPositioning?
    dynamic var horizontalPositioningLandscape: RealmKeyboardHorizontalPositioning?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        var _inputOptions: [String] = inputOptions.filter({ $0.value != nil }).map { $0.value! }
        
        index                   <- map["index"]
        style                   <- map["style"]
        canPopup                <- map["can_popup"]
        canHiglight             <- map["arr"]
        shape                   <- map["shape"]
        type                    <- map["type"]
        input                   <- map["input"]
        shiftInput              <- map["shift_input"]
        _inputOptions           <- map["input_options"]
        horizontalPositioningPortrait     <- map["positioning_portrait"]
        horizontalPositioningLandscape    <- map["positioning_landscape"]
        
        let _ = _inputOptions.map { inputOptions.append(RealmString().setStringValue(value: $0)) }
    }
}

extension RealmKeyboardKey {
    class func initWithJsonString(jsonString: String) -> RealmKeyboardKey? {
        return Mapper<RealmKeyboardKey>().map(JSONString: jsonString)
    }
}


extension RealmKeyboardKey {
    func precalculate(orientation: RealmKeyboardOrientation, widthTotal: Float, emptyTotal: Float, curX: Float) {
        switch orientation {
        case .Portrait:
            horizontalPositioningPortrait?.precalculate(widthTotal: widthTotal, emptyTotal: emptyTotal, curX: curX)
            
        case .Landscape:
            horizontalPositioningLandscape?.precalculate(widthTotal: widthTotal, emptyTotal: emptyTotal, curX: curX)
        }
        
        
    }
    
    func knownWidth(orientation: RealmKeyboardOrientation, totalWidth: Float) -> Float {
        switch orientation {
        case .Portrait:
            return horizontalPositioningPortrait?.knownWidth(total: totalWidth) ?? 0
            
        case .Landscape:
            return horizontalPositioningLandscape?.knownWidth(total: totalWidth) ?? 0
        }
    }
    
    func calculatedWidth(orientation: RealmKeyboardOrientation) -> Float {
        switch orientation {
        case .Portrait:
            return horizontalPositioningPortrait?.width ?? 0
            
        case .Landscape:
            return horizontalPositioningLandscape?.width ?? 0
        }
    }
}


//
//extension Sequence where Iterator.Element: RealmKeyboardKey {
//    func toKeyboardKeys() -> [KeyboardKey] {
//        var res: [KeyboardKey] = []
//        for one in self {
//            guard let key = KeyboardKey(object: one) else {
//                continue
//            }
//            res.append(key)
//        }
//        
//        return res
//    }
//}
