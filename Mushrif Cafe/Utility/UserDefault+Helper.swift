//
//  UserDefault+Helper.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 27/09/24.
//

import UIKit

private enum Defaults: String {
    case countryCode = "countryCode"
    case userloginId   = "userloginid"
    case userName = "userName"
    case language = "language"
    case isLanguageSelected = "isLanguageSelected"
    case authToken = "authToken"
    case totalItems = "totalItems"
    case totalPrice = "totalPrice"
    case orderType = "orderType"
    case hallId = "hallId"
    case tableId = "tableId"
    case groupId = "groupId"
    case walletBalance = "walletBalance"
    case tableName = "tableName"
}

final class UserDefaultHelper {
    
    static var countryCode: String? {
        set {
            _set(value: newValue, key: .countryCode)
        } get {
            return _get(valueForKay: .countryCode) as? String ?? ""
        }
    }
    
    static var userloginId: String? {
        set {
            _set(value: newValue, key: .userloginId)
        } get {
            return _get(valueForKay: .userloginId) as? String ?? ""
        }
    }
    
    static var userName: String? {
        set {
            _set(value: newValue, key: .userName)
        } get {
            return _get(valueForKay: .userName) as? String ?? ""
        }
    }
    
    static var language: String? {
        set {
            _set(value: newValue, key: .language)
        } get {
            return _get(valueForKay: .language) as? String ?? "ar"
        }
    }
    
    static var isLanguageSelected: String? {
        set {
            _set(value: newValue, key: .isLanguageSelected)
        } get {
            return _get(valueForKay: .isLanguageSelected) as? String ?? "no"
        }
    }
    
    static var authToken: String? {
        set {
            _set(value: newValue, key: .authToken)
        } get {
            return _get(valueForKay: .authToken) as? String ?? ""
        }
    }
    
    static var totalItems: Int? {
        set {
            _set(value: newValue, key: .totalItems)
        } get {
            return _get(valueForKay: .totalItems) as? Int ?? 0
        }
    }
    
    static var totalPrice: Double? {
        set {
            _set(value: newValue, key: .totalPrice)
        } get {
            return _get(valueForKay: .totalPrice) as? Double ?? 0.0
        }
    }
    
    static var orderType: String? {
        set {
            _set(value: newValue, key: .orderType)
        } get {
            return _get(valueForKay: .orderType) as? String ?? ""
        }
    }
    
    static var hallId: String? {
        set {
            _set(value: newValue, key: .hallId)
        } get {
            return _get(valueForKay: .hallId) as? String ?? "0"
        }
    }
    
    static var tableId: String? {
        set {
            _set(value: newValue, key: .tableId)
        } get {
            return _get(valueForKay: .tableId) as? String ?? "0"
        }
    }
    
    static var groupId: String? {
        set {
            _set(value: newValue, key: .groupId)
        } get {
            return _get(valueForKay: .groupId) as? String ?? "0"
        }
    }
    
    static var walletBalance: String? {
        set {
            _set(value: newValue, key: .walletBalance)
        } get {
            return _get(valueForKay: .walletBalance) as? String ?? ""
        }
    }
    
    static var tableName: String? {
        set {
            _set(value: newValue, key: .tableName)
        } get {
            return _get(valueForKay: .tableName) as? String ?? ""
        }
    }
    
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func _get(valueForKay key: Defaults)-> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    static func deleteCountryCode() {
        UserDefaults.standard.removeObject(forKey: Defaults.countryCode.rawValue)
    }
    
    static func deleteUserLoginId() {
        UserDefaults.standard.removeObject(forKey: Defaults.userloginId.rawValue)
    }
    
    static func deleteUserName() {
        UserDefaults.standard.removeObject(forKey: Defaults.userName.rawValue)
    }
    
    static func deleteLanguage() {
        UserDefaults.standard.removeObject(forKey: Defaults.language.rawValue)
    }
    
    static func deleteSelectedLanguage() {
        UserDefaults.standard.removeObject(forKey: Defaults.isLanguageSelected.rawValue)
    }
    
    static func deleteAuthToken() {
        UserDefaults.standard.removeObject(forKey: Defaults.authToken.rawValue)
    }
    
    static func deleteTotalItems() {
        UserDefaults.standard.removeObject(forKey: Defaults.totalItems.rawValue)
    }
    
    static func deleteTotalPrice() {
        UserDefaults.standard.removeObject(forKey: Defaults.totalPrice.rawValue)
    }
    
    static func deleteOrderType() {
        UserDefaults.standard.removeObject(forKey: Defaults.orderType.rawValue)
    }
    
    static func deleteHallId() {
        UserDefaults.standard.removeObject(forKey: Defaults.hallId.rawValue)
    }
    
    static func deleteTableId() {
        UserDefaults.standard.removeObject(forKey: Defaults.tableId.rawValue)
    }
    
    static func deleteGroupId() {
        UserDefaults.standard.removeObject(forKey: Defaults.groupId.rawValue)
    }
    
    static func deleteWalletBalance() {
        UserDefaults.standard.removeObject(forKey: Defaults.walletBalance.rawValue)
    }
    
    static func deleteTableName() {
        UserDefaults.standard.removeObject(forKey: Defaults.tableName.rawValue)
    }
}
