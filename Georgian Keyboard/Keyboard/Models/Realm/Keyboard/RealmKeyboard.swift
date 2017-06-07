//
//  RealmKeyboard.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 15/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import JASON

enum RealmKeyboardOrientation: String {
    case Portrait = "portrait"
    case Landscape = "landscape"
}

class RealmKeyboard: Object, Mappable {
    dynamic var portraitInfo: RealmKeyboardInfo?
    dynamic var landscapeInfo: RealmKeyboardInfo?
    
    var languages = List<RealmKeyboardLanguage>()
    dynamic var bottom: RealmKeyboardLine?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        portraitInfo    <-  map["portrait_info"]
        landscapeInfo   <-  map["landscape_info"]
        languages       <-  (map["languages"], ArrayTransform<RealmKeyboardLanguage>())
        bottom          <-  map["bottom"]
    }
}

extension RealmKeyboard {
    class func initWithJsonString(jsonString: String) -> RealmKeyboard? {
        return Mapper<RealmKeyboard>().map(JSONString: jsonString)
    }
}

extension RealmKeyboard {
    func precalculate() {
        guard
            let portraitInfo = portraitInfo,
            let landscapeInfo = landscapeInfo
        else {
            print("Couldn't find keyboard info")
            return
        }
        
        let botLineHeightPortrait: Float = portraitInfo.height / 4
        let topLineHeightPortrait: Float = portraitInfo.height - botLineHeightPortrait
        let botLineHeightLandscape: Float = landscapeInfo.height / 4
        let topLineHeightLandscape: Float = landscapeInfo.height - botLineHeightLandscape
        
        for language in languages {
            language.precalculate(orientation: RealmKeyboardOrientation.Portrait,
                                  originX: 0,
                                  width: portraitInfo.width,
                                  originY: 0,
                                  height: topLineHeightPortrait)
            
            language.precalculate(orientation: RealmKeyboardOrientation.Landscape,
                                  originX: 0,
                                  width: landscapeInfo.width,
                                  originY: 0,
                                  height: topLineHeightLandscape)
        }
        
        bottom?.precalculate(orientation: RealmKeyboardOrientation.Portrait,
                             widthTotal: portraitInfo.width,
                             curX: 0,
                             curY: topLineHeightPortrait,
                             height: botLineHeightPortrait)
        
        bottom?.precalculate(orientation: RealmKeyboardOrientation.Landscape,
                             widthTotal: landscapeInfo.width,
                             curX: 0,
                             curY: topLineHeightLandscape,
                             height: botLineHeightLandscape)
    }
}
