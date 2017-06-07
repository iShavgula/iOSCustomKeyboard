//
//  RealmThemeKey.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit
import RealmSwift

class RealmThemeKeys: Object {
    dynamic var frame: RealmThemeKeyFrame?
    
    dynamic var text: Int64 = 0
    
    dynamic var lightBackground: Int64 = 0
    dynamic var lightShadow: Int64 = 0
    
    dynamic var darkBackground: Int64 = 0
    dynamic var darkShadow: Int64 = 0
    
    dynamic var blueBackground: Int64 = 0
    dynamic var blueShadow: Int64 = 0
    
    dynamic var lightFontSize: Float = 10
    dynamic var darkFontSize: Float = 10
    dynamic var blueFontSize: Float = 10
}


// MARK: - Convertion

extension RealmThemeKeys {
    func toThemeKeys() -> ThemeKeys? {
        let textColor = UIColor(hex: text)
        
        let lightBackgroundColor = UIColor(hex: lightBackground)
        let lightShadowColor = UIColor(hex: lightShadow)
        
        let darkBackgroundColor = UIColor(hex: darkBackground)
        let darkShadowColor = UIColor(hex: darkShadow)
        
        let blueBackgroundColor = UIColor(hex: blueBackground)
        let blueShadowColor = UIColor(hex: blueShadow)
        
        
        let light = ThemeKeyColors(text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                                   background: ThemeKeyColorColors(normal: lightBackgroundColor, highlighted: darkBackgroundColor),
                                   shadow: ThemeKeyColorColors(normal: lightShadowColor, highlighted: darkShadowColor))
        
        let dark = ThemeKeyColors(text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                                   background: ThemeKeyColorColors(normal: darkBackgroundColor, highlighted: lightBackgroundColor),
                                   shadow: ThemeKeyColorColors(normal: darkShadowColor, highlighted: lightShadowColor))
        
        let blue = ThemeKeyColors(text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                                  background: ThemeKeyColorColors(normal: blueBackgroundColor, highlighted: lightBackgroundColor),
                                  shadow: ThemeKeyColorColors(normal: blueShadowColor, highlighted: lightShadowColor))
        
        guard let frame = frame?.toThemeKeyFrame() else {
                return nil
        }
        
        return ThemeKeys(frame: frame,
                         colors: [
                            .light: light,
                            .dark: dark,
                            .blue: blue],
                         fontSize: [
                            .light: lightFontSize.cgf,
                            .dark: darkFontSize.cgf,
                            .blue: blueFontSize.cgf])
    }
}


//extension RealmThemeKeys {
//    func toThemeKeys() -> ThemeKeys? {
//        guard
//            let frame = frame?.toThemeKeyFrame(),
//            let light = light?.toThemeKeyColors(),
//            let dark = dark?.toThemeKeyColors(),
//            let blue = blue?.toThemeKeyColors() else {
//                return nil
//        }
//        
//        return ThemeKeys(frame: frame,
//                         colors: [
//                            .Light: light,
//                            .Dark: dark,
//                            .Blue: blue
//            ])
//    }
//}
