//
//  LanguageModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 12/10/24.
//

import Foundation
import SwiftyJSON

struct LanguageRootClass {
    
    var message : String = ""
    var response : LanguageResponse?
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = LanguageResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
    
}

struct LanguageResponse {
    
    var languages : [Languages]!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        languages = [Languages]()
        let languagesArray = json["languages"].arrayValue
        for languagesJson in languagesArray {
            let value = Languages(fromJson: languagesJson)
            languages?.append(value)
        }
    }
}

struct Languages {
    
    var icon : String = ""
    var key : String = ""
    var locale : String = ""
    var title : String = ""
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        icon = json["icon"].stringValue
        key = json["key"].stringValue
        locale = json["locale"].stringValue
        title = json["title"].stringValue
    }
}
