//
//  AppDelegate.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 24/09/24.
//

import UIKit
import IQKeyboardManagerSwift
import Siren

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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
        
        if UserDefaultHelper.userloginId == "Bhushan" {
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let scanVC = storyboard.instantiateViewController(withIdentifier: "ScanTableVC") as! ScanTableVC
            let navigationController = UINavigationController.init(rootViewController: scanVC)
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

