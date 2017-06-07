//
//  KeyboardKeyView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 17/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

struct KeyColors {
    var background: UIColor = UIColor.white
    var text: UIColor = UIColor.white
    var shadow: UIColor = UIColor.white
}

class KeyboardKeyView: UIControl {
    var model: KeyboardKey
    
    fileprivate var colors: KeyColors = KeyColors()
    var curInput: String!
    
    required init(model: KeyboardKey) {
        self.model = model
        super.init(frame: CGRect.zero)
        
        isMultipleTouchEnabled = true
        contentMode = .redraw
        backgroundColor = UIColor.white.withAlphaComponent(0.01)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        updateState()
        addSpecialButtonActions()
        addObservers()
    }
    
    func addSpecialButtonActions() {
        switch model.type {
        case .shift:
            addTarget(self, action: #selector(KeyboardKeyView.shiftLocked), for: .touchDownRepeat)
            
        case .language:
            addTarget(self, action: #selector(KeyboardKeyView.askedForSystemLanguage), for: .touchDownRepeat)
        default:
            break
        }
    }
    
    func addObservers() {
        let actionPool = KeyboardState.sharedInstance
        
        actionPool.orientationHandlers.append({[weak self] (orientation: KOrientation) in
            self?.updateOrientation(orientation: orientation)
        })
        
        actionPool.shiftStateHandlers.append({[weak self] (state: KShiftState) in
            self?.updateShiftState(state: state)
        })
        
        actionPool.shiftNumbersStateHandlers.append({[weak self] (state: KShiftNumbersState) in
            self?.updateShiftNumbersState(state: state)
        })
    }
    
    
    // MARK: - Special button actions
    
    func shiftLocked() {
        KeyboardState.sharedInstance.doubleShiftAction()
    }
    
    func askedForSystemLanguage() {
        KeyboardInputActionPool.sharedInstance.goToSystemKeyboard()
    }
    
    
    // MARK: - Handlers
    
    fileprivate func updateOrientation(orientation: KOrientation) {
        frame = model.frame[orientation]!
        
        setNeedsDisplay()
    }
    
    fileprivate func updateShiftState(state: KShiftState) {
        switch model.type {
        case .none:
            if model.isAlphabetKey {
                switch state {
                case .disabled:
                    curInput = model.input
                    
                default:
                    curInput = model.shiftInput
                }
                
                setNeedsDisplay()
            }
            
        case .shift:
            switch state {
            case .disabled:
                isHighlighted = false
                
            default:
                isHighlighted = true
            }
            
        default:
            break
        }
    }
    
    fileprivate func updateShiftNumbersState(state: KShiftNumbersState) {
        switch model.type {
        case .none:
            if !model.isAlphabetKey {
                switch state {
                case .disabled:
                    curInput = model.input
                    
                case .enabled:
                    curInput = model.shiftInput
                }
                
                setNeedsDisplay()
            }
            
        case .shiftNumbers:
            setNeedsDisplay()
            
        default:
            break
        }
    }
}

extension KeyboardKeyView {
    override var isHighlighted: Bool {
        didSet {
            if !model.canHiglight && isHighlighted {
                isHighlighted = false
            } else {
                updateState()
            }
            
            // add popup here
        }
    }
    
    fileprivate var drawableArea: CGRect {
        let orientation = KeyboardState.sharedInstance.orientation!
        
        let insetLeft = model.insetLeft[orientation]!
        let insetRight = model.insetRight[orientation]!
        
        let info = KeyboardState.sharedInstance.info[orientation]!
        
        let horizontalInset = info.horizontalInset.cgf
        let verticalInset = info.verticalInset.cgf
        
        let insets: CGFloat = insetLeft + insetRight
        let sz: CGSize = model.frame[orientation]!.size
        
        return CGRect(origin: CGPoint(x: horizontalInset + insetLeft,
                                      y: verticalInset),
                      size: CGSize(width: sz.width - 2 * horizontalInset - insets,
                                   height: sz.height - 2 * verticalInset))
    }
    
    
}

extension KeyboardKeyView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchPool.sharedInstance.touchesBegan(touches: touches)
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchPool.sharedInstance.touchesMoved(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchPool.sharedInstance.touchesEnded(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchPool.sharedInstance.touchesCancelled(touches: touches)
    }
}

fileprivate extension KeyboardKeyView {
    func updateState() {
        let themeColors = KeyboardState.sharedInstance.theme.keys.colors[model.style]!
        
        // Text Color
        switch state {
        case UIControlState.highlighted:
            colors.text = themeColors.text.highlighted
            colors.background = themeColors.background.highlighted
            colors.shadow = themeColors.shadow.highlighted
            
        case UIControlState.disabled:
            colors.text = themeColors.text.normal.withAlphaComponent(0.5)
            colors.background = themeColors.background.normal
            colors.shadow = themeColors.shadow.normal
            
        default:
            colors.text = themeColors.text.normal
            colors.background = themeColors.background.normal
            colors.shadow = themeColors.shadow.normal
        }
        
        setNeedsDisplay()
    }
}

extension KeyboardKeyView {
    override func draw(_ rect: CGRect) {
        let themeFrame = KeyboardState.sharedInstance.theme.keys.frame
        let themeFontSize = KeyboardState.sharedInstance.theme.keys.fontSize[model.style]!
        KeyboardKeyDrawing.method(index: themeFrame.style, rect: rect, drawableArea: drawableArea, colors: colors, input: curInput, fontSize: themeFontSize)
    }
}


/*
 enum KeyShape: String {
 case Shift = "shift"
 case Delete = "delete"
 case Globe = "globe"
 case None = "none"
 }*/
