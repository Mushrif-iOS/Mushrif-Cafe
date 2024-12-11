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
    
    static var select_table: String {
        return BaseURL  + "select-table"
    }
    
    static var search_product: String {
        return BaseURL  + "dine-in/search"
    }
    
    static var sub_category: String {
        return BaseURL  + "sub-categories"
    }
    static var food_item_list: String {
        return BaseURL  + "food-items"
    }
    static var food_item_details: String {
        return BaseURL  + "details"
    }
    
    static var my_usuals: String {
        return BaseURL  + "my-usuals"
    }
    static var create_usuals_group: String {
        return BaseURL  + "my-usuals/create"
    }
    static var update_usuals_group: String {
        return BaseURL  + "my-usuals/update"
    }
    static var add_Item_To_Usual: String {
        return BaseURL  + "my-usuals/add-item"
    }
    static var update_usuals_Qty: String {
        return BaseURL  + "my-usuals/update-quantity"
    }
    
    //Cart
    static var add_item_cart: String {
        return BaseURL  + "add-item-to-cart"
    }
    static var get_cart: String {
        return BaseURL  + "cart"
    }
    static var update_cart_Qty: String {
        return BaseURL  + "update-cart-quantity"
    }
    static var place_order: String {
        return BaseURL  + "place-order"
    }
    static var customize_cart_item: String {
        return BaseURL  + "customize-cart-item"
    }
}
