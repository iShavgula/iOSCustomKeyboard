//
//  KeyboardLineView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

class KeyboardLineView: UIView {
    fileprivate var model: KeyboardLine
    
    fileprivate var keys: [KeyboardKeyView] = []
    
    required init(model: KeyboardLine) {
        self.model = model
        super.init(frame: CGRect.zero)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        for key in model.keys {
            let key = KeyboardKeyView(model: key)
            addSubview(key)
            keys.append(key)
        }
        addObservers()
    }
    
    func addObservers() {
        let actionPool = KeyboardState.sharedInstance
        
        actionPool.orientationHandlers.append({[weak self] (orientation: KOrientation) in
            self?.updateOrientation(orientation: orientation)
        })
    }
    
    
    // MARK: - Handlers
    
    fileprivate func updateOrientation(orientation: KOrientation) {
        frame = model.frame[orientation]!
    }
}


extension KeyboardLineView {
    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView? {
        let p = touch.location(in: self)
        
        for key in keys {
            if key.frame.contains(p) {
                return key
            }
        }
        
        return nil
    }
}
