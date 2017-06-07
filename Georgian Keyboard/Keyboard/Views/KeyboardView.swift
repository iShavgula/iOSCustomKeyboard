//
//  KeyboardView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

var popup: KeyboardPopupView!

class KeyboardView: UIView, KeyboardDelegate {
    fileprivate var model: Keyboard
//    fileprivate var state: KeyboardState = KeyboardState()
    
    fileprivate var touchPool: TouchPool!
    
    fileprivate var languages: [KeyboardLanguageView] = []
    fileprivate var bottom: KeyboardLineView!
    
    fileprivate var activeLanguageIndex: Int?
    
    fileprivate var activeLanguage: KeyboardLanguageView {
        return languages[activeLanguageIndex!]
    }
    
    required init(model: Keyboard) {
        self.model = model
        super.init(frame: CGRect.zero)
        
        touchPool = TouchPool.configure(delegate: self)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        for language in model.languages {
            let language = KeyboardLanguageView(model: language)
            addSubview(language)
            languages.append(language)
        }
        
        bottom = KeyboardLineView(model: model.bottom)
        addSubview(bottom)
        
        popup = KeyboardPopupView(model: model.popup)
        
        addObservers()
    }
    
    func addObservers() {
        let actionPool = KeyboardState.sharedInstance
        
        actionPool.languageStateHandlers.append({[weak self] (idx: Int?) in
            self?.updateLanguage(idx: idx)
        })
        
        actionPool.orientationHandlers.append({[weak self] (orientation: KOrientation) in
            self?.updateOrientation(orientation: orientation)
        })
        
    }
    
    
    // MARK: - Handlers
    
    fileprivate func updateLanguage(idx: Int?) {
        let oldValue = activeLanguageIndex
        if let idx = idx {
            activeLanguageIndex = idx
        } else {
            activeLanguageIndex = activeLanguageIndex == nil ? 0 : (activeLanguageIndex! + 1) % languages.count
        }
        
        if oldValue != activeLanguageIndex {
            if oldValue != nil {
                languages[oldValue!].removeFromSuperview()
            }
            addSubview(languages[activeLanguageIndex!])
            // TODO: update frames
            reset()
        }
    }
    
    fileprivate func updateOrientation(orientation: KOrientation) {
        let info = model.info[orientation]!
        frame = CGRect(x: 0, y: 0, width: info.width.cgf, height: info.height.cgf)
        print("updated frame: \(frame)")
    }
    
    
    // MARK: - Updates
    
    fileprivate func reset() {
        
    }
    
    fileprivate func updateAll() {
        
    }
    
    
}


extension KeyboardDelegate where Self: KeyboardView {
    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView? {
        let p = touch.location(in: self)
        
        if bottom.frame.contains(p) {
            return bottom.getKeyWithTouch(touch: touch)
        }
        if languages[activeLanguageIndex!].frame.contains(p) {
            return languages[activeLanguageIndex!].getKeyWithTouch(touch: touch)
        }
        return nil
    }
}


// MARK: - Touch actions

extension KeyboardDelegate where Self: KeyboardView {
    
//   
//    
//    func advanceToThePreviousCharacter() {
//        delegate?.adjustTextPositionByCharacterOffset(-1)
//    }
//    
//    func advanceToTheNextCharacter() {
//        delegate?.adjustTextPositionByCharacterOffset(1)
//    }
//    
//    func advanceToThePreviousWord() {
//        guard let jumpLength = delegate?.documentContextBeforeInput?.jumpLeftSize() else {
//            return
//        }
//        delegate?.adjustTextPositionByCharacterOffset(-jumpLength)
//    }
//    
//    func advanceToTheNextWord() {
//        guard let jumpLength = delegate?.documentContextAfterInput?.jumpRightSize() else {
//            return
//        }
//        delegate?.adjustTextPositionByCharacterOffset(jumpLength)
//    }
}
