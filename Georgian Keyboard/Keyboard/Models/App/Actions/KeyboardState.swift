//
//  KeyboardState.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 18/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit


enum KShiftState {
    case disabled
    case enabled
    case locked
}

enum KShiftNumbersState {
    case disabled
    case enabled
}

enum KPadState {
    case alphabet
    case numbers
}

enum KOrientation {
    case portrait
    case landscape
}


class KeyboardState {
    static var sharedInstance = KeyboardState()
    private init() {}
    
    class func reset() {
        KeyboardState.sharedInstance = KeyboardState()
    }
    
    
    // MARK: - Action Handlers
    
    var orientationHandlers: [(_ orientation: KOrientation) -> Void] = []
    var languageStateHandlers: [(_ active: Int?) -> Void] = []
    var padStateHandlers: [(_ state: KPadState) -> Void] = []
    var shiftStateHandlers: [(_ state: KShiftState) -> Void] = []
    var shiftNumbersStateHandlers: [(_ state: KShiftNumbersState) -> Void] = []
    
    
//    var _info: [KOrientation: KeyboardInfo] = [:]
//    var info: KeyboardInfo {
//        return _info[orientation]!
//    }
    
    // MARK: - States
    
    var theme = ThemeFactory.defaultTheme()
    
    var info: [KOrientation: KeyboardInfo]!
    
    var orientation: KOrientation! {
        didSet {
//            if orientation != oldValue {
                for handler in orientationHandlers {
                    handler(orientation)
                }
//            }
        }
    }
    
    var  activeLanguage: Int? {
        didSet {
            for handler in languageStateHandlers {
                handler(activeLanguage)
            }
            
            self.shiftState = .disabled
            self.shiftNumbersState = .disabled
            self.padState = .alphabet
        }
    }
    
    var padState: KPadState! {
        didSet {
            if padState != oldValue {
                for handler in padStateHandlers {
                    handler(padState)
                }
            }
        }
    }
    
    var shiftState: KShiftState! {
        didSet {
            if shiftState != oldValue {
                for handler in shiftStateHandlers {
                    handler(shiftState)
                }
            }
        }
    }
    
    var shiftNumbersState: KShiftNumbersState! {
        didSet {
            if shiftNumbersState != oldValue {
                for handler in shiftNumbersStateHandlers {
                    handler(shiftNumbersState)
                }
            }
        }
    }
    
    
    // MARK: - Actions
    
    func deleteAction(character: Character) {
        switch shiftState! {
        case .locked:
            return
            
        case .disabled:
            if ("A"..."Z").contains(character) {
                shiftState = KShiftState.enabled
            }
            
        case .enabled:
            if !("A"..."Z").contains(character) {
                shiftState = KShiftState.disabled
            }
        }
        
        if ("A"..."Z").contains(character) {
            if shiftState != KShiftState.locked {
                shiftState = KShiftState.enabled
            }
        }
    }
    
    func keyEnterAction() {
        if shiftState == KShiftState.enabled {
            shiftState = KShiftState.disabled
        }
    }
    
    func languageAction() {
        activeLanguage = nil
    }
    
    func padAction() {
        switch padState! {
        case .alphabet:
            padState = .numbers
            
        case .numbers:
            padState = .alphabet
        }
    }
    
    func shiftAction() {
        switch shiftState! {
        case .disabled:
            shiftState = .enabled
            
        default:
            shiftState = .disabled
        }
    }
    
    func doubleShiftAction() {
        shiftState = .locked
    }
    
    func shiftNumbersAction() {
        switch shiftNumbersState! {
        case .disabled:
            shiftNumbersState = .enabled
            
        case .enabled:
            shiftNumbersState = .disabled
        }
    }
}



//struct KeyboardState {
//    // TODO: fix
//    var theme: Theme = ThemeFactory.defaultTheme()
//    var orientation: Orientation = Orientation.Portrait
//    var language: Int = 0
//    
//    var padState: KeyboardLanguagePadType = .alphabet
//    var shiftState: KeyboardShiftState = .disabled
//}
