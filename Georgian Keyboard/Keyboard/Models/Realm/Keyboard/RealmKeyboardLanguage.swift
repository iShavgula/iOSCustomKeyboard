//
//  RealmLanguage.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RealmKeyboardLanguage: Object, Mappable {
    dynamic var name: String = ""
    
    var alphabet = List<RealmKeyboardLine>()
    var numbers = List<RealmKeyboardLine>()
    
    dynamic var horizontalPositioningPortrait: RealmKeyboardHorizontalPositioning?
    dynamic var horizontalPositioningLandscape: RealmKeyboardHorizontalPositioning?
    
    dynamic var verticalPositioningPortrait: RealmKeyboardVerticalPositioning?
    dynamic var verticalPositioningLandscape: RealmKeyboardVerticalPositioning?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name        <-  map["name"]
        alphabet    <-  (map["alphabet"], ArrayTransform<RealmKeyboardLine>())
        numbers     <-  (map["numbers"], ArrayTransform<RealmKeyboardLine>())
    }
}

extension RealmKeyboardLanguage {
    class func initWithJsonString(jsonString: String) -> RealmKeyboardLanguage? {
        return Mapper<RealmKeyboardLanguage>().map(JSONString: jsonString)
    }
}


extension RealmKeyboardLanguage {
    func precalculate(orientation: RealmKeyboardOrientation, originX: Float, width: Float, originY: Float, height: Float) {
        switch orientation {
        case .Portrait:
            horizontalPositioningPortrait = RealmKeyboardHorizontalPositioning()
            horizontalPositioningPortrait!.type = RealmKeyboardKeyPositioningType.Auto.rawValue
            horizontalPositioningPortrait!.value.value = 1
            horizontalPositioningPortrait!.precalculate(widthTotal: width, emptyTotal: 0, curX: originX)
            
            verticalPositioningPortrait = RealmKeyboardVerticalPositioning()
            verticalPositioningPortrait!.precalculate(origin: originY, height: height)
            
        case .Landscape:
            horizontalPositioningLandscape = RealmKeyboardHorizontalPositioning()
            horizontalPositioningLandscape!.type = RealmKeyboardKeyPositioningType.Auto.rawValue
            horizontalPositioningLandscape!.value.value = 1
            horizontalPositioningLandscape!.precalculate(widthTotal: width, emptyTotal: 0, curX: originX)
            
            verticalPositioningLandscape = RealmKeyboardVerticalPositioning()
            verticalPositioningLandscape!.precalculate(origin: originY, height: height)
        }
        
        let alphabetLineHeight: Float = height / Float(alphabet.count)
        let numbersLineHeight: Float = height / Float(numbers.count)
        
        var curY: Float = 0
        for line in alphabet {
            line.precalculate(orientation: orientation,
                              widthTotal: width,
                              curX: originX,
                              curY: curY,
                              height: alphabetLineHeight)
            curY += alphabetLineHeight
        }
        
        curY = 0
        for line in numbers {
            line.precalculate(orientation: orientation,
                              widthTotal: width,
                              curX: originX,
                              curY: curY,
                              height: numbersLineHeight)
            curY += numbersLineHeight
        }
    }
}






// MARK: - Convertion




//extension KeyboardLanguage {
//    init?(object: RealmKeyboardLanguage) {
//        guard
//            let name = object.name
//        else {
//            return nil
//        }
//        
//        self.name = name
//        self.alphabet = object.alphabet.toKeyboardLines()
//        self.numbers = object.numbers.toKeyboardLines()
//        self.bottom = KeyboardLine(object: object.bottom)
//        self.left = KeyboardLine(object: object.left)
//        self.right = KeyboardLine(object: object.right)
//    }
//}
