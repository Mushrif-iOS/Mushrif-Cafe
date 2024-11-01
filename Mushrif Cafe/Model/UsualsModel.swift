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
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        customerId = json["customer_id"].intValue
        id = json["id"].intValue
        
        title = json["title"].stringValue
    }
}
