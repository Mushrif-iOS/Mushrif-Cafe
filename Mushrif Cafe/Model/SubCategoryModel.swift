//
//  SubCategoryModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/11/24.
//

import Foundation
import SwiftyJSON

class SubCategoryRootClass {
    
    var message : String = ""
    var response : SubCategoryResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty{
            response = SubCategoryResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class SubCategoryResponse {
    
    var subCategories : [SubCategory]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        subCategories = [SubCategory]()
        let subCategoriesArray = json["sub_categories"].arrayValue
        for subCategoriesJson in subCategoriesArray{
            let value = SubCategory(fromJson: subCategoriesJson)
            subCategories.append(value)
        }
    }
}

class SubCategory {
    
    var businessId : Int = 0
    var categoryId : Int = 0
    var descriptionField :  String = ""
    var id : Int = 0
    var image :  String = ""
    var name :  String = ""
    var nameAr :  String = ""
    var position : Int = 0
    var status : Int = 0
    var userId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        businessId = json["business_id"].intValue
        categoryId = json["category_id"].intValue
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        nameAr = json["name_ar"].stringValue
        position = json["position"].intValue
        status = json["status"].intValue
        userId = json["user_id"].intValue
    }
}
