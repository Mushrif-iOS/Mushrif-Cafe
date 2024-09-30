//
//  Extensions.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
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
