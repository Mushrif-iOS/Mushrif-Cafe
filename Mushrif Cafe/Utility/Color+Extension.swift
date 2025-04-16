//
//  Color+Extension.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 25/09/24.
//

import UIKit

extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let appBackground = UIColor(hex: 0xF1F1F1)
    static let primaryBrown = UIColor(hex: 0x976827)
    static let black = UIColor(hex: 0x000000)
    static let white = UIColor(hex: 0xFFFFFF)
    static let black60 = UIColor(hex: 0x000000, a: 0.6)
    static let appPink = UIColor(hex: 0xF8D4D4)
    static let usualGray = UIColor(hex: 0xE0DFDF) 
    static let selectedPink = UIColor(hex: 0xF7D8D6)
    static let borderPink = UIColor(hex: 0xED968F)
    static let appRed = UIColor(hex: 0xFF0000)
    static let gradiantPink = UIColor(hex: 0xF07B72)
    static let floatingColor = UIColor(hex: 0xED968F)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
