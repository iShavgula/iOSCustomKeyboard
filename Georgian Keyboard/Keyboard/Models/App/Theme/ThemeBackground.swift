//
//  ThemeBackground.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

enum ThemeBackgroundType {
    case Color(UIColor)
    case Photo(UIImage, String?)
}

struct ThemeBackground {
    var type: ThemeBackgroundType
    var blur: Double
    var opacity: Double
}


// MARK: - Convertion

extension ThemeBackground {
    func toRealmThemeBackground() -> RealmThemeBackground? {
        let res: RealmThemeBackground = RealmThemeBackground()
        switch type {
        case .Color(let color):
            res.type = RealmThemeBackgroundType.Color.rawValue
            res.color = color.toHex()
            
        case .Photo(let image, let name):
            res.type = RealmThemeBackgroundType.Photo.rawValue
            if let name = name {
                res.photo = name
            } else {
                res.photo = NSUUID().uuidString
            }
            res.image = image
        }
        
        res.blur = blur
        res.opacity = opacity
        
        return res
    }
}
