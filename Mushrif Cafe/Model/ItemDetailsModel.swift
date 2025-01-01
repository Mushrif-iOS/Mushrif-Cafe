//
//  ItemDetailsModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 04/11/24.
//

import Foundation
import SwiftyJSON

class ItemDetailsRootClass {
    
    var message : String = ""
    var response : ItemDetailsResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = ItemDetailsResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class ItemDetailsResponse {
    
    var addonProducts : [AddonProduct]!
    var category : ItemCategory!
    var categoryId : Int = 0
    var choiceGroups : [ChoiceGroup]!
    var combo : [Combo]!
    var comboDetails : ItemComboDetail!
    var haveCombo : Int = 0
    var id : Int = 0
    var image : String = ""
    var ingredients : [FoodItemIngredient]!
    var kitchenId : Int = 0
    var name : String = ""
    var price : String = ""
    var productOptions : [ProductOption]!
    var specialPrice : String = ""
    var subCategory : ItemSubCategory!
    var subCategoryId : Int = 0
    var variationPrices : [VariationPrice]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        addonProducts = [AddonProduct]()
        let addonProductsArray = json["addon_products"].arrayValue
        for addonProductsJson in addonProductsArray {
            let value = AddonProduct(fromJson: addonProductsJson)
            addonProducts.append(value)
        }
        let categoryJson = json["category"]
        if !categoryJson.isEmpty {
            category = ItemCategory(fromJson: categoryJson)
        }
        categoryId = json["category_id"].intValue
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
        let comboDetailsJson = json["combo_details"]
        if !comboDetailsJson.isEmpty {
            comboDetails = ItemComboDetail(fromJson: comboDetailsJson)
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
        productOptions = [ProductOption]()
        let productOptionsArray = json["product_options"].arrayValue
        for productOptionsJson in productOptionsArray {
            let value = ProductOption(fromJson: productOptionsJson)
            productOptions.append(value)
        }
        specialPrice = json["special_price"].stringValue
        let subCategoryJson = json["sub_category"]
        if !subCategoryJson.isEmpty{
            subCategory = ItemSubCategory(fromJson: subCategoryJson)
        }
        subCategoryId = json["sub_category_id"].intValue
        variationPrices = [VariationPrice]()
        let variationPricesArray = json["variation_prices"].arrayValue
        for variationPricesJson in variationPricesArray {
            let value = VariationPrice(fromJson: variationPricesJson)
            variationPrices.append(value)
        }
    }
}

class AddonProduct {
    
    var descriptionField : String = ""
    var id : Int = 0
    var name : String = ""
    var price : String = ""
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        price = json["price"].stringValue
        productId = json["product_id"].intValue
    }
}

class ItemCategory {
    
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

class ChoiceGroup {
    
    var choices : [Choice]!
    var id : Int = 0
    var maxSelection : Int = 0
    var minSelection : Int = 0
    var productId : Int = 0
    var title : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        choices = [Choice]()
        let choicesArray = json["choices"].arrayValue
        for choicesJson in choicesArray{
            let value = Choice(fromJson: choicesJson)
            choices.append(value)
        }
        id = json["id"].intValue
        maxSelection = json["max_selection"].intValue
        minSelection = json["min_selection"].intValue
        productId = json["product_id"].intValue
        title = json["title"].stringValue
    }
}

class Choice {
    var choice : String = ""
    var choicePrice : String = ""
    var groupId : Int = 0
    var id : Int = 0
    var isDeleted : String = ""
    var selectionStatus : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        choice = json["choice"].stringValue
        choicePrice = json["choice_price"].stringValue
        groupId = json["group_id"].intValue
        id = json["id"].intValue
        isDeleted = json["is_deleted"].stringValue
        selectionStatus = json["selection_status"].intValue
    }
}

class ItemComboDetail {
    
    var categories : [ComboDetailCategory]!
    var comboTitle : String = ""
    var id : Int = 0
    var offerPrice : String = ""
    var price : String = ""
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        categories = [ComboDetailCategory]()
        let categoriesArray = json["categories"].arrayValue
        for categoriesJson in categoriesArray {
            let value = ComboDetailCategory(fromJson: categoriesJson)
            categories.append(value)
        }
        comboTitle = json["combo_title"].stringValue
        id = json["id"].intValue
        offerPrice = json["offer_price"].stringValue
        price = json["price"].stringValue
        productId = json["product_id"].intValue
    }
}

class ComboDetailCategory {
    
    var id : Int = 0
    var name : String = ""
    var comboItems : [Category]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        comboItems = [Category]()
        let comboItemsArray = json["combo_items"].arrayValue
        for comboItemsJson in comboItemsArray{
            let value = Category(fromJson: comboItemsJson)
            comboItems.append(value)
        }
    }
}

class ProductOption {
    
    var id : Int = 0
    var name : String = ""
    var productId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        productId = json["product_id"].intValue
    }
}

class ItemSubCategory {
    
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

class VariationPrice {
    
    var id : Int = 0
    var isAvailable : Int = 0
    var option : [Option]!
    var price : String = ""
    var productId : Int = 0
    var specialPrice : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        isAvailable = json["is_available"].intValue
        option = [Option]()
        let optionArray = json["option"].arrayValue
        for optionJson in optionArray {
            let value = Option(fromJson: optionJson)
            option.append(value)
        }
        price = json["price"].stringValue
        productId = json["product_id"].intValue
        specialPrice = json["special_price"].stringValue
    }
}

class Option {
    
    var id : Int = 0
    var name : String = ""
    var variationId : Int = 0
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        variationId = json["variation_id"].intValue
    }
}
