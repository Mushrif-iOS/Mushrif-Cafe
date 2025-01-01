//
//  OrderDetailsModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 23/12/24.
//

import Foundation
import SwiftyJSON

class OrderDetailsRootClass {
    
    var message : String = ""
    var response : OrderDetailsData!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = OrderDetailsData(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class OrderDetailsData {
    
    var businessId : Int = 0
    var createdUserId : Int = 0
    var createdAt : String = ""
    var customer : Customer!
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
    var kdsPreview : String = ""
    var printStatus : String = ""
    var items : [OrderDetailsItem]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        createdUserId = json["created_user_id"].intValue
        let customerJson = json["customer"]
        if !customerJson.isEmpty{
            customer = Customer(fromJson: customerJson)
        }
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
        kdsPreview = json["kds_preview"].stringValue
        printStatus = json["print_status"].stringValue
        items = [OrderDetailsItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = OrderDetailsItem(fromJson: itemsJson)
            items.append(value)
        }
    }
}

class OrderDetailsItem {
    
    var businessId : Int = 0
    var cartId : String = ""
    var cartItem : CartItem!
    var descriptionField : String = ""
    var id : Int = 0
    var orderId : Int = 0
    var productId : Int = 0
    var productName : String = ""
    var quantity : String = ""
    var subTotal : String = ""
    var unitCost : String = ""
    var userId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        cartId = json["cart_id"].stringValue
        let cartItemJson = json["cart_item"]
        if !cartItemJson.isEmpty{
            cartItem = CartItem(fromJson: cartItemJson)
        }
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        orderId = json["order_id"].intValue
        productId = json["product_id"].intValue
        productName = json["product_name"].stringValue
        quantity = json["quantity"].stringValue
        subTotal = json["sub_total"].stringValue
        unitCost = json["unit_cost"].stringValue
        userId = json["user_id"].intValue
    }
}
