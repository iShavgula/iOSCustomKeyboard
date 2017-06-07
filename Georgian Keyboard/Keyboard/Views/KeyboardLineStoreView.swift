//
//  KeyboardLineStoreView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 23/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct KeyboardLineStore {
    fileprivate var lines: [KeyboardLine]
    fileprivate var frame: [KOrientation: CGRect]
    
    init(lines: [KeyboardLine], frame: [KOrientation: CGRect]) {
        self.lines = lines
        self.frame = frame
    }
}

class KeyboardLineStoreView: UIView {
    fileprivate var model: KeyboardLineStore
    fileprivate var lines: [KeyboardLineView] = []
    
    required init(model: KeyboardLineStore) {
        self.model = model
        super.init(frame: CGRect.zero)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        for line in model.lines {
            let line = KeyboardLineView(model: line)
            addSubview(line)
            lines.append(line)
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
    
    func reset() {
        
    }
}


extension KeyboardLineStoreView {
    func getKeyWithTouch(touch: UITouch) -> KeyboardKeyView? {
        let p = touch.location(in: self)
        
        for line in lines {
            if line.frame.contains(p) {
                return line.getKeyWithTouch(touch: touch)
            }
        }
        
        return nil
    }
}
