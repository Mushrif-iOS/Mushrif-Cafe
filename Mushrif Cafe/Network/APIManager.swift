//
//  APIManager.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 11/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON
import SYBanner
import ProgressHUD

typealias SuccessHandler = (JSON) -> Void
typealias FailureHandler = (Error) -> Void

class APIManager: NSObject {
    
    static var shared = APIManager()
    
    var successResponse: SuccessHandler!
    var errorResponse: FailureHandler!
    var urlString = APPURL.getLanguages
    
    private func showLoader() {
        ProgressHUD.animationType = .circleDotSpinFade
        ProgressHUD.colorAnimation = UIColor.primaryBrown
        ProgressHUD.animate(interaction: false)
    }
    
    private func showBanner(message: String, status: LoadingStatus) {
        
        switch status {
        case .success:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .success)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.messageColor = .white
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .error:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .warning)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.messageColor = .white
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .warning:
            let styleBanner = SYDefaultBanner(message, direction: .top, style: .info)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.show()
        case .normal:
            let styleBanner = SYDefaultBanner(message, icon: nil, backgroundColor: .white, direction: .top)
            styleBanner.show(queuePosition: .front)
            styleBanner.messageFont = UIFont.poppinsLightFontWith(size: 14)
            styleBanner.dismissOnSwipe = true
            styleBanner.autoDismiss = true
            styleBanner.messageColor = UIColor.primaryBrown
            styleBanner.show()
        }
    }
    
    // MARK: - Get Methods
    
    func getCall(_ strURL: String, withHeader: Bool, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            print(strURL)
            print(headers)
            
            AF.request(urlString, method: .get, headers: withHeader ? headers : nil).responseJSON { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                if let error = responseObj.error {
                    failure(error)
                    self.showBanner(message: error.localizedDescription, status: .error)
                    ProgressHUD.dismiss()
                } else {
                    if let responseData = responseObj.data {
                        
                        let data = JSON(responseData)
                        
                        if data["success"].bool == true {
                            success(data)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: data["message"].stringValue, status: .error)
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .error)
        }
    }
    
    func getCallWithParams(_ strURL: String, params: [String: Any]?, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            print(strURL)
            print(headers)
            
            AF.request(strURL, method: .get, parameters: params, headers: headers).responseJSON { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                if let error = responseObj.error {
                    failure(error)
                    self.showBanner(message: error.localizedDescription, status: .error)
                    ProgressHUD.dismiss()
                } else {
                    if let responseData = responseObj.data {
                        
                        let data = JSON(responseData)
                        
                        if data["success"].bool == true {
                            success(data)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: data["message"].stringValue, status: .error)
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .error)
        }
    }
    
    // MARK: - Post Methods
    
    func postCall(_ strURL: String, params: [String: Any]?, withHeader: Bool, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            let fullUrl = (strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            print(fullUrl)
            print(headers)
            
            AF.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: withHeader ? headers : nil).responseJSON { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                if let error = responseObj.error {
                    failure(error)
                    ProgressHUD.dismiss()
                    self.showBanner(message: error.localizedDescription, status: .error)
                } else {
                    if let responseData = responseObj.data {
                        
                        let data = JSON(responseData)
                        
                        if data["success"].bool == true {
                            success(data)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: data["message"].stringValue, status: .error)
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .error)
        }
    }
    
    // MARK: - Put Methods
    
    func putCall(_ strURL: String, params: [String: Any]?, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            let fullUrl = (strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            print(fullUrl)
            print(headers)
            
            AF.request(fullUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                if let error = responseObj.error {
                    failure(error)
                    ProgressHUD.dismiss()
                    self.showBanner(message: error.localizedDescription, status: .error)
                } else {
                    if let responseData = responseObj.data {
                        
                        let data = JSON(responseData)
                        
                        if data["success"].bool == true {
                            success(data)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: data["message"].stringValue, status: .error)
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .error)
        }
    }
    
    // MARK: - Login Methods
    func loginWithRetry(
        to url: String,
        parameters: [String: String],
        maxRetries: Int,
        currentRetry: Int = 0,
        showLoader: Bool = true,
        completion: @escaping (Result<OTPResponse, AFError>) -> Void) {
            
            if SingleTon.isInternetAvailable() {
                
                if showLoader, currentRetry == 0 {
                    DispatchQueue.main.async {
                        self.showLoader()
                    }
                }
                
                let fullUrl = (url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                print(fullUrl)
                
                AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
                    .validate()
                    .responseJSON { response in
                        
                        if let statusCode = response.response?.statusCode {
                            print("HTTP Status Code: \(statusCode)")
                            
                            if statusCode == 401 {
                                self.logoutUserAndRedirectToLogin()
                            }
                        }
                        
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            let otpResponse = OTPResponse(json: json)
                            DispatchQueue.main.async {
                                ProgressHUD.dismiss()
                            }
                            completion(.success(otpResponse))
                        case .failure(let error):
                            
                            if currentRetry < maxRetries {
                                print("Retrying... Attempt \(currentRetry + 1)")
                                self.loginWithRetry(
                                    to: url,
                                    parameters: parameters,
                                    maxRetries: maxRetries,
                                    currentRetry: currentRetry + 1,
                                    showLoader: false,
                                    completion: completion
                                )
                            } else {
                                // Hide loader after failure
                                DispatchQueue.main.async {
                                    ProgressHUD.dismiss()
                                }
                                completion(.failure(error))
                                self.showBanner(message: error.localizedDescription, status: .error)
                            }
                        }
                    }
            } else {
                self.showBanner(message: "no_internet".localized(), status: .error)
            }
        }
    
    func logoutUserAndRedirectToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UserDefaultHelper.deleteCountryCode()
            UserDefaultHelper.deleteUserLoginId()
            UserDefaultHelper.deleteUserName()
            UserDefaultHelper.deleteUserEmail()
            UserDefaultHelper.deleteMobile()
            UserDefaultHelper.deleteAuthToken()
            UserDefaultHelper.deleteTotalItems()
            UserDefaultHelper.deleteTotalPrice()
            UserDefaultHelper.deletePaymentKey()
            UserDefaultHelper.deletePaymentEnv()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.afterLogout()
        }
    }
}
