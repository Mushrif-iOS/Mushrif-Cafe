//
//  UIFont+Extension.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 24/09/24.
//

import UIKit

extension UIFont {
    
    public enum PoppinsType: String {
        
        case light = "Poppins-Light"
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semibold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
    }
    
    class func poppinsLightFontWith(size: CGFloat) -> UIFont {
        return  UIFont(name: PoppinsType.light.rawValue, size: size)!
    }
    
    class func poppinsRegularFontWith( size: CGFloat) -> UIFont {
        return  UIFont(name: PoppinsType.regular.rawValue, size: size)!
    }
    
    class func poppinsMediumFontWith( size: CGFloat) -> UIFont {
        return  UIFont(name: PoppinsType.medium.rawValue, size: size)!
    }
    
    class func poppinsSemiBoldFontWith( size: CGFloat) -> UIFont {
        return  UIFont(name: PoppinsType.semibold.rawValue, size: size)!
    }
    
    class func poppinsBoldFontWith( size: CGFloat ) -> UIFont {
        return  UIFont(name: PoppinsType.bold.rawValue, size: size)!
    }
}
