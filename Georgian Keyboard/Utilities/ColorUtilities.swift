//
//  ColorUtilities.swift
//  Georgian Keyboard
//
//  Created by Giorgi Shavgulidze on 14/09/16.
//  Copyright © 2016 Giorgi Shavgulidze. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int64) {
        let components = (
            A: CGFloat((hex >> 24) & 0xff) / 255,
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: components.A)
    }
    
    func toHex() -> Int64 {
        let (r, g, b, a) = self.rgba()
        return (((Int64(r) << 8 + Int64(g)) << 8) + Int64(b)) << 8 + Int64(a)
    }
    
    
    private func rgba() -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        func toUInt8(value: CGFloat) -> UInt8 {
            let multiplier = CGFloat(255)
            return UInt8(value * multiplier)
        }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (toUInt8(value: red), toUInt8(value: green), toUInt8(value: blue), toUInt8(value: alpha))
    }
}
