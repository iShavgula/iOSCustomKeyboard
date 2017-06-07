//
//  KeyTouchPool.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 23/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

//protocol TouchPoolDelegate {
//    func updatePadState(state: KeyboardState?)
//    func updateLanguage(idx: Int?)
//    func endedShift()
//    func endedShiftWithText()
//    func endedShiftNumbers()
//    func endedShiftNumbersWithText()
//    func didAskForEmoji(value :Bool)
//    
//    func playInputClick()
//    func insertText(text: String)
//    func spaceClicked()
//    func gotoSystemKeyboard()
//    func startDeleting()
//    func stopDeleting()
//    
//    func advanceToThePreviousCharacter()
//    func advanceToTheNextCharacter()
//    
//    func advanceToThePreviousWord()
//    func advanceToTheNextWord()
////
//    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView?
//}

protocol KeyboardDelegate {
    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView?
}

class TouchPool {
    private static var _sharedInstance: TouchPool!
    static var sharedInstance: TouchPool! {
        get {
            if _sharedInstance == nil {
                fatalError("First call configure function with delegate")
            }
            return _sharedInstance
        }
        set {
            _sharedInstance = sharedInstance
        }
    }
    
    private var actions: TouchActions!
    
    private init(delegate: KeyboardDelegate) {
        actions = TouchActions(delegate: delegate)
    }
    
    class func configure(delegate: KeyboardDelegate) -> TouchPool {
        TouchPool._sharedInstance = TouchPool(delegate: delegate)
        return TouchPool.sharedInstance
    }
    
    
    
    var curTouch: UITouch!
    var prevTouch: UITouch?
    
    func touchesBegan(touches: Set<UITouch>) {
        if let firstTouch = touches.first {
            if let prevTouch = prevTouch {
                touchesEnded(touches: [prevTouch])
            }
            prevTouch = curTouch
            
            curTouch = firstTouch
            actions.touchBegan(touch: firstTouch)
        }
    }
    
    func touchesMoved(touches: Set<UITouch>) {
        if let firstTouch = touches.first {
            if firstTouch == curTouch {
                actions.touchMoved(touch: firstTouch)
            }
        }
    }
    
    func touchesEnded(touches: Set<UITouch>) {
        if let firstTouch = touches.first {
            if firstTouch == curTouch {
                actions.touchEnded()
            }
        }
    }
    
    func touchesCancelled(touches: Set<UITouch>) {
        touchesEnded(touches: touches)
    }
}


class TouchActions {
    private let inputActions = KeyboardInputActionPool.sharedInstance
    private let actions = KeyboardState.sharedInstance
    
    private var delegate: KeyboardDelegate!
    
    private var firstKey: KeyboardKeyView!
    private var lastKey: KeyboardKeyView?
    
    init(delegate: KeyboardDelegate) {
        self.delegate = delegate
    }
    
    func touchBegan(touch: UITouch) {
        inputActions.playInputClick()
        
        // Force finish previous touches
        touchEnded()
        
        let key = touch.view as! KeyboardKeyView
        firstKey = key
        lastKey = key.model.type == .none || key.model.type == .space ? key : nil
        
        processTouchStarted()
    }
    
    func touchMoved(touch: UITouch) {
        if lastKey != nil && !lastKey!.bounds.contains(touch.location(in: lastKey)) {
            lastKey!.isHighlighted = false
            
        }
        
        if firstKey.model.type == .delete {
            return
        }
        
        if let key = delegate.getKeyWithTouch(touch: touch) {
            lastKey = key.model.type == .none || key.model.type == .space ? key : lastKey
        }
        
        guard let lastKey = lastKey else {
            return
        }
        
        if lastKey.bounds.contains(touch.location(in: lastKey)) {
            lastKey.isHighlighted = true
        } else {
            lastKey.isHighlighted = false
        }
    }
    
    func touchEnded() {
        guard firstKey != nil else {
            return
        }
        
        firstKey?.isHighlighted = false
        lastKey?.isHighlighted = false
        
        proccessTouchEnded()
    }
    
    func processTouchStarted() {
        firstKey.isHighlighted = true
        
        switch firstKey.model.type {
        case .delete:
            inputActions.startDeleting()
            
        case .language:
            actions.languageAction()
            
        case .numbers:
            actions.padAction()
            
        case .returnn:
            inputActions.insertText("\n")
            
        case .shift:
            actions.shiftAction()
            
        case .shiftNumbers:
            actions.shiftNumbersAction()
            
        case .shiftLeft:
            inputActions.jumpToLeft()
            
        case .shiftRight:
            inputActions.jumpToRight()
            
        case .doubleShiftLeft:
            inputActions.jumpToLeftWord()
            
        case .doubleShiftRight:
            inputActions.jumpToRightWord()
            
        case .dismiss:
            inputActions.dismissKeyboard()
            
        default:
            break
        }
    }
    
    func proccessTouchEnded() {
        func finalize() {
            self.firstKey = nil
            self.lastKey = nil
        }
        
        switch firstKey.model.type {
        case .delete:
            inputActions.endDeleting()
            finalize()
            return
            
        case .shift:
            switch KeyboardState.sharedInstance.shiftState! {
            case .disabled:
                firstKey.isHighlighted = false
                
            default:
                firstKey.isHighlighted = true
            }
            
        case .shiftNumbers:
            switch KeyboardState.sharedInstance.shiftNumbersState! {
            case .disabled:
                firstKey.isHighlighted = false
                
            case.enabled:
                firstKey.isHighlighted = true
            }
            
        default:
            break
        }
        
        guard let lastKey = lastKey else {
            finalize()
            return
        }
        
        var shouldChangePadState: Bool = false
        
        switch lastKey.model.type {
        case .none:
            if lastKey.curInput == "'" {
                shouldChangePadState = true
            }
            
            inputActions.insertText(lastKey.curInput)
            if firstKey.model.type != .shift {
                actions.keyEnterAction()
            }
            
        case .space:
            let lastCharacter = inputActions.proxy.documentContextBeforeInput?.characters.last
            if [".", ",", "?", "!", "'"].contains(lastCharacter ?? " ") && KeyboardState.sharedInstance.padState == KPadState.numbers {
                shouldChangePadState = true
            }
            
            inputActions.spaceClicked()
            
        default:
            fatalError("lastKey can't have a type other than .none or .space")
        }
        
        
        
        switch firstKey.model.type {
        case .shift:
            actions.shiftAction()
            
        case .shiftNumbers:
            actions.shiftNumbersAction()
            
        case .numbers:
            shouldChangePadState = true
            
        case .language:
            actions.languageAction()
         
        default:
            break
        }
        
        if shouldChangePadState {
            actions.padAction()
        }
        
        finalize()
    }
}
