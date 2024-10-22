//
//  WebService.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 09/10/24.
//

import UIKit
import Alamofire
/*
class WebService: NSObject {
    //MARK: - Data to JSON
    class func dataToJSON(data: Data) -> Any?  {
        
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            print(string)
        }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    //MARK: GET Method
    class func GetURL(url: String, dict: Dictionary<String, Any>, completion: @escaping (_ responceData: Dictionary<String, Any>, _ success: Bool) -> ()) {
        if SingleTon.isInternetAvailable()  {
            
            print("\n\nGET API: \(url)")
            print("PARAMETER: \(dict as NSDictionary)")
            print("\n\nTOKEN: \(UserDefaultHelper.authToken ?? "")")
            
            //set Headers
            //let headers: HTTPHeaders = ["Content-Type": "application/json"]
            var reuqestHeaders = HTTPHeaders()
            reuqestHeaders = [
                "Authorization": "Bearer "+(UserDefaultHelper.authToken ?? ""),
                "Content-Type": "application/json"]
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: reuqestHeaders).responseData { (response) in
                switch response.result {
                case .success(_):
                    if let value = response.value {
                        let json = dataToJSON(data: value)
                        print("\n\nGET API: \(url)")
                        print(json as! NSDictionary)
                        print("\n\n")
                        let data = json as! [String:Any]
                        if Int(data["statusCode"] as! Int) == 200 {
                            completion(data,true)
                        } else {
                            completion(data,false)
                        }
                    }
                    break
                case .failure(_):
                    print("\n\nGET API: \(url)")
                    print(response.error!)
                    print("\n\n")
                    
                    if response.response?.statusCode == 401  {
                        ProgressHUD.failed("Unauthorized")
                    } else {
                        let msg = "\(response.error?.localizedDescription ?? "")\n\(url)"
                        let temp = NSDictionary.init(object: msg, forKey: "err_msg" as NSCopying)
                        completion(temp as! Dictionary<String, Any>, false)
                        break
                    }
                }
            }
        } else {
            let temp = NSDictionary.init(object: INTERNET_ERROR, forKey: "err_msg" as NSCopying)
            completion(temp as! Dictionary<String, Any>,false)
        }
    }

    
    //MARK: -POST Method
    class func PostURL(url: String, dict:Dictionary<String, Any>, completion: @escaping (_ responceData:Dictionary<String, Any>, _ success: Bool) -> ())
    {
        if SingleTon.isInternetAvailable()
        {
            let fullUrl = APIURL + (url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
            print("POST API: \(fullUrl)")
            print("PARAMETER: \(dict as NSDictionary)")
            
            //set Headers
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded",
                                        "Accept": "application/json; text/html; text/plain"]
            
            AF.request(fullUrl, method: .post, parameters: dict, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
                switch response.result
                {
                case .success(_):
                    if let value = response.value
                    {
                        let json = dataToJSON(data: value)
                        print("\n\nPOST API: \(fullUrl)")
                        print(json as! NSDictionary)
                        print("\n\n")
                        let data = json as! [String:Any]
                        if (data["status"] as? String) == "success"
                        {
                            completion(data,true)
                        }
                        else
                        {
                            completion(data,false)
                        }
                    }
                    break
                case .failure(_):
                    print("\n\nPOST API: \(fullUrl)")
                    print(response.error!)
                    print("\n\n")
                    
                    if response.response?.statusCode == 401
                    {
                        SingleTon.showAlertonView(UIApplication.topViewController(), withAlertTitle: ALERT_TITLE, buttonOkTitle: ALERT_OK, andMessage:SESSION_EXPIRED) { (action) in
                        }
                    }
                    else
                    {
                        let msg = "\(response.error?.localizedDescription ?? ERROR)\n\(fullUrl)"
                        let temp=NSDictionary.init(object: msg, forKey: "err_msg" as NSCopying)
                        completion(temp as! Dictionary<String, Any>,false)
                        break
                    }
                }
            }
        }
        else
        {
            let temp=NSDictionary.init(object: INTERNET_ERROR, forKey: "err_msg" as NSCopying)
            completion(temp as! Dictionary<String, Any>,false)
        }
    }
    
    class func PostURLWithMultipart(url: String, requestFor: String, dict:Dictionary<String, Any>, completion: @escaping (_ responceData:Dictionary<String, Any>, _ success: Bool) -> ())
    {
        if SingleTon.isInternetAvailable()
        {
            let fullUrl = APIURL +  (url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            print("\n\nPOST API: \(fullUrl)")
            print("PARAMETER: \(dict as NSDictionary)")
            
            var reuqestHeaders = HTTPHeaders()
            
            if "\(SingleTon.readString(Key: UserDefaultsKeys.Token) ?? "")".count > 0
            {
                reuqestHeaders = [
                    "Authorization": "Bearer "+(SingleTon.readString(Key: UserDefaultsKeys.Token) ?? ""),
                    "Content-Type": "multipart/form-data"]
            }
            else
            {
                reuqestHeaders = [
                    "Content-Type": "multipart/form-data"]
            }
            
            AF.upload(multipartFormData:
                        { (multipartFormData) in
                //other params
                for (key, value) in dict
                {
                    if let boolvalue:Bool =  value as? Bool
                    {
                        multipartFormData.append(Bool(boolvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let intvalue:Int =  value as? Int
                    {
                        multipartFormData.append(Int(intvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let arrayvalue:Array =  value as? Array<Any>
                    {
                        multipartFormData.append(Array(arrayvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let arrayvalue:Array =  value as? Array<Any>
                    {
                        multipartFormData.append(Array(arrayvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let datavalue:Data =  value as? Data
                    {
                        multipartFormData.append(Data(datavalue).description.data(using: .utf8)!, withName: key)
                    }
                    else
                    {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                //Response
            }, to: fullUrl, method: .post, headers: reuqestHeaders).responseData(completionHandler: { (response) in
                switch response.result
                {
                case .success(_):
                    if let value = response.value
                    {
                        let json = dataToJSON(data: value)
                        print("\n\nPOST API: \(fullUrl)")
                        print(json as! NSDictionary)
                        print("\n\n")
                        let data = json as! [String:Any]
                        if (data["statusCode"] as? Int) == 200
                        {
                            completion(data,true)
                        }
                        else
                        {
                            completion(data,false)
                        }
                    }
                    break
                case .failure(_):
                    print("\n\nPOST API: \(fullUrl)")
                    print(response.error!)
                    print("\n\n")
                    
                    if response.response?.statusCode == 401
                    {
                        SingleTon.showAlertonView(UIApplication.topViewController(), withAlertTitle: ALERT_TITLE, buttonOkTitle: ALERT_OK, andMessage:SESSION_EXPIRED) { (action) in
                        }
                    }
                    else
                    {
                        let msg = "\(response.error?.localizedDescription ?? ERROR)\n\(fullUrl)"
                        let temp=NSDictionary.init(object: msg, forKey: "err_msg" as NSCopying)
                        completion(temp as! Dictionary<String, Any>,false)
                        break
                    }
                }
            })
        }
        else
        {
            let temp=NSDictionary.init(object: INTERNET_ERROR, forKey: "message" as NSCopying)
            completion(temp as! Dictionary<String, Any>,false)
        }
    }
    
    //MARK: -Upload Multipart Method
    class func PostURLWithImageDate(url: String, dict:Dictionary<String, Any>, imageData: Data, completion: @escaping (_ responceData:Dictionary<String, Any>, _ success: Bool) -> ())
    {
        if SingleTon.isInternetAvailable()
        {
            
            let fullUrl = APIURL + url
            print("MALTIPART API: \(fullUrl)")
            print("PARAMETER: \(dict as NSDictionary)")
            
            //set Headers
            var headers = HTTPHeaders()
            //let headers: HTTPHeaders = ["Content-Type": "image/jpeg"]
            if "\(SingleTon.readString(Key: UserDefaultsKeys.Token) ?? "")".count > 0
            {
                headers = [
                    "Authorization": "Bearer "+(SingleTon.readString(Key: UserDefaultsKeys.Token) ?? ""),
                    "Content-Type": "application/json"]
            }
            else
            {
                headers = ["Content-Type": "image/jpeg"]
            }
            AF.upload(multipartFormData: { (multipartFormData) in
                
                //images
                multipartFormData.append(imageData, withName: "Image", fileName: "Image.jpg", mimeType: "image/jpg")
                
                //other params
                for (key, value) in dict
                {
                    if let boolvalue:Bool =  value as? Bool
                    {
                        multipartFormData.append(Bool(boolvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let intvalue:Int =  value as? Int
                    {
                        multipartFormData.append(Int(intvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let arrayvalue:Array =  value as? Array<Any>
                    {
                        multipartFormData.append(Array(arrayvalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let datavalue:Data =  value as? Data
                    {
                        multipartFormData.append(Data(datavalue).description.data(using: .utf8)!, withName: key)
                    }
                    else if let doublevalue:Double =  value as? Double
                    {
                        multipartFormData.append(Double(doublevalue).description.data(using: .utf8)!, withName: key)
                    }
                    else
                    {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
                //Response
            }, to: fullUrl, method: .post, headers: headers).responseData(completionHandler: { (response) in
                switch response.result
                {
                case .success(_):
                    if let value = response.value
                    {
                        let json = dataToJSON(data: value)
                        print(json as! NSDictionary)
                        let data = json as! [String:Any]
                        if Int(data["statusCode"] as! Int) == 200
                        {
                            completion(data,true)
                        }
                        else
                        {
                            completion(data,false)
                        }
                    }
                    break
                case .failure(_):
                    print("\n\nMALTIPART API: \(fullUrl)")
                    print(response.error!)
                    print("\n\n")
                    
                    if response.response?.statusCode == 401
                    {
                        SingleTon.showAlertonView(UIApplication.topViewController(), withAlertTitle: ALERT_TITLE, buttonOkTitle: ALERT_OK, andMessage:SESSION_EXPIRED) { (action) in
                            
                        }
                    }
                    else
                    {
                        let msg = "\(response.error?.localizedDescription ?? ERROR)\n\(fullUrl)"
                        let temp=NSDictionary.init(object: msg, forKey: "err_msg" as NSCopying)
                        completion(temp as! Dictionary<String, Any>,false)
                        break
                    }
                }
                //upload progress
            }).uploadProgress { (progrss) in
                print("Upload Progress: \(progrss.fractionCompleted)")
            }
        }
        else {
            let temp=NSDictionary.init(object: INTERNET_ERROR, forKey: "err_msg" as NSCopying)
            completion(temp as! Dictionary<String, Any>,false)
        }
    }
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
*/
