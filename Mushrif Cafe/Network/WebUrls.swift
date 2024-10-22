//
//  WebUrls.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 09/10/24.
//

import UIKit

struct APPURL {
    
    private struct Domains {
        static let Dev = "https://mushrif-cafe.myclientdemo.us"
        static let Live = "testAddress.qa.com"
    }
    
    private  struct Routes {
        static let Api = "/api/customer/"
    }
    
    private  static let Domain = Domains.Dev
    private  static let Route = Routes.Api
    private  static let BaseURL = Domain + Route
    
    //MARK: - Authentication
    static var getLanguages: String {
        return BaseURL  + "languages"
    }
    static var getOTP: String {
        return BaseURL  + "get-otp"
    }
    static var validateOTP: String {
        return BaseURL  + "validate-otp"
    }
    static var logout: String {
        return BaseURL  + "logout"
    }
    
    //MARK: - Profile
    static var getProfileDetails: String {
        return BaseURL  + "profile"
    }
    static var updateProfile: String {
        return BaseURL  + "profile-update"
    }
    static var deleteProfile: String {
        return BaseURL  + "delete-profile"
    }
    static var terms_condition: String {
        return BaseURL  + "page/terms-condition"
    }
    static var privacy_policy: String {
        return BaseURL  + "page/privacy-policy"
    }
    static var submit_feedback: String {
        return BaseURL  + "feedback"
    }
    
    static var wallet_details: String {
        return BaseURL  + "wallet"
    }
    static var add_money: String {
        return BaseURL  + "wallet/add-money"
    }
    
    static var dine_dashboard: String {
        return BaseURL  + "dine-in/dashboard"
    }
}
