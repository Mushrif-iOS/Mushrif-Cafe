//
//  CartItemModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 03/12/24.
//

import Foundation
import SwiftyJSON

class CartRootClass {
    
    var message : String = ""
    var response : CartResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = CartResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class CartResponse {
    
    var cartItems : [CartItem]!
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
        cartItems = [CartItem]()
        let cartItemsArray = json["cart_items"].arrayValue
        for cartItemsJson in cartItemsArray {
            let value = CartItem(fromJson: cartItemsJson)
            cartItems.append(value)
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

class CartItem {
    
    var cartId : Int = 0
    var comboId : Int = 0
    var id : Int = 0
    var instruction : String = ""
    var isCooked : String = ""
    var isCustomized : String = ""
    var isOrderPlaced : String = ""
    var isPlain : String = ""
    var product : CartProduct!
    var productId : Int = 0
    var quantity : Int = 0
    var unitPrice : String = ""
    var variationId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        cartId = json["cart_id"].intValue
        comboId = json["combo_id"].intValue
        id = json["id"].intValue
        instruction = json["instruction"].stringValue
        isCooked = json["is_cooked"].stringValue
        isCustomized = json["is_customized"].stringValue
        isOrderPlaced = json["is_order_placed"].stringValue
        isPlain = json["is_plain"].stringValue
        let productJson = json["product"]
        if !productJson.isEmpty {
            product = CartProduct(fromJson: productJson)
        }
        productId = json["product_id"].intValue
        quantity = json["quantity"].intValue
        unitPrice = json["unit_price"].stringValue
        variationId = json["variation_id"].intValue
    }
}

class CartProduct {
    
    var category : CartComboDetailCategory!
    var categoryId : Int = 0
    var choiceGroups : [ChoiceGroup]!
    var comboDetails : CartComboDetail!
    var haveCombo : Int = 0
    var id : Int = 0
    var image : String = ""
    var ingredients : [FoodItemIngredient]!
    var kitchenId : Int = 0
    var name : String = ""
    var price : String = ""
    var specialPrice : String = ""
    var subCategory : CartSubCategory!
    var subCategoryId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        let categoryJson = json["category"]
        if !categoryJson.isEmpty {
            category = CartComboDetailCategory(fromJson: categoryJson)
        }
        categoryId = json["category_id"].intValue
        choiceGroups = [ChoiceGroup]()
        let choiceGroupsArray = json["choice_groups"].arrayValue
        for choiceGroupsJson in choiceGroupsArray {
            let value = ChoiceGroup(fromJson: choiceGroupsJson)
            choiceGroups.append(value)
        }
        let comboDetailsJson = json["combo_details"]
        if !comboDetailsJson.isEmpty {
            comboDetails = CartComboDetail(fromJson: comboDetailsJson)
        }
        haveCombo = json["have_combo"].intValue
        id = json["id"].intValue
        image = json["image"].stringValue
        ingredients = [FoodItemIngredient]()
        let ingredientsArray = json["ingredients"].arrayValue
        for ingredientsJson in ingredientsArray {
            let value = FoodItemIngredient(fromJson: ingredientsJson)
            ingredients.append(value)
        }
        kitchenId = json["kitchen_id"].intValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        specialPrice = json["special_price"].stringValue
        let subCategoryJson = json["sub_category"]
        if !subCategoryJson.isEmpty{
            subCategory = CartSubCategory(fromJson: subCategoryJson)
        }
        subCategoryId = json["sub_category_id"].intValue
    }
}

class CartSubCategory {
    
    var categoryId : Int = 0
    var id : Int = 0
    var name : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        categoryId = json["category_id"].intValue
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}

class CartComboDetail {
    
    var categories : [CartComboDetailCategory]!
    var comboTitle : String = ""
    var id : Int = 0
    var offerPrice : String = ""
    var price : String = ""
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        categories = [CartComboDetailCategory]()
        let categoriesArray = json["categories"].arrayValue
        for categoriesJson in categoriesArray {
            let value = CartComboDetailCategory(fromJson: categoriesJson)
            categories.append(value)
        }
        comboTitle = json["combo_title"].stringValue
        id = json["id"].intValue
        offerPrice = json["offer_price"].stringValue
        price = json["price"].stringValue
        productId = json["product_id"].intValue
    }
}

class CartComboDetailCategory {
    
    var id : Int = 0
    var name : String = ""
    var comboItems : [CartComboItem]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        comboItems = [CartComboItem]()
        let comboItemsArray = json["combo_items"].arrayValue
        for comboItemsJson in comboItemsArray{
            let value = CartComboItem(fromJson: comboItemsJson)
            comboItems.append(value)
        }
    }
}

class CartComboItem {
    
    var id : Int = 0
    var name : String = ""
    var selectionStatus : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        selectionStatus = json["selection_status"].intValue
    }
}
