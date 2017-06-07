//
//  RealmKeyboardLine.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class RealmKeyboardLine: Object, Mappable {
    dynamic var index: Int = 0
    var keys = List<RealmKeyboardKey>()
    
    dynamic var horizontalPositioningPortrait: RealmKeyboardHorizontalPositioning?
    dynamic var horizontalPositioningLandscape: RealmKeyboardHorizontalPositioning?
    
    dynamic var verticalPositioningPortrait: RealmKeyboardVerticalPositioning?
    dynamic var verticalPositioningLandscape: RealmKeyboardVerticalPositioning?
    
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        index                   <-  map["index"]
        keys                    <-  (map["keys"], ArrayTransform<RealmKeyboardKey>())
        horizontalPositioningPortrait     <- map["positioning_portrait"]
        horizontalPositioningLandscape    <- map["positioning_landscape"]
    }
}

extension RealmKeyboardLine {
    class func initWithJsonString(jsonString: String) -> RealmKeyboardLine? {
        return Mapper<RealmKeyboardLine>().map(JSONString: jsonString)
    }
}


extension RealmKeyboardLine {
    func precalculate(orientation: RealmKeyboardOrientation, widthTotal: Float, curX: Float, curY: Float, height: Float) {
        var orientationPositioning: RealmKeyboardHorizontalPositioning?
        
        switch orientation {
        case RealmKeyboardOrientation.Portrait:
            verticalPositioningPortrait = RealmKeyboardVerticalPositioning()
            verticalPositioningPortrait?.precalculate(origin: curY, height: height)
            orientationPositioning = horizontalPositioningPortrait
            
        case RealmKeyboardOrientation.Landscape:
            verticalPositioningLandscape = RealmKeyboardVerticalPositioning()
            verticalPositioningLandscape?.precalculate(origin: curY, height: height)
            orientationPositioning = horizontalPositioningLandscape
        }
        
        
        guard let positioning = orientationPositioning else {
            print("Coudln't find positioning for 'line'")
            return
        }
        
        positioning.precalculate(widthTotal: widthTotal, emptyTotal: 0, curX: curX)
        
        let keysWidth: Float = positioning.width
        let keysWidthTotalKnown: Float = keys.reduce(0) { $0 + $1.knownWidth(orientation: orientation, totalWidth: keysWidth) }
        let keysEmptyTotal = keysWidth - keysWidthTotalKnown
        
        var curX: Float = 0
        for key in keys.sorted(by: { $0.index < $1.index }) {
            key.precalculate(orientation: orientation, widthTotal: keysWidth, emptyTotal: keysEmptyTotal, curX: curX)
            curX += key.calculatedWidth(orientation: orientation)
        }
    }
}





// MARK: - Convertion

//extension KeyboardLine {
//    init?(object: RealmKeyboardLine?) {
//        guard let object = object else {
//            return nil
//        }
//        
//        guard let positioning = KeyboardPositioning(object: object.positioning) else {
//            return nil
//        }
//        
//        self.keys = object.keys.toKeyboardKeys()
//        self.positioning = positioning
//    }
//}
//
//
//extension Sequence where Iterator.Element: RealmKeyboardLine {
//    func toKeyboardLines() -> [KeyboardLine] {
//        var res: [KeyboardLine] = []
//        for one in self {
//            guard let line = KeyboardLine(object: one) else {
//                continue
//            }
//            res.append(line)
//        }
//        
//        return res
//    }
//}
