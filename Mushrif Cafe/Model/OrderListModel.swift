//
//  OrderListModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 17/12/24.
//

import Foundation
import SwiftyJSON

class OrderRootClass {
    
    var message : String = ""
    var response : OrderResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = OrderResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class OrderResponse {
    
    var currentPage : Int!
    var data : [OrderData]!
    var firstPageUrl : String = ""
    var from : Int!
    var lastPage : Int!
    var lastPageUrl : String = ""
    var nextPageUrl : String = ""
    var perPage : Int!
    var prevPageUrl : String = ""
    var to : Int!
    var total : Int!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        currentPage = json["current_page"].intValue
        data = [OrderData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray {
            let value = OrderData(fromJson: dataJson)
            data.append(value)
        }
        firstPageUrl = json["first_page_url"].stringValue
        from = json["from"].intValue
        lastPage = json["last_page"].intValue
        lastPageUrl = json["last_page_url"].stringValue
        nextPageUrl = json["next_page_url"].stringValue
        perPage = json["per_page"].intValue
        prevPageUrl = json["prev_page_url"].stringValue
        to = json["to"].intValue
        total = json["total"].intValue
    }
}

class OrderData {
    
    var businessId : Int = 0
    var createdUserId : Int = 0
    var createdAt : String = ""
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
        createdUserId = json["created_user_id"].intValue
        createdAt = json["created_at"].stringValue
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
