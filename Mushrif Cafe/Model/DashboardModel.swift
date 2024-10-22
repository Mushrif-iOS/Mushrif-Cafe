//
//  DashboardModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 18/10/24.
//

import Foundation
import SwiftyJSON

class DashboardRoot {

    var message : String = ""
    var response : DashboardResponse?
    var success : Bool = false

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty{
            response = DashboardResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class DashboardResponse {

    //var banner : [AnyObject]!
    var categories : [Category]!
//    var myActiveOrders : [AnyObject]!
//    var myUsuals : [AnyObject]!
    var tryOurBest : [TryOurBest]!


    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
//        banner = [AnyObject]()
//        let bannerArray = json["banner"].arrayValue
//        for bannerJson in bannerArray{
//            banner.append(bannerJson.stringValue)
//        }
        categories = [Category]()
        let categoriesArray = json["categories"].arrayValue
        for categoriesJson in categoriesArray{
            let value = Category(fromJson: categoriesJson)
            categories.append(value)
        }
//        myActiveOrders = [AnyObject]()
//        let myActiveOrdersArray = json["my_active_orders"].arrayValue
//        for myActiveOrdersJson in myActiveOrdersArray{
//            myActiveOrders.append(myActiveOrdersJson.stringValue)
//        }
//        myUsuals = [AnyObject]()
//        let myUsualsArray = json["my_usuals"].arrayValue
//        for myUsualsJson in myUsualsArray{
//            myUsuals.append(myUsualsJson.stringValue)
//        }
        tryOurBest = [TryOurBest]()
        let tryOurBestArray = json["try_our_best"].arrayValue
        for tryOurBestJson in tryOurBestArray{
            let value = TryOurBest(fromJson: tryOurBestJson)
            tryOurBest.append(value)
        }
    }
}

class TryOurBest {

    var businessId : Int?
    var categoryId : Int?
    var descriptionField : String = ""
    var haveCombo : Int?
    var howToCook : String = ""
    var id : Int?
    var image : String?
    var kitchenId : Int?
    var name : String = ""
    var price : String = ""
    var productType : Int?
    var specialPrice : String = ""
    var status : Int?
    var subCategoryId : Int?
    var userId : Int?

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        categoryId = json["category_id"].intValue
        descriptionField = json["description"].stringValue
        haveCombo = json["have_combo"].intValue
        howToCook = json["how_to_cook"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        kitchenId = json["kitchen_id"].intValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        productType = json["product_type"].intValue
        specialPrice = json["special_price"].stringValue
        status = json["status"].intValue
        subCategoryId = json["sub_category_id"].intValue
        userId = json["user_id"].intValue
    }
}

class Category {

    var businessId : Int?
    var descriptionField : String = ""
    var id : Int?
    var image : String = ""
    var name : String = ""
    var position : Int?
    var status : Int?
    var userId : Int?

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        position = json["position"].intValue
        status = json["status"].intValue
        userId = json["user_id"].intValue
    }
}
