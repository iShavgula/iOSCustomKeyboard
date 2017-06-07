//
//  Keyboard.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct Keyboard {
    var info: [KOrientation: KeyboardInfo]
    
    var languages: [KeyboardLanguage]
    var bottom: KeyboardLine
    
    var popup: KeyboardPopup
}

extension Keyboard {
    init?(object: RealmKeyboard) {
        guard
            let infoPortrait = object.portraitInfo,
            let infoLandscape = object.landscapeInfo
        else {
            return nil
        }
        
        info = [:]
        info[.portrait] = KeyboardInfo(object: infoPortrait)
        info[.landscape] = KeyboardInfo(object: infoLandscape)
        KeyboardState.sharedInstance.info = info
        
        languages = []
        for languageObject in object.languages {
            guard let language = KeyboardLanguage(object: languageObject) else {
                return nil
            }
            languages.append(language)
        }
        
        guard let objectBottom = object.bottom else {
            return nil
        }
        guard let line = KeyboardLine(object: objectBottom, isAlphabetLine: false) else {
            return nil
        }
        bottom = line
        
        
        popup = KeyboardPopup(size: [
            .portrait: CGSize(width: info[.portrait]!.width.cgf, height: info[.portrait]!.height.cgf),
            .landscape: CGSize(width: info[.landscape]!.width.cgf, height: info[.landscape]!.height.cgf)
            ],
                              height: [
                                .portrait: info[.portrait]!.height.cgf / 4 + 50, // sugg height,
                                .landscape: info[.landscape]!.height.cgf / 4 + 50 // sugg height,
                                ])
    }
}
