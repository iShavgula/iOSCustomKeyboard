//
//  ThemeKeyFrame.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct ThemeKeyFrame {
    var type: ThemeKeyFrameType
    var opacity: Double
    var style: Int
}

enum ThemeKeyFrameType: String {
    case Stroke = "stroke"
    case Fill = "fill"
}


// MARK: - Convertion

extension ThemeKeyFrame {
    func toRealmThemeKeyFrame() -> RealmThemeKeyFrame {
        let res = RealmThemeKeyFrame()
        
        res.type = type.rawValue
        res.style = style
        res.opacity = opacity
        
        return res
    }
}
