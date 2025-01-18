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
import MFSDK

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
        
        
        MFSettings.shared.configure(token: UserDefaultHelper.paymentKey ?? "",
                                    country: .kuwait, environment: UserDefaultHelper.paymentEnv == "sandbox" ? .test : .live)
        
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.primaryBrown, navigationTitle: "payment".localized(), cancelButtonTitle: "cancel".localized())
        MFSettings.shared.setTheme(theme: them)
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let paymentId = url[MFConstants.paymentId] {
            NotificationCenter.default.post(name: .applePayCheck, object: paymentId)
        }
        return true
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
        //let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        if isLanguageSelected == "yes" {
//            let navigationController = UINavigationController.init(rootViewController: loginVC)
//            navigationController.isNavigationBarHidden = true
//            self.window?.rootViewController = navigationController
            let scanSB = UIStoryboard.init(name: "Home", bundle: nil)
            let scanVC = scanSB.instantiateViewController(withIdentifier: "ScanTableVC") as! ScanTableVC
            let navigationController = UINavigationController.init(rootViewController: scanVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        } else {
            let navigationController = UINavigationController.init(rootViewController: languageVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
        
        print("UserDefaultHelper.authToken", UserDefaultHelper.authToken!)
        if UserDefaultHelper.orderType != "" {
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let scanVC = storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            let navigationController = UINavigationController.init(rootViewController: scanVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
        
        self.window?.makeKeyAndVisible()
        
    }
    
    func afterLogout() {
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        
//        let navigationController = UINavigationController.init(rootViewController: loginVC)
//        navigationController.isNavigationBarHidden = true
//        self.window?.rootViewController = navigationController
        let scanSB = UIStoryboard.init(name: "Home", bundle: nil)
        let scanVC = scanSB.instantiateViewController(withIdentifier: "ScanTableVC") as! ScanTableVC
        let navigationController = UINavigationController.init(rootViewController: scanVC)
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
