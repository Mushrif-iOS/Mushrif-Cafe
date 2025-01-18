//
//  LoginModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 13/10/24.
//

import Foundation
import SwiftyJSON

struct OTPResponse {
    var success : Bool = false
    var otp: Int
    var isExisting: Bool
    var otpValidity: String
    var otpValidityPeriodInSeconds: Int
    var message: String

    init(json: JSON) {
        self.success = json["success"].boolValue
        self.otp = json["response"]["otp"].intValue
        self.isExisting = json["response"]["is_existing"].boolValue
        self.otpValidity = json["response"]["otp_validity"].stringValue
        self.otpValidityPeriodInSeconds = json["response"]["otp_validity_period_in_second"].intValue
        self.message = json["message"].stringValue
    }
}

class LoginRootClass {

    var message : String = ""
    var response : LoginResponse!
    var success : Bool = false

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty {
            response = LoginResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class LoginResponse {

    var customer : Customer!
    var token : String = ""
    var tokenType : String = ""

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        let customerJson = json["customer"]
        if !customerJson.isEmpty {
            customer = Customer(fromJson: customerJson)
        }
        token = json["token"].stringValue
        tokenType = json["token_type"].stringValue
    }
}

class Customer {

    var address : String = ""
    var balance : String = ""
    var businessId : Int = 0
    var city : String = ""
    var createdUserId : Int = 0
    var customFields : String = ""
    var email : String = ""
    var id : Int = 0
    var loyaltyPoints : String = ""
    var name : String = ""
    var otp : Int = 0
    var otpValidity : String = ""
    var phone : String = ""
    var profilePicture : String = ""
    var remarks : String = ""
    var state : String = ""
    var status : Int = 0
    var userId : Int = 0

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        address = json["address"].stringValue
        balance = json["balance"].stringValue
        businessId = json["business_id"].intValue
        city = json["city"].stringValue
        createdUserId = json["created_user_id"].intValue
        customFields = json["custom_fields"].stringValue
        email = json["email"].stringValue
        id = json["id"].intValue
        loyaltyPoints = json["loyalty_points"].stringValue
        name = json["name"].stringValue
        otp = json["otp"].intValue
        otpValidity = json["otp_validity"].stringValue
        phone = json["phone"].stringValue
        profilePicture = json["profile_picture"].stringValue
        remarks = json["remarks"].stringValue
        state = json["state"].stringValue
        status = json["status"].intValue
        userId = json["user_id"].intValue
    }
}


class PaymentTypeRootClass {

    var message : String = ""
    var response : [PaymentTypeResponse]!
    var success : Bool = false

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        message = json["message"].stringValue
        response = [PaymentTypeResponse]()
        let responseArray = json["response"].arrayValue
        for responseJson in responseArray{
            let value = PaymentTypeResponse(fromJson: responseJson)
            response.append(value)
        }
        success = json["success"].boolValue
    }
}


class PaymentTypeResponse {

    var id : Int = 0
    var image : String = ""
    var name : String = ""
    var parameters : PaymentTypeParameter!
    var slug : String = ""


    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        id = json["id"].intValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        let parametersJson = json["parameters"]
        if !parametersJson.isEmpty{
            parameters = PaymentTypeParameter(fromJson: parametersJson)
        }
        slug = json["slug"].stringValue
    }
}

class PaymentTypeParameter {

    var apiKey : String = ""
    var environment : String = ""

    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        apiKey = json["api_key"].stringValue
        environment = json["environment"].stringValue
    }
}
