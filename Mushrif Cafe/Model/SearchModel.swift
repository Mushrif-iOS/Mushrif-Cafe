//
//  SearchModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 31/10/24.
//

import Foundation
import SwiftyJSON

class SearchRootClass {
    
    var message : String = ""
    var response : SearchResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = SearchResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class SearchResponse {
    
    var currentPage : Int!
    var data : [SearchData]!
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
        data = [SearchData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray {
            let value = SearchData(fromJson: dataJson)
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

class SearchData {
    
    var categoryId : Int = 0
    var id : Int = 0
    var image : String = ""
    var ingredients : [SearchIngredient]!
    var kitchenId : Int = 0
    var name : String = ""
    var price : String = ""
    var specialPrice : String = ""
    var subCategoryId : Int = 0
    var productType : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        categoryId = json["category_id"].intValue
        id = json["id"].intValue
        image = json["image"].stringValue
        ingredients = [SearchIngredient]()
        let ingredientsArray = json["ingredients"].arrayValue
        for ingredientsJson in ingredientsArray {
            let value = SearchIngredient(fromJson: ingredientsJson)
            ingredients.append(value)
        }
        kitchenId = json["kitchen_id"].intValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        specialPrice = json["special_price"].stringValue
        subCategoryId = json["sub_category_id"].intValue
        productType = json["product_type"].intValue
    }
}

class SearchIngredient {
    
    var id : Int = 0
    var ingredientDetails : SearchIngredientDetail!
    var ingredientId : Int = 0
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        let ingredientDetailsJson = json["ingredient_details"]
        if !ingredientDetailsJson.isEmpty{
            ingredientDetails = SearchIngredientDetail(fromJson: ingredientDetailsJson)
        }
        ingredientId = json["ingredient_id"].intValue
        productId = json["product_id"].intValue
    }
}

class SearchIngredientDetail {
    
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
