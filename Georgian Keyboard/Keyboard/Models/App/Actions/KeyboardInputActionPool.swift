//
//  KeyboardInputActionPool.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 04/11/2016.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

class KeyboardInputActionPool {
    private static var _sharedInstance: KeyboardInputActionPool!
    static var sharedInstance: KeyboardInputActionPool {
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
    
    private var delegate: UIInputViewController
    
    private init(delegate: UIInputViewController) {
        self.delegate = delegate
    }
    
    class func configure(delegate: UIInputViewController) {
        KeyboardInputActionPool._sharedInstance = KeyboardInputActionPool(delegate: delegate)
    }
    
    
    // MARK: - Helpers
    
    fileprivate var deletingTimer: Timer?
    fileprivate var deletingMultipleTimer: Timer?
    
    var proxy: UITextDocumentProxy {
        return delegate.textDocumentProxy
    }
    
    
    // MARK: - Actions
    
    func goToSystemKeyboard() {
        delegate.advanceToNextInputMode()
    }
    
    func dismissKeyboard() {
        delegate.dismissKeyboard()
    }
    
    func playInputClick() {
        delegate.inputView?.playInputClick​()
    }
    
    func insertText(_ text: String) {
        proxy.insertText(text)
    }
    
    func deleteBackward() {
        if let lastCharacter = proxy.documentContextBeforeInput?.characters.last {
            KeyboardState.sharedInstance.deleteAction(character: lastCharacter)
        }
        proxy.deleteBackward()
    }
    
    func spaceClicked() {
        var text: String = " "
        if let context = proxy.documentContextBeforeInput {
            if context.isEndOfSentence() {
                deleteBackward()
                text = ". "
            }
        }
        
        insertText(text)
    }
    
    func startDeleting() {
        startDeletingAction()
    }
    
    func endDeleting() {
        stopDeletingAction()
    }
    
    func jumpToLeft() {
        proxy.adjustTextPosition(byCharacterOffset: -1)
    }
    
    func jumpToRight() {
        proxy.adjustTextPosition(byCharacterOffset: 1)
    }
    
    func jumpToLeftWord() {
        guard let lws = proxy.documentContextBeforeInput?.lastWordSize() else {
            return
        }
        proxy.adjustTextPosition(byCharacterOffset: -lws)
    }
    
    func jumpToRightWord() {
        guard let rws = proxy.documentContextAfterInput?.jumpRightSize() else {
            return
        }
        proxy.adjustTextPosition(byCharacterOffset: rws)
    }
}


// MARK: - delete

fileprivate extension KeyboardInputActionPool {
    func startDeletingAction() {
        deleteBackward()
//        alphabet.updateShiftIfNeeded()
        
        deletingTimer = Timer.scheduledTimer(timeInterval: 0.3,
                             target: self,
                             selector: #selector(KeyboardInputActionPool.startDeletingContinously),
                             userInfo: nil,
                             repeats: false)
        
        deletingMultipleTimer = Timer.scheduledTimer(timeInterval: 2,
                                                     target: self,
                                                     selector: #selector(KeyboardInputActionPool.startDeletingContinouslyMultiple),
                                                     userInfo: nil,
                                                     repeats: false)
    }
    
    @objc private func startDeletingContinously() {
        deletingTimer?.invalidate()
        deletingTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                             target: self,
                                             selector: #selector(KeyboardInputActionPool.deleteAction),
                                             userInfo: nil,
                                             repeats: true)
    }
    
    @objc private func startDeletingContinouslyMultiple() {
        deletingTimer?.invalidate()
        deletingTimer = Timer.scheduledTimer(timeInterval: 0.4,
                                             target: self,
                                             selector: #selector(KeyboardInputActionPool.deleteMultipleAction),
                                             userInfo: nil,
                                             repeats: true)
    }
    
    @objc private func deleteAction() {
        guard let precedingContenxt = proxy.documentContextBeforeInput else {
            stopDeletingAction()
            return
        }
        if precedingContenxt.isEmpty {
            stopDeletingAction()
            return
        }
        
        deleteBackward()
        playInputClick()
//        alphabet.updateShiftIfNeeded()
    }
    
    @objc private func deleteMultipleAction() {
        deleteAction()
        
        guard let precedingContext = proxy.documentContextBeforeInput else {
            return
        }
        if precedingContext.isEmpty {
            return
        }
        
        playInputClick()
        for _ in 0..<precedingContext.lastWordSize() {
            deleteBackward()
        }
    }
    
    func stopDeletingAction() {
        deletingTimer?.invalidate()
        deletingMultipleTimer?.invalidate()
        
        deletingTimer = nil
        deletingMultipleTimer = nil
    }
    
}
