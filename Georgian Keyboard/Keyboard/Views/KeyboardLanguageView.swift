//
//  KeyboardLanguageView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

class KeyboardLanguageView: UIView {
    fileprivate var model: KeyboardLanguage
    
    fileprivate var alphabet: KeyboardLineStoreView!
    fileprivate var numbers: KeyboardLineStoreView!
    
    required init(model: KeyboardLanguage) {
        self.model = model
        super.init(frame: CGRect.zero)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        alphabet = KeyboardLineStoreView(model: KeyboardLineStore(lines: model.alphabet, frame: model.frame))
        addSubview(alphabet)
        numbers = KeyboardLineStoreView(model: KeyboardLineStore(lines: model.numbers, frame: model.frame))
        addSubview(numbers)
        
        addObservers()
    }
    
    
    func addObservers() {
        let actionPool = KeyboardState.sharedInstance
        
        actionPool.orientationHandlers.append({[weak self] (orientation: KOrientation) in
            self?.updateOrientation(orientation: orientation)
        })
        
        actionPool.padStateHandlers.append({[weak self] (padState: KPadState) in
            self?.updatePadState(padState: padState)
        })
        
    }
    
    
    // MARK: - Handlers
    
    fileprivate func updateOrientation(orientation: KOrientation) {
        frame = model.frame[orientation]!
    }
    
    fileprivate func updatePadState(padState: KPadState) {
        switch padState {
        case .alphabet:
            alphabet.reset()
            alphabet.isHidden = false
            numbers.isHidden = true
            
        case .numbers:
            numbers.reset()
            alphabet.isHidden = true
            numbers.isHidden = false
        }
    }
}


extension KeyboardLanguageView {
    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView? {
        let p = touch.location(in: self)
        
        switch KeyboardState.sharedInstance.padState! {
        case .alphabet:
            if alphabet.frame.contains(p) {
                return alphabet.getKeyWithTouch(touch: touch)
            }
            
        case .numbers:
            if numbers.frame.contains(p) {
                return numbers.getKeyWithTouch(touch: touch)
            }
        }
        
        return nil
    }
}
