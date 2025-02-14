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
    
    public enum ZainType: String {
        
        case light = "Zain-Light"
        case regular = "Zain-Regular"
        //case medium = "Poppins-Medium"
        //case semibold = "Poppins-SemiBold"
        case bold = "Zain-Bold"
    }
    
    class func poppinsLightFontWith(size: CGFloat) -> UIFont {
        let userLanguage = UserDefaultHelper.language
        return userLanguage == "ar" ? UIFont(name: ZainType.light.rawValue, size: size)! : UIFont(name: PoppinsType.light.rawValue, size: size)!
    }
    
    class func poppinsRegularFontWith( size: CGFloat) -> UIFont {
        let userLanguage = UserDefaultHelper.language
        return userLanguage == "ar" ? UIFont(name: ZainType.regular.rawValue, size: size)! : UIFont(name: PoppinsType.regular.rawValue, size: size)!
    }
    
    class func poppinsMediumFontWith( size: CGFloat) -> UIFont {
        let userLanguage = UserDefaultHelper.language
        return userLanguage == "ar" ? UIFont(name: ZainType.regular.rawValue, size: size)! : UIFont(name: PoppinsType.medium.rawValue, size: size)!
    }
    
    class func poppinsSemiBoldFontWith( size: CGFloat) -> UIFont {
        let userLanguage = UserDefaultHelper.language
        return userLanguage == "ar" ? UIFont(name: ZainType.bold.rawValue, size: size)! :  UIFont(name: PoppinsType.semibold.rawValue, size: size)!
    }
    
    class func poppinsBoldFontWith( size: CGFloat ) -> UIFont {
        let userLanguage = UserDefaultHelper.language
        return userLanguage == "ar" ? UIFont(name: ZainType.bold.rawValue, size: size)! :  UIFont(name: PoppinsType.bold.rawValue, size: size)!
    }
}
