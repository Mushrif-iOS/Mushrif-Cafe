//
//  FoodItemModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/11/24.
//

import Foundation
import SwiftyJSON

class FoodItemRootClass {
    
    var message : String = ""
    var response : FoodItemResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = FoodItemResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class FoodItemResponse {
    
    var currentPage : Int!
    var data : [FoodItemData]!
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
        data = [FoodItemData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray {
            let value = FoodItemData(fromJson: dataJson)
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

class FoodItemData {
    
    var categoryId : Int = 0
    var id : Int = 0
    var image : String = ""
    var ingredients : [FoodItemIngredient]!
    var kitchenId : Int = 0
    var name : String = ""
    var price : String = ""
    var specialPrice : String = ""
    var subCategoryId : Int = 0
    var combo : [Combo]!
    var haveCombo : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        categoryId = json["category_id"].intValue
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
        subCategoryId = json["sub_category_id"].intValue
        
        combo = [Combo]()
        let comboArray = json["combo"].arrayValue
        for comboJson in comboArray{
            let value = Combo(fromJson: comboJson)
            combo.append(value)
        }
        haveCombo = json["have_combo"].intValue
    }
    
}

class FoodItemIngredient {
    
    var id : Int = 0
    var ingredientDetails : FoodItemIngredientDetail!
    var ingredientId : Int = 0
    var productId : Int = 0
    var plainRequirementStatus : Int = 0
    var requirementStatus : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        let ingredientDetailsJson = json["ingredient_details"]
        if !ingredientDetailsJson.isEmpty{
            ingredientDetails = FoodItemIngredientDetail(fromJson: ingredientDetailsJson)
        }
        ingredientId = json["ingredient_id"].intValue
        productId = json["product_id"].intValue
        plainRequirementStatus = json["plain_requirement_status"].intValue
        requirementStatus = json["requirement_status"].intValue
    }
}

class FoodItemIngredientDetail {
    
    var id : Int = 0
    var name : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}

class Combo {
    
    var comboTitle : String = ""
    var id : Int = 0
    var offerPrice : String = ""
    var price : String = ""
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        comboTitle = json["combo_title"].stringValue
        id = json["id"].intValue
        offerPrice = json["offer_price"].stringValue
        price = json["price"].stringValue
        productId = json["product_id"].intValue
    }
}
