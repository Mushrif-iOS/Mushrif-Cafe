//
//  AppDelegate.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 24/09/24.
//

import UIKit
import IQKeyboardManagerSwift
import Siren
import SYBanner
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //let banner = SYCardBanner(title: "error".localized(), subtitle: "no_internet".localized())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardConfiguration.overrideAppearance = true
        IQKeyboardManager.shared.keyboardConfiguration.appearance = .default
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.primaryBrown
        IQKeyboardManager.shared.toolbarConfiguration.manageBehavior = .bySubviews
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = true
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysShow
        
        Siren.shared.wail()
        Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .arabic)
        
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        NetworkReachability.shared.startNotifier()
        reachabilityObserver()
        
        self.restartApp()
        return true
    }
    
    func reachabilityObserver() {
        NetworkReachability.shared.reachabilityObserver = { [weak self] status in
            switch status {
            case .connected:
                print("Reachability: Network available 😃")
                ProgressHUD.remove()
            case .disconnected:
                print("Reachability: Network unavailable 😟")
                print(self?.window?.screen.bounds.size ?? 0.0)
                ProgressHUD.animationType = .horizontalBarScaling
                ProgressHUD.colorAnimation = UIColor.primaryBrown
                ProgressHUD.colorStatus = UIColor.primaryBrown
                ProgressHUD.animate("no_internet".localized(), interaction: false)
            }
        }
    }
    
    private func customViewDefault() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.backgroundColor = .systemGray2
        return contentView
    }
    
    private func customView() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "pizza")
        
        contentView.addSubview(imageView)
        
        return contentView
    }
    
    func getTraitColor() -> UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ? .white : UIColor.init(red: 28/255, green: 27/255, blue: 29/255, alpha: 1)
        }
    }
}

extension AppDelegate {
    
    func restartApp() {
        
        let userLanguage = UserDefaultHelper.language
        print("userLanguage.................", userLanguage ?? "")
        
        let isLanguageSelected = UserDefaultHelper.isLanguageSelected
        print("isLanguageSelected.................", isLanguageSelected ?? "no")
        
        UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let languageVC = storyboard.instantiateViewController(withIdentifier: "LanguageSelectionVC") as! LanguageSelectionVC
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        if isLanguageSelected == "yes" {
            let navigationController = UINavigationController.init(rootViewController: loginVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        } else {
            let navigationController = UINavigationController.init(rootViewController: languageVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
        
        print("UserDefaultHelper.authToken", UserDefaultHelper.authToken!)
        if UserDefaultHelper.authToken != "" {
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let scanVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            let navigationController = UINavigationController.init(rootViewController: scanVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
        
        self.window?.makeKeyAndVisible()
        
    }
    
    func afterLogout() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        let navigationController = UINavigationController.init(rootViewController: loginVC)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
    }
}
