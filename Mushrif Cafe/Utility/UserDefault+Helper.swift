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
    case language = "language"
    case isLanguageSelected = "isLanguageSelected"
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
    
    static func deleteLanguage() {
        UserDefaults.standard.removeObject(forKey: Defaults.language.rawValue)
    }
    
    static func deleteSelectedLanguage() {
        UserDefaults.standard.removeObject(forKey: Defaults.isLanguageSelected.rawValue)
    }
}
