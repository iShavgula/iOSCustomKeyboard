//
//  RealmThemeKeyFrame.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmThemeKeyFrame: Object {
    dynamic var style: Int = 1
    dynamic var type: String = RealmThemeKeyFrameType.Fill.rawValue
    dynamic var opacity: Double = 1
}

enum RealmThemeKeyFrameType: String {
    case Stroke = "stroke"
    case Fill = "fill"
}


// MARK: - Convertion

extension RealmThemeKeyFrame {
    func toThemeKeyFrame() -> ThemeKeyFrame? {
        guard let type = toThemeKeyFrameType() else {
            return nil
        }
        
        return ThemeKeyFrame(type: type, opacity: opacity, style: style)
    }
}

fileprivate extension RealmThemeKeyFrame {
    func toThemeKeyFrameType() -> ThemeKeyFrameType? {
        switch type {
        case RealmThemeKeyFrameType.Fill.rawValue:
            return ThemeKeyFrameType.Fill
            
        case RealmThemeKeyFrameType.Stroke.rawValue:
            return ThemeKeyFrameType.Stroke
            
        default:
            return nil
        }
    }
}
