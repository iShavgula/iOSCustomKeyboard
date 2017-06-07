//
//  RealmTheme.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTheme: Object {
    dynamic var background: RealmThemeBackground?
    dynamic var keys: RealmThemeKeys?
}

extension RealmTheme {
    func toTheme() -> Theme? {
        guard
            let background = background?.toThemeBackground(),
            let keys = keys?.toThemeKeys() else {
                return nil
        }
        
        return Theme(background: background, keys: keys)
    }
}

extension Sequence where Iterator.Element == RealmTheme {
    func toThemes() -> [Theme] {
        var res: [Theme] = []
        for theme in self {
            guard let theme = theme.toTheme() else {
                continue
            }
            res.append(theme)
        }
        
        return res
    }
}
