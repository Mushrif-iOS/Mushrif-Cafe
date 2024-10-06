//
//  Extensions.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
import SafariServices

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
    case profile = "Profile"
    case cart = "Cart"
}

protocol Instantiatable {
    static var storyboard: AppStoryboard { get }
    static func instantiate() -> Self
}

extension Instantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        // swiftlint:disable force_cast
        UIStoryboard(storyboard).instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}

extension UIStoryboard {
    convenience init(_ storyboard: AppStoryboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }
}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
    }
}

extension String {
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func localized() -> String {
        if let appLanguage = UserDefaultHelper.language {
            if appLanguage == "ar" {
                let path = Bundle.main.path(forResource: "ar", ofType: "lproj")
                let bundle = Bundle(path: path!)
                return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
            }
        }
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle!, value: self, comment: self)
    }
    
    func getAcronym() -> String {
        let array = components(separatedBy: .whitespaces)
        return String(array.reduce("") { $0 + String($1.first!)}.prefix(2))
    }
}

extension String {
    private static let formatter = NumberFormatter()
    
    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
    
    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }
        
        Self.formatter.locale = locale
        
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }
        
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        let userLanguage = UserDefaultHelper.language
        if userLanguage == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        }
    }
}

public extension UINavigationController {

    func pop(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }

    func push(viewController vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }

    private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func toRoundedString(toPlaces places:Int) -> String {
        let amount = self.rounded(toPlaces: places)
        let str_mount = String(amount)
        
        let sub_amountStrings = str_mount.split(separator: ".")
        
        if sub_amountStrings.count == 1
        {
            var re_str = "\(sub_amountStrings[0])."
            for _ in 0..<places
            {
                re_str += "0"
            }
            return re_str
            
        }
        else if sub_amountStrings.count > 1, "\(sub_amountStrings[1])".count < places
        {
            var re_str = "\(sub_amountStrings[0]).\(sub_amountStrings[1])"
            let tem_places = (places -  "\(sub_amountStrings[1])".count)
            for _ in 0..<tem_places
            {
                re_str += "0"
            }
            return re_str
        }
        
        return str_mount
    }
}

class AlertView {

    static func show(title:String? = Bundle.applicationName, message:String?, preferredStyle: UIAlertController.Style = .alert, buttons: [String], completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        for button in buttons {

            var style = UIAlertAction.Style.default
            let buttonText = button.lowercased().replacingOccurrences(of: " ", with: "")
            if buttonText == "cancel".localized() {
                style = .cancel
            }
            let action = UIAlertAction(title: button, style: style) { (_) in
                completionHandler(button)
            }
            alert.addAction(action)
        }

        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let rootViewController = app.window?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension Bundle {
    class var applicationName: String {

        if let displayName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name: String = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return "No Name Found"
    }
}

extension UIViewController {
    func showWebView(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }
}
