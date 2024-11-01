//
//  WalletModel.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 15/10/24.
//

import Foundation
import SwiftyJSON

class WalletRoot {
    
    var message : String = ""
    var response : WalletResponse!
    var success : Bool = false
    
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        message = json["message"].stringValue
        let responseJson = json["response"]
        if !responseJson.isEmpty{
            response = WalletResponse(fromJson: responseJson)
        }
        success = json["success"].boolValue
    }
}

class WalletResponse {
    
    var balance : String = ""
    var id : Int = Int()
    var transactions : [Transaction]!
    var userId : Int = Int()
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        balance = json["balance"].stringValue
        id = json["id"].intValue
        transactions = [Transaction]()
        let transactionsArray = json["transactions"].arrayValue
        for transactionsJson in transactionsArray{
            let value = Transaction(fromJson: transactionsJson)
            transactions.append(value)
        }
        userId = json["user_id"].intValue
    }
}

class Transaction {
    
    var amount : String = ""
    var descriptionField : String = ""
    var id : Int = Int()
    var recordId : Int = Int()
    var transactionDate : String = ""
    var txnType : String = ""
    var walletId : Int = Int()
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        amount = json["amount"].stringValue
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        recordId = json["record_id"].intValue
        transactionDate = json["transaction_date"].stringValue
        txnType = json["txn_type"].stringValue
        walletId = json["wallet_id"].intValue
    }
}
