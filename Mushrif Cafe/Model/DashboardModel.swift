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
    var myActiveOrders : [MyActiveOrder]!
    var myUsuals : [DashboardMyUsual]!
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
        myActiveOrders = [MyActiveOrder]()
        let myActiveOrdersArray = json["my_active_orders"].arrayValue
        for myActiveOrdersJson in myActiveOrdersArray{
            let value = MyActiveOrder(fromJson: myActiveOrdersJson)
            myActiveOrders.append(value)
        }
        myUsuals = [DashboardMyUsual]()
        let myUsualsArray = json["my_usuals"].arrayValue
        for myUsualsJson in myUsualsArray{
            let value = DashboardMyUsual(fromJson: myUsualsJson)
            myUsuals.append(value)
        }
        tryOurBest = [TryOurBest]()
        let tryOurBestArray = json["try_our_best"].arrayValue
        for tryOurBestJson in tryOurBestArray {
            let value = TryOurBest(fromJson: tryOurBestJson)
            tryOurBest.append(value)
        }
    }
}

class MyActiveOrder {

    var businessId : Int = 0
    var createdAt : String = ""
    var cart : MyActiveCart!
    var createdUserId : Int = 0
    var customerAddress : String = ""
    var customerCity : String = ""
    var customerEmail : String = ""
    var customerId : Int = 0
    var customerName : String = ""
    var customerPhone : String = ""
    var customerState : String = ""
    var customerZip : String = ""
    var deliveryPartner : String = ""
    var deliveryTime : String = ""
    var discount : String = ""
    var discountPercentage : String = ""
    var grandTotal : String = ""
    var groupId : Int = 0
    var groupNo : AnyObject!
    var hallId : Int = 0
    var id : Int = 0
    var loyaltyAmount : String = ""
    var loyaltyPoints : String = ""
    var note : String = ""
    var orderNumber : Int = 0
    var orderType : String = ""
    var paid : String = ""
    var paymentId : String = ""
    var paymentMethod : String = ""
    var printStatus : String = ""
    var serviceCharge : String = ""
    var status : Int = 0
    var subTotal : String = ""
    var table : String = ""
    var tableId : Int = 0
    var tableNo : AnyObject!
    var updatedUserId : Int = 0
    var userId : Int = 0

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        createdAt = json["created_at"].stringValue
        let cartJson = json["cart"]
        if !cartJson.isEmpty {
            cart = MyActiveCart(fromJson: cartJson)
        }
        createdUserId = json["created_user_id"].intValue
        customerAddress = json["customer_address"].stringValue
        customerCity = json["customer_city"].stringValue
        customerEmail = json["customer_email"].stringValue
        customerId = json["customer_id"].intValue
        customerName = json["customer_name"].stringValue
        customerPhone = json["customer_phone"].stringValue
        customerState = json["customer_state"].stringValue
        customerZip = json["customer_zip"].stringValue
        deliveryPartner = json["delivery_partner"].stringValue
        deliveryTime = json["delivery_time"].stringValue
        discount = json["discount"].stringValue
        discountPercentage = json["discount_percentage"].stringValue
        grandTotal = json["grand_total"].stringValue
        groupId = json["group_id"].intValue
        groupNo = json["group_no"].stringValue as AnyObject
        hallId = json["hall_id"].intValue
        id = json["id"].intValue
        loyaltyAmount = json["loyalty_amount"].stringValue
        loyaltyPoints = json["loyalty_points"].stringValue
        note = json["note"].stringValue
        orderNumber = json["order_number"].intValue
        orderType = json["order_type"].stringValue
        paid = json["paid"].stringValue
        paymentId = json["payment_id"].stringValue
        paymentMethod = json["payment_method"].stringValue
        printStatus = json["print_status"].stringValue
        serviceCharge = json["service_charge"].stringValue
        status = json["status"].intValue
        subTotal = json["sub_total"].stringValue
        table = json["table"].stringValue
        tableId = json["table_id"].intValue
        tableNo = json["table_no"].stringValue as AnyObject
        updatedUserId = json["updated_user_id"].intValue
        userId = json["user_id"].intValue
    }
}

class MyActiveCart {

    var customerId : Int = 0
    var groupId : Int = 0
    var hallId : Int = 0
    var id : Int = 0
    var isPaid : String = ""
    var items : Int = 0
    var orderId : Int = 0
    var orderStatus : String = ""
    var orderType : String = ""
    var subTotal : String = ""
    var tableId : Int = 0

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        customerId = json["customer_id"].intValue
        groupId = json["group_id"].intValue
        hallId = json["hall_id"].intValue
        id = json["id"].intValue
        isPaid = json["is_paid"].stringValue
        items = json["items"].intValue
        orderId = json["order_id"].intValue
        orderStatus = json["order_status"].stringValue
        orderType = json["order_type"].stringValue
        subTotal = json["sub_total"].stringValue
        tableId = json["table_id"].intValue
    }
}

class DashboardMyUsual {
    
    var customerId : Int = 0
    var id : Int = 0
    var items : [CartItem]!
    var title : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        customerId = json["customer_id"].intValue
        id = json["id"].intValue
        items = [CartItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray {
            let value = CartItem(fromJson: itemsJson)
            items.append(value)
        }
        title = json["title"].stringValue
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
