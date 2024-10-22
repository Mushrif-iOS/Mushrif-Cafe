//
//  SingleTon.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 09/10/24.
//

import UIKit
import Reachability

class SingleTon: NSObject {
    static let sharedSingleTon = SingleTon()
    
    //Chek internet conectivity
    class func isInternetAvailable() -> Bool {
        var status: Bool
        let reachability = try! Reachability()
        switch reachability.connection {
        case .wifi:
            debugPrint("Network reachable through WiFi")
            status = true
        case .cellular:
            status = true
            debugPrint("Network reachable through Cellular Data")
        case .unavailable:
            debugPrint("Network unreachable")
            status = false
        }
        return status
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    //MARK: - Dict to JSON and JSON to Dict
    class func dictionaryToJSON(dict: NSDictionary) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict)
            if let json = String(data: jsonData, encoding: .utf8) {
                return json
            }
        } catch {
            print("something went wrong with parsing json:\(error)")
        }
        return nil
    }
    
    class func jsonToDictionary(jsonStr: String) -> [String: Any]? {
        let data = Data(jsonStr.utf8)
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            {
                return json
            }
        }  catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return nil
    }
    
    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        return ""
    }
}
