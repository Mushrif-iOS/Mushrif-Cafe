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
                            self.showBanner(message: "something_wrong".localized(), status: .error)
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
                            self.showBanner(message: "something_wrong".localized(), status: .error)
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
                            self.showBanner(message: "something_wrong".localized(), status: .error)
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
                            self.showBanner(message: "something_wrong".localized(), status: .error)
                            ProgressHUD.dismiss()
                        }
                    }
                }
            }
        } else {
            self.showBanner(message: "no_internet".localized(), status: .error)
        }
    }
}
