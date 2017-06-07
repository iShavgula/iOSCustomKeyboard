//
//  KeyboardPopupView.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/03/2017.
//  Copyright © 2017 Giorgi Shavgulidze. All rights reserved.
//

import UIKit
import TurtleBezierPath

private enum Position {
    case none
    case left
    case middle
    case right
}

class KeyboardPopupView: UIView {
    
    fileprivate var model: KeyboardPopup
    
    fileprivate var height: CGFloat!
    
    fileprivate var position: Position = Position.none
    fileprivate var horOffset: CGFloat = 13
    
    fileprivate var minorRadius: CGFloat!
    fileprivate var majorRadius: CGFloat!
    
    fileprivate var keyFrame: CGRect!
    
    init(model: KeyboardPopup) {
        self.model = model
        
        super.init(frame: CGRect.zero)
        
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialise() {
        backgroundColor = UIColor.yellow
        
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
        frame.size = model.size[orientation]!
        height = model.height[orientation]!
    }
    
    func update(keyFrame: CGRect, cornerRadius: CGFloat = 5) {
        self.keyFrame = keyFrame
        self.minorRadius = cornerRadius
        
        self.majorRadius = 2 * minorRadius
        
        updatePosition()
        let m = CAShapeLayer()
        m.path = maskPath().cgPath
        layer.mask = m
    }
    
    fileprivate func updatePosition() {
        if keyFrame == CGRect.zero {
            position = .none
            return
        }
        
        if keyFrame.minX - horOffset < 0 {
            position = .left
            return
        }
        
        if keyFrame.maxX + horOffset > bounds.maxX {
            position = .right
            return
        }
        
        position = .middle
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension KeyboardPopupView {
    func draw() {
        
        func drawMid() {
            
        }
        
        func drawLeft() {
            
        }
        
        func drawRight() {
            
        }
        
        switch position {
        case .none:
            return
            
        case .middle:
            drawMid()
            
        case .left:
            drawLeft()
            
        case .right:
            drawRight()
        }
        
        
        
    }
}

extension KeyboardPopupView {
    func maskPath() -> UIBezierPath {
        let lowerWidth = keyFrame.width
        let upperWidth = keyFrame.width + 2 * horOffset
        let keyHeight = keyFrame.height
        
        var diagonalLineLength: CGFloat
        var diagonalLineHeight: CGFloat
        
        //
        let x: CGFloat = 1.0 - 1.0 / sqrt(2.0)
        
        let path = TurtleBezierPath()
        path.home()
        path.lineWidth = 0
        path.lineCapStyle = .round
        
        switch position {
        case .none:
            break
            
        case .middle:
            diagonalLineLength = get45DegreedLineLength(forRadius: majorRadius, andWidth: horOffset)
            diagonalLineHeight = get45DegreedLineheight(length: diagonalLineLength)
            
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyHeight - (1 + x) * majorRadius)
            path.rightArc(majorRadius, turn: 45)
            path.forward(height - majorRadius * (1 + x) - minorRadius - keyHeight - diagonalLineHeight)
            path.rightArc(minorRadius, turn: 90)
            path.forward(lowerWidth - 2 * minorRadius)
            path.rightArc(minorRadius, turn: 90)
            path.forward(height - majorRadius * (1 + x) - minorRadius - keyHeight - diagonalLineHeight)
            path.leftArc(majorRadius, turn: 45)
            path.forward(diagonalLineLength)
            path.rightArc(majorRadius, turn: 45)
            
            let offsetX = keyFrame.midX - path.bounds.midX
            let offsetY = keyFrame.maxY - path.bounds.height + majorRadius
            
            path.apply(.init(translationX: offsetX, y: offsetY))
            
        case .left:
            diagonalLineLength = get45DegreedLineLength(forRadius: majorRadius, andWidth: 2 * horOffset)
            diagonalLineHeight = get45DegreedLineheight(length: diagonalLineLength)
            
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyHeight - (1 + x) * majorRadius)
            path.rightArc(majorRadius, turn: 45)
            path.forward(diagonalLineLength)
            path.leftArc(majorRadius, turn: 45)
            path.forward(height - majorRadius * (1 + x) - minorRadius - keyHeight - diagonalLineHeight)
            path.rightArc(minorRadius, turn: 90)
            path.forward(path.currentPoint.x - minorRadius)
            path.rightArc(minorRadius, turn: 90)
            
            let offsetX = keyFrame.maxX - path.bounds.width
            let offsetY = keyFrame.maxY - path.bounds.height - path.bounds.minY
            
            path.apply(CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: -offsetX - path.bounds.width, y: offsetY))
            
        case .right:
            diagonalLineLength = get45DegreedLineLength(forRadius: majorRadius, andWidth: 2 * horOffset)
            diagonalLineHeight = get45DegreedLineheight(length: diagonalLineLength)
            
            path.rightArc(majorRadius, turn: 90)
            path.forward(upperWidth - 2 * majorRadius)
            path.rightArc(majorRadius, turn: 90)
            path.forward(keyHeight - (1 + x) * majorRadius)
            path.rightArc(majorRadius, turn: 45)
            path.forward(diagonalLineLength)
            path.leftArc(majorRadius, turn: 45)
            path.forward(height - majorRadius * (1 + x) - minorRadius - keyHeight - diagonalLineHeight)
            path.rightArc(minorRadius, turn: 90)
            path.forward(path.currentPoint.x - minorRadius)
            path.rightArc(minorRadius, turn: 90)
            
            let offsetX = keyFrame.minX
            let offsetY = keyFrame.maxY - path.bounds.height - path.bounds.minY
            
            path.apply(.init(translationX: offsetX, y: offsetY))
        }
        
        return path
    }
}



// MARK: - Bezier paths helper

fileprivate extension KeyboardPopupView {
    func get45DegreedLineLength(forRadius radius: CGFloat, andWidth width: CGFloat) -> CGFloat {
        let squareRoot2: CGFloat = sqrt(2.0)
        return squareRoot2 * (width - 2.0 * radius * (1.0 - 1.0 / squareRoot2))
    }

    func get45DegreedLineheight(length: CGFloat) -> CGFloat {
        return length / sqrt(2.0)
    }
}

