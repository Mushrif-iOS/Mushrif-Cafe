//
//  APIManager.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 11/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

typealias SuccessHandler = (JSON) -> Void
typealias FailureHandler = (Error) -> Void

class APIManager: NSObject {
    
    static var shared = APIManager()
    
    var successResponse: SuccessHandler!
    var errorResponse: FailureHandler!
    var urlString = APPURL.getLanguages
    
    private let session: Session
    
    override init() {
        self.session = Session(interceptor: NetworkRetryInterceptor())
        super.init()
    }
    
    private func showLoader() {
        ProgressHUD.animationType = .circleDotSpinFade
        ProgressHUD.colorAnimation = UIColor.primaryBrown
        ProgressHUD.animate(interaction: false)
    }
    
    private func showBanner(message: String, status: BannerType) {
        let banner = StatusBanner(type: status, message: message)
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }),
              let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("No key window found!")
            return
        }
        banner.show(in: window, duration: 2.0)
    }
    
    private func friendlyErrorMessage(for statusCode: Int) -> String? {
        switch statusCode {
        case 429:
            return "Too many requests. Please wait a moment and try again."
        case 500...599:
            return "The server is having trouble right now. Please try again shortly."
        default:
            return nil
        }
    }
    
    private func serverMessage(from data: Data?) -> String? {
        guard let data = data, let json = try? JSON(data: data) else { return nil }
        let candidates: [String?] = [
            json["message"].string,
            json["error_description"].string,
            json["error"].string,
            json["msg"].string
        ]
        return candidates
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty }
    }
    
    // MARK: - Get Methods
    
    func getCall(_ strURL: String, withHeader: Bool, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            print("URL" , strURL)
            print("TYPE" , "GET")
            // Always use the URL passed to this function. Avoid responseJSON to gracefully handle non-JSON bodies.
            session.request(strURL, method: .get, headers: withHeader ? headers : nil)
                .validate(statusCode: 200..<300)
                .responseData { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                switch responseObj.result {
                case .failure(let error):
                    if let raw = responseObj.data.flatMap({ String(data: $0, encoding: .utf8) }) { print("Raw body (GET): \n\(raw)") }
                    failure(error)
                    if let message = self.serverMessage(from: responseObj.data) {
                        self.showBanner(message: message, status: .failed)
                    } else if let code = responseObj.response?.statusCode, let msg = self.friendlyErrorMessage(for: code) {
                        self.showBanner(message: msg, status: .failed)
                    } else {
                        self.showBanner(message: error.localizedDescription, status: .failed)
                    }
                    ProgressHUD.dismiss()
                case .success(let responseData):
                    // Try to parse JSON; if it fails, log raw string and surface a friendly error
                    if let json = try? JSON(data: responseData) {
                        if json["success"].bool == true {
                            success(json)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: json["message"].stringValue, status: .failed)
                            ProgressHUD.dismiss()
                        }
                    } else {
                        if let raw = String(data: responseData, encoding: .utf8) { print("Non-JSON body (GET): \n\(raw)") }
                        self.showBanner(message: "Invalid server response", status: .failed)
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .failed)
        }
    }
    
    func getCallWithParams(_ strURL: String, params: [String: Any]?, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            print(strURL)
            print(headers)
            
            session.request(strURL, method: .get, parameters: params, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                switch responseObj.result {
                case .failure(let error):
                    if let raw = responseObj.data.flatMap({ String(data: $0, encoding: .utf8) }) { print("Raw body (GET params): \n\(raw)") }
                    failure(error)
                    if let message = self.serverMessage(from: responseObj.data) {
                        self.showBanner(message: message, status: .failed)
                    } else if let code = responseObj.response?.statusCode, let msg = self.friendlyErrorMessage(for: code) {
                        self.showBanner(message: msg, status: .failed)
                    } else {
                        self.showBanner(message: error.localizedDescription, status: .failed)
                    }
                    ProgressHUD.dismiss()
                case .success(let responseData):
                    if let json = try? JSON(data: responseData) {
                        if json["success"].bool == true {
                            success(json)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: json["message"].stringValue, status: .failed)
                            ProgressHUD.dismiss()
                        }
                    } else {
                        if let raw = String(data: responseData, encoding: .utf8) { print("Non-JSON body (GET params): \n\(raw)") }
                        self.showBanner(message: "Invalid server response", status: .failed)
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .failed)
        }
    }
    
    // MARK: - Post Methods
    
    func postCall(_ strURL: String, params: [String: Any]?, withHeader: Bool, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            let fullUrl = (strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            print("URL" , fullUrl)
            print("HEADER" , headers)
            print("PARAM" , params as Any)
            print("TYPE" , "POST")
            session.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: withHeader ? headers : nil)
                .validate(statusCode: 200..<300)
                .responseData { responseObj in
                    
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                switch responseObj.result {
                case .failure(let error):
                    if let raw = responseObj.data.flatMap({ String(data: $0, encoding: .utf8) }) { print("Raw body (POST): \n\(raw)") }
                    failure(error)
                    ProgressHUD.dismiss()
                    if let message = self.serverMessage(from: responseObj.data) {
                        self.showBanner(message: message, status: .failed)
                    } else if let code = responseObj.response?.statusCode, let msg = self.friendlyErrorMessage(for: code) {
                        self.showBanner(message: msg, status: .failed)
                    } else {
                        self.showBanner(message: error.localizedDescription, status: .failed)
                    }
                case .success(let responseData):
                    if let json = try? JSON(data: responseData) {
                        if json["success"].bool == true {
                            success(json)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: json["message"].stringValue, status: .failed)
                            ProgressHUD.dismiss()
                        }
                    } else {
                        if let raw = String(data: responseData, encoding: .utf8) { print("Non-JSON body (POST): \n\(raw)") }
                        self.showBanner(message: "Invalid server response", status: .failed)
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .failed)
        }
    }
    
    // MARK: - Put Methods
    
    func putCall(_ strURL: String, params: [String: Any]?, success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        
        if SingleTon.isInternetAvailable() {
            
            self.showLoader()
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(UserDefaultHelper.authToken ?? "")"]
            
            let fullUrl = (strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            print(fullUrl)
            print(headers)
            
            session.request(fullUrl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { responseObj in
                
                if let statusCode = responseObj.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                    
                    if statusCode == 401 {
                        self.logoutUserAndRedirectToLogin()
                    }
                }
                
                switch responseObj.result {
                case .failure(let error):
                    if let raw = responseObj.data.flatMap({ String(data: $0, encoding: .utf8) }) { print("Raw body (PUT): \n\(raw)") }
                    failure(error)
                    ProgressHUD.dismiss()
                    if let message = self.serverMessage(from: responseObj.data) {
                        self.showBanner(message: message, status: .failed)
                    } else if let code = responseObj.response?.statusCode, let msg = self.friendlyErrorMessage(for: code) {
                        self.showBanner(message: msg, status: .failed)
                    } else {
                        self.showBanner(message: error.localizedDescription, status: .failed)
                    }
                case .success(let responseData):
                    if let json = try? JSON(data: responseData) {
                        if json["success"].bool == true {
                            success(json)
                            ProgressHUD.dismiss()
                        } else {
                            self.showBanner(message: json["message"].stringValue, status: .failed)
                            ProgressHUD.dismiss()
                        }
                    } else {
                        if let raw = String(data: responseData, encoding: .utf8) { print("Non-JSON body (PUT): \n\(raw)") }
                        self.showBanner(message: "Invalid server response", status: .failed)
                        ProgressHUD.dismiss()
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .failed)
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
                                if let message = self.serverMessage(from: response.data) {
                                    self.showBanner(message: message, status: .failed)
                                } else {
                                    self.showBanner(message: error.localizedDescription, status: .failed)
                                }
                            }
                        }
                    }
            } else {
                self.showBanner(message: "no_internet".localized(), status: .failed)
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
