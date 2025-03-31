//
//  UsualsModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/11/24.
//

import Foundation
import SwiftyJSON

class UsualRootClass {
    
    var message : String = ""
    var response : UsualResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = UsualResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class UsualResponse {
    
    var currentPage : Int!
    var data : [UsualData]!
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
        data = [UsualData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray {
            let value = UsualData(fromJson: dataJson)
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

class UsualData {
    
    var customerId : Int = 0
    var id : Int = 0
    var title : String = ""
    var items : [UsualItem]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        customerId = json["customer_id"].intValue
        id = json["id"].intValue
        items = [UsualItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = UsualItem(fromJson: itemsJson)
            items.append(value)
        }
        title = json["title"].stringValue
    }
}

class UsualItem {
    
    var cartItemId : Int = 0
    var groupId : Int = 0
    var id : Int = 0
    var itemType : String = ""
    var product : UsualProduct!
    var productId : Int = 0
    var quantity : Int = 0
    var ingredientsList : [FoodIngredientsList]?
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        cartItemId = json["cart_item_id"].intValue
        groupId = json["group_id"].intValue
        id = json["id"].intValue
        itemType = json["item_type"].stringValue
        let productJson = json["product"]
        if !productJson.isEmpty{
            product = UsualProduct(fromJson: productJson)
        }
        productId = json["product_id"].intValue
        quantity = json["quantity"].intValue
        ingredientsList = [FoodIngredientsList]()
        let ingredientsListArray = json["ingredients_list"].arrayValue
        for ingredientsListJson in ingredientsListArray {
            let value = FoodIngredientsList(fromJson: ingredientsListJson)
            ingredientsList?.append(value)
        }
    }
}

class UsualProduct {
    
    var businessId : Int = 0
    var categoryId : Int = 0
    var descriptionField : String = ""
    var descriptionAr : String = ""
    var haveCombo : Int = 0
    var howToCook : String = ""
    var id : Int = 0
    var image : String = ""
    var imageUrl : String = ""
    var ingredients : [UsualIngredient]!
    var kitchenId : Int = 0
    var name : String = ""
    var nameAr : String = ""
    var price : String = ""
    var productType : Int = 0
    var specialPrice : String = ""
    var status : Int = 0
    var subCategoryId : Int = 0
    var userId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        categoryId = json["category_id"].intValue
        descriptionField = json["description"].stringValue
        descriptionAr = json["description_ar"].stringValue
        haveCombo = json["have_combo"].intValue
        howToCook = json["how_to_cook"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        imageUrl = json["image_url"].stringValue
        ingredients = [UsualIngredient]()
        let ingredientsArray = json["ingredients"].arrayValue
        for ingredientsJson in ingredientsArray {
            let value = UsualIngredient(fromJson: ingredientsJson)
            ingredients.append(value)
        }
        kitchenId = json["kitchen_id"].intValue
        name = json["name"].stringValue
        nameAr = json["name_ar"].stringValue
        price = json["price"].stringValue
        productType = json["product_type"].intValue
        specialPrice = json["special_price"].stringValue
        status = json["status"].intValue
        subCategoryId = json["sub_category_id"].intValue
        userId = json["user_id"].intValue
    }
}

class UsualIngredient {
    
    var id : Int = 0
    var ingredientDetails : UsualIngredientDetail!
    var ingredientId : Int = 0
    var plainRequirementStatus : Int = 0
    var productId : Int = 0
    var requirementStatus : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        let ingredientDetailsJson = json["ingredient_details"]
        if !ingredientDetailsJson.isEmpty {
            ingredientDetails = UsualIngredientDetail(fromJson: ingredientDetailsJson)
        }
        ingredientId = json["ingredient_id"].intValue
        plainRequirementStatus = json["plain_requirement_status"].intValue
        productId = json["product_id"].intValue
        requirementStatus = json["requirement_status"].intValue
    }
}

class UsualIngredientDetail {
    
    var businessId : Int = 0
    var categoryId : Int = 0
    var createdUserId : Int = 0
    var descriptions : String = ""
    var id : Int = 0
    var image : String = ""
    var measurementUnit : String = ""
    var name : String = ""
    var nameAr : String = ""
    var purchaseCost : String = ""
    var status : Int = 0
    var stock : String = ""
    var stockManagement : Int = 0
    var updatedUserId : Int = 0
    var userId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        categoryId = json["category_id"].intValue
        createdUserId = json["created_user_id"].intValue
        descriptions = json["descriptions"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        measurementUnit = json["measurement_unit"].stringValue
        name = json["name"].stringValue
        nameAr = json["name_ar"].stringValue
        purchaseCost = json["purchase_cost"].stringValue
        status = json["status"].intValue
        stock = json["stock"].stringValue
        stockManagement = json["stock_management"].intValue
        updatedUserId = json["updated_user_id"].intValue
        userId = json["user_id"].intValue
    }
}
