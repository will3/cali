//
//  Colors.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    static let accent: UIColor = UIColor(rgb:0x0070DA)
    static let lightAccent: UIColor = UIColor(rgb: 0xF4FAFC)
    static let hard = UIColor(rgb:0x666666)
    static let primary = UIColor(rgb:0x8E8D93)
    static let dimBackground = UIColor(rgb:0xF8F8F8)
    static let separator = UIColor(rgb:0xECECEC)
    static let white = UIColor(rgb:0xFFFFFF)
    static let black = UIColor(rgb:0x000000)
    static let draggableAlpha: CGFloat = 0.8
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
