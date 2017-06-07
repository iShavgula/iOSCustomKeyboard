//
//  KeyboardKeyDrawing.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 22/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

// Partly implemented, only the basic frame & drawing

class KeyboardKeyDrawing {
    class func method(index: Int, rect: CGRect, drawableArea: CGRect, colors: KeyColors, input: String?, fontSize: CGFloat) {
        switch index {
        case 1:
            method1(rect: rect, drawableArea: drawableArea, colors: colors)
            
        default:
            break
        }
        
        drawInput(input: input, inRect: drawableArea, withColor: colors.text, andFontSize: fontSize)
    }
    
    fileprivate class func drawInput(input: String?, inRect rect: CGRect, withColor color: UIColor, andFontSize fontSize: CGFloat) {
        guard let input = input else {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let font: UIFont = UIFont.systemFont(ofSize: fontSize)
        let p = NSMutableParagraphStyle()
        p.alignment = .center
            
        let attributedString = NSAttributedString(string: input, attributes:
            [NSFontAttributeName: font,
             NSForegroundColorAttributeName: color,
             NSParagraphStyleAttributeName: p])
        
        
        
        context.saveGState()
        context.translateBy(x: 0, y: ((rect.height - attributedString.size().height) / 2) * 0.8)
        attributedString.draw(in: rect)
        context.restoreGState()
    }
    
    
    fileprivate class func method1(rect: CGRect, drawableArea: CGRect, colors: KeyColors) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let roundedRectPath = UIBezierPath(roundedRect: drawableArea, cornerRadius: 4)
        let shadowOffset = CGSize(width: 0.1, height: 0.1)
        
        context.saveGState()
        context.setShadow(offset: shadowOffset, blur: 0, color: colors.shadow.cgColor)
        colors.background.setFill()
        roundedRectPath.fill()
        context.restoreGState()
    }
}
