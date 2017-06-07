//
//  Theme.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

enum ThemeAppearance {
    case Light
    case Dark
}

struct Theme {
    var background: ThemeBackground
    var keys: ThemeKeys
}

extension Theme {
    func toRealmTheme() -> RealmTheme {
        let theme = RealmTheme()
        theme.background = background.toRealmThemeBackground()
        theme.keys = keys.toRealmThemeKeys()
        
        return theme
    }
}

class ThemeFactory {
    class func defaultTheme() -> Theme {
        let backgroundColor = UIColor.clear
        let textColor = UIColor.black
//        let disabledTextColor = UIColor(red: 118/255.0, green: 121/255.0, blue: 129/255.0, alpha: 0.9)
        let lightKeyColor = UIColor.white
        let lightKeyShadowColor = UIColor(red: 137/255.0, green: 139/255.0, blue: 143/255.0, alpha: 0.9)
        let darkKeyColor = UIColor(red: 172/255.0, green: 179/255.0, blue: 188/255.0, alpha: 0.9)
        let darkKeyShadowColor = UIColor(red: 137/255.0, green: 139/255.0, blue: 143/255.0, alpha: 0.9)
        let blueKeyColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 0.9)
        let blueKeyShadowColor = UIColor(red: 105/255.0, green: 107/255.0, blue: 109/255.0, alpha: 0.9)
        
        return Theme(
            background: ThemeBackground(
                type: ThemeBackgroundType.Color(backgroundColor),
                blur: 0,
                opacity: 0),
            keys: ThemeKeys(
                frame: ThemeKeyFrame(
                    type: ThemeKeyFrameType.Fill,
                    opacity: 1.0,
                    style: 1),
                colors: [
                    .light : ThemeKeyColors(
                        text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                        background: ThemeKeyColorColors(normal: lightKeyColor, highlighted: darkKeyColor),
                        shadow: ThemeKeyColorColors(normal: darkKeyShadowColor, highlighted: lightKeyShadowColor)),
                    .dark : ThemeKeyColors(
                        text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                        background: ThemeKeyColorColors(normal: darkKeyColor, highlighted: lightKeyColor),
                        shadow: ThemeKeyColorColors(normal: lightKeyShadowColor, highlighted: darkKeyShadowColor)),
                    .blue : ThemeKeyColors(
                        text: ThemeKeyColorColors(normal: textColor, highlighted: textColor),
                        background: ThemeKeyColorColors(normal: blueKeyColor, highlighted: lightKeyColor),
                        shadow: ThemeKeyColorColors(normal: blueKeyShadowColor, highlighted: darkKeyShadowColor))],
                fontSize: [.light : 18,
                           .dark : 20,
                           .blue : 20]))
        
        
    }
}
