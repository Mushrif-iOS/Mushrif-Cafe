//
//  GroupCreationResponseModel.swift
//  Mushrif Cafe
//
//  Created by bhikhu on 28/05/25.
//

import Foundation


import SwiftyJSON


class GroupCreationModel {
    
    var message: String = ""
    var response: GroupDetailsModel?
    var success: Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        success = json["success"].boolValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = GroupDetailsModel(fromJson: responseJson)
        }
    }
}

class GroupDetailsModel {
    
    var title: String = ""
    var customerId: Int = 0
    var createdAt: String = ""
    var id: Int = 0
    var updatedAt: String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        title = json["title"].stringValue
        customerId = json["customer_id"].intValue
        createdAt = json["created_at"].stringValue
        id = json["id"].intValue
        updatedAt = json["updated_at"].stringValue
    }
}
