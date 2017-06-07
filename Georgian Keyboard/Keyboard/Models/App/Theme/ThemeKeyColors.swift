//
//  ThemeKeyColors.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct ThemeKeyColors {
    var text: ThemeKeyColorColors
//    var disabledText: ThemeKeyColorColors
    var background: ThemeKeyColorColors
    var shadow: ThemeKeyColorColors
}

struct ThemeKeyColorColors {
    var normal: UIColor
    var highlighted: UIColor
}


// MARK: - Convertion

//extension ThemeKeyColors {
//    func toRealmThemeKeyColors() -> RealmThemeKeyColors {
//        let res = RealmThemeKeyColors()
//        res.titleNormal = text.normal.toHex()
//        res.titleHighlighted = text.highlighted.toHex()
//        
//        res.frameNormal = frame.normal.toHex()
//        res.frameHighlighted = frame.highlighted.toHex()
//        
//        res.shadowNormal = shadow.normal.toHex()
//        res.shadowHighlighted = shadow.highlighted.toHex()
//        
//        return res
//    }
//}
