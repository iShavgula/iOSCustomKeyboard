//
//  RealmKeyboardHorizontalPositioning.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

enum RealmKeyboardKeyPositioningType: String {
    case Auto = "auto"
    case Fixed = "fixed"
    case Rest = "rest"
}

class RealmKeyboardHorizontalPositioning: Object, Mappable {
    dynamic var type: String = RealmKeyboardKeyPositioningType.Fixed.rawValue
    let value = RealmOptional<Float>()
    dynamic var emptyLeft: Float = 0
    dynamic var emptyRight: Float = 0
    
    dynamic var origin: Float = 0
    dynamic var width: Float = 0
    dynamic var widthEmptyLeft: Float = 0
    dynamic var widthEmptyRight: Float = 0
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        var _value: Float? = value.value
        
        type        <- map["type"]
        _value      <- map["value"]
        emptyLeft   <-  map["empty_left"]
        emptyRight  <-  map["empty_right"]
        
        value.value = _value
    }
}

extension RealmKeyboardHorizontalPositioning {
    class func initWithJsonString(jsonString: String) -> RealmKeyboardHorizontalPositioning? {
        return Mapper<RealmKeyboardHorizontalPositioning>().map(JSONString: jsonString)
    }
}


extension RealmKeyboardHorizontalPositioning {
    func precalculate(widthTotal: Float, emptyTotal: Float, curX: Float) {
        self.widthEmptyLeft = emptyTotal * emptyLeft
        self.widthEmptyRight = emptyTotal * emptyRight
        let widthEmpty = widthEmptyLeft + widthEmptyRight
        
        switch type {
        case RealmKeyboardKeyPositioningType.Fixed.rawValue:
            guard let value = value.value else {
                print("Couldn't find 'Value' for key positioning")
                return
            }
            self.width = value + widthEmpty
            
        case RealmKeyboardKeyPositioningType.Auto.rawValue:
            guard let value = value.value else {
                print("Couldn't find 'Value' for key positioning")
                return
            }
            self.width = value * widthTotal + widthEmpty
            
        case RealmKeyboardKeyPositioningType.Rest.rawValue:
            self.width = emptyTotal
            
        default:
            break
        }
        
        self.origin = curX
    }
    
    func knownWidth(total: Float) -> Float {
        switch type {
        case RealmKeyboardKeyPositioningType.Fixed.rawValue:
            return value.value ?? 0
            
        case RealmKeyboardKeyPositioningType.Auto.rawValue:
            return total * (value.value ?? 0)
            
        default:
            return 0
        }
    }
}



//
//extension KeyboardPositioning {
//    init?(object: RealmKeyboardHorizontalPositioning?) {
//        guard let object = object else {
//            return nil
//        }
//        
//        guard
//            let originXPortrait = object.originXPortrait.value,
//            let originYPortrait = object.originYPortrait.value,
//            
//            let originXLandscape = object.originXLandscape.value,
//            let originYLandscape = object.originYLandscape.value,
//            
//            
//            let sizeWidthPortrait = object.sizeWidthPortrait.value,
//            let sizeHeightPortrait = object.sizeHeightPortrait.value,
//            
//            let sizeWidthLandscape = object.sizeWidthLandscape.value,
//            let sizeHeightLandscape = object.sizeHeightLandscape.value,
//            
//            
//            let insetsLeftPortrait = object.insetsLeftPortrait.value,
//            let insetsTopPortrait = object.insetsTopPortrait.value,
//            let insetsRightPortrait = object.insetsRightPortrait.value,
//            let insetsBotPortrait = object.insetsBotPortrait.value,
//            
//            let insetsLeftLandscape = object.insetsLeftLandscape.value,
//            let insetsTopLandscape = object.insetsTopLandscape.value,
//            let insetsRightLandscape = object.insetsRightLandscape.value,
//            let insetsBotLandscape = object.insetsBotLandscape.value
//        else {
//            return nil
//        }
//        
//        self.origin = [
//            .Portrait: CGPoint(x: originXPortrait.cgf, y: originYPortrait.cgf),
//            .Landscape: CGPoint(x: originXLandscape.cgf, y: originYLandscape.cgf)
//        ]
//        
//        self.size = [
//            .Portrait: CGSize(width: sizeWidthPortrait.cgf, height: sizeHeightPortrait.cgf),
//            .Landscape: CGSize(width: sizeWidthLandscape.cgf, height: sizeHeightLandscape.cgf)
//        ]
//        
//        self.insets = [
//            .Portrait: UIEdgeInsets(top: insetsTopPortrait.cgf,
//                                    left: insetsLeftPortrait.cgf,
//                                    bottom: insetsBotPortrait.cgf,
//                                    right: insetsRightPortrait.cgf),
//            .Landscape: UIEdgeInsets(top: insetsTopLandscape.cgf,
//                                     left: insetsLeftLandscape.cgf,
//                                     bottom: insetsBotLandscape.cgf,
//                                     right: insetsRightLandscape.cgf)
//        ]
//    }
//}
