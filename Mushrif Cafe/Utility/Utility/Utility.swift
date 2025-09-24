//
//  Created by Trendal
//  Copyright © Trendal All rights reserved.
//  Created on 04/02/21

import Foundation
import UIKit
import AVFAudio
import  AVKit
import CoreLocation

/// Utility class for application
public class Utility {

    // MARK: - singleton sharedInstance
    static var sharedInstance = Utility()

    
    

    /// Dispatch Queue delay with compltion handler
    /// - Parameters:
    ///   - delay: delay time
    ///   - closure: compltion call back
    static func delay(_ delay: Double, closure:@escaping () -> Void) {
        
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        
        
    }
    
    
    /// This method will return a Top Most View Controller of the application's window which you wan use.
    ///
    /// - Returns: Object of the UIViewController
    public func topMostController() -> UIViewController {
        let arrWind = APPLICATION.windows
        if arrWind.count > 0 {
            if let keyWndw = APPLICATION.windows.filter({$0.isKeyWindow}).first {
                var topController: UIViewController = keyWndw.rootViewController!
                while topController.presentedViewController != nil {
                    topController = topController.presentedViewController!
                }
                return topController
            }
        }
        return UIViewController()
    }
 
  
    
    
    static var headerTimeStamp: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
    static var timestamp: String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))"
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    /// get Thumbnail image
    /// - Parameters:
    ///   - urlPath: String
    ///   - isWebPath: Bool
    ///   - block: Void
    func getThumbnail(urlPath: String, isWebPath: Bool = false, block:@escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let asset: AVAsset!
            if isWebPath {
                asset = AVAsset(url: URL(string: urlPath)!)

            } else {
                asset = AVAsset(url: URL(fileURLWithPath: urlPath))
            }

            let assetImgGenerate: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            assetImgGenerate.maximumSize = CGSize(width: 1160, height: 1160)
            assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero
            assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero

            let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            assetImgGenerate.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)], completionHandler: { (_, thumbnail, _, _, error) in
                if error == nil {
                    let frameImg  = UIImage(cgImage: thumbnail!)
                    block(frameImg)
                }
            })
        }
    }
    
    /// check distajce for cafe id ditance >  100 meeter then we need to show  alert screen elase opne table selectin
    static func  isNearByCafe(userLocation: CLLocation) -> Bool{
        let cafeLatitude = 29.273059471621497
        let cafeLongitude = 48.04890431762706
        let cafeLocation = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude)
        let distance = userLocation.distance(from: cafeLocation) // in meters
        if distance > 100 {
            return false
        } else {
            return true
        }
    }
    
    
    static func getAppVersionAndBuild() -> (version: String, build: String) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return (version, build)
    }

}

