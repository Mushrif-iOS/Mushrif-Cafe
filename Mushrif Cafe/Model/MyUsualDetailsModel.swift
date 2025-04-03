//
//  MyUsualDetailsModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/04/25.
//

import Foundation
import SwiftyJSON

class UsualDetailsRootClass {

    var customerId : Int = 0
    var id : Int = 0
    var items : [UsualDetailsItem]!
    var title : String = ""

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        customerId = json["customer_id"].intValue
        id = json["id"].intValue
        items = [UsualDetailsItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = UsualDetailsItem(fromJson: itemsJson)
            items.append(value)
        }
        title = json["title"].stringValue
    }
}

class UsualDetailsItem {

    var cartItemId : Int = 0
    var choiceGroups : [ChoiceGroup]!
    var combo : [Combo]!
    var comboId : Int = 0
    var groupId : Int = 0
    var id : Int = 0
    var ingredients : [FoodItemIngredient]!
    var ingredientsList : [FoodIngredientsList]?
    var isCustomized : String = ""
    var isPlain : String = ""
    var itemType : String = ""
    var product : CartProduct!
    var productId : Int = 0
    var productType : Int = 0
    var quantity : Int = 0

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        cartItemId = json["cart_item_id"].intValue
        choiceGroups = [ChoiceGroup]()
        let choiceGroupsArray = json["choice_groups"].arrayValue
        for choiceGroupsJson in choiceGroupsArray {
            let value = ChoiceGroup(fromJson: choiceGroupsJson)
            choiceGroups.append(value)
        }
        combo = [Combo]()
        let comboArray = json["combo"].arrayValue
        for comboJson in comboArray {
            let value = Combo(fromJson: comboJson)
            combo.append(value)
        }
        comboId = json["combo_id"].intValue
        groupId = json["group_id"].intValue
        id = json["id"].intValue
        ingredients = [FoodItemIngredient]()
        let ingredientsArray = json["ingredients"].arrayValue
        for ingredientsJson in ingredientsArray {
            let value = FoodItemIngredient(fromJson: ingredientsJson)
            ingredients.append(value)
        }
        ingredientsList = [FoodIngredientsList]()
        let ingredientsListArray = json["ingredients_list"].arrayValue
        for ingredientsListJson in ingredientsListArray {
            let value = FoodIngredientsList(fromJson: ingredientsListJson)
            ingredientsList?.append(value)
        }
        isCustomized = json["is_customized"].stringValue
        isPlain = json["is_plain"].stringValue
        itemType = json["item_type"].stringValue
        let productJson = json["product"]
        if !productJson.isEmpty {
            product = CartProduct(fromJson: productJson)
        }
        productId = json["product_id"].intValue
        productType = json["product_type"].intValue
        quantity = json["quantity"].intValue
    }
}
