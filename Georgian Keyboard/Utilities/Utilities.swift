//
//  Utilities.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

extension String {
    var NS: NSString {
        return NSString(string: self)
    }
    
    var url: URL? {
        return URL(fileURLWithPath: self)
    }
}

extension Float {
    var cgf: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    var f: Float {
        return Float(self)
    }
}


extension UIView {
    func snapshot() -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
//        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return UIImageView(image: image)
    }
}

extension UIImageView {
    func setFramePreservingHeight(_ frame: CGRect) {
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: self.frame.size.height)
    }
}


extension UIInputView: UIInputViewAudioFeedback {
    
    public var enableInputClicksWhenVisible: Bool { get { return true } }
    
    func playInputClick​() {
        UIDevice.current.playInputClick()
    }
}
