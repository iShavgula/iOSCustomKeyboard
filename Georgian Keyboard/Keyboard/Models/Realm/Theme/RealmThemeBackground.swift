//
//  RealmBackgroundTheme.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmThemeBackground: Object {
    dynamic var type: String = RealmThemeBackgroundType.Color.rawValue
    dynamic var blur: Double = 0
    dynamic var opacity: Double = 1
    dynamic var color: Int64 = 0
    dynamic var photo: String?
    
    var image: UIImage?
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
}

enum RealmThemeBackgroundType: String {
    case Color = "color"
    case Photo = "photo"
}



// MARK: - Convertion

extension RealmThemeBackground {
    func toThemeBackground() -> ThemeBackground? {
        guard let type = toThemeBackgroundType() else {
            return nil
        }
        
        return ThemeBackground(type: type,
                               blur: blur,
                               opacity: opacity)
    }
}

fileprivate extension RealmThemeBackground {
    func toThemeBackgroundType() -> ThemeBackgroundType? {
        switch type {
        case RealmThemeBackgroundType.Color.rawValue:
            return ThemeBackgroundType.Color(UIColor(hex: color))
            
        case RealmThemeBackgroundType.Photo.rawValue:
            guard let photo = photo else {
                return nil
            }
            guard let image = ImageUtilities.backgroundImage(name: photo) else {
                return nil
            }
            return ThemeBackgroundType.Photo(image, photo)
            
        default:
            return nil
        }
    }
}

