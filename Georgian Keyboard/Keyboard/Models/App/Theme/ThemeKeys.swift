//
//  ThemeKey.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct ThemeKeys {
    var frame: ThemeKeyFrame
    var colors: [KKeyStyle: ThemeKeyColors]
    var fontSize: [KKeyStyle: CGFloat]
}

// MARK: - Convertion

extension ThemeKeys {
    func toRealmThemeKeys() -> RealmThemeKeys? {
        let res = RealmThemeKeys()
        res.frame = frame.toRealmThemeKeyFrame()
        
        guard
            let light = colors[.light],
            let dark = colors[.dark],
            let blue = colors[.blue],
            let lightFontSize = fontSize[.light],
            let darkFontSize = fontSize[.dark],
            let blueFontSize = fontSize[.blue]
        else {
            return nil
        }
        
        res.text = light.text.normal.toHex()
        
        res.lightBackground = light.background.normal.toHex()
        res.lightShadow = light.shadow.normal.toHex()
        
        res.darkBackground = dark.background.normal.toHex()
        res.darkShadow = dark.shadow.normal.toHex()
        
        res.blueBackground = blue.background.normal.toHex()
        res.blueShadow = blue.shadow.normal.toHex()
        
        res.lightFontSize = lightFontSize.f
        res.darkFontSize = darkFontSize.f
        res.blueFontSize = blueFontSize.f
        
        return res
    }
}
