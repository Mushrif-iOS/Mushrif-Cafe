//
//  LanguageSelectionVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 27/09/24.
//

import UIKit

class LanguageSelectionVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .main
    
    @IBOutlet weak var laguateTitle: UILabel! {
        didSet {
            laguateTitle.font = UIFont.poppinsMediumFontWith(size: 20)
            laguateTitle.text = "language".localized()
        }
    }
    
    @IBOutlet weak var selectLabel: UILabel! {
        didSet {
            selectLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            selectLabel.text = "select_language".localized()
        }
    }
    
    @IBOutlet weak var englishLbl: UILabel! {
        didSet {
            englishLbl.font = UIFont.poppinsRegularFontWith(size: 18)
        }
    }
    @IBOutlet weak var enlishImg: UIImageView!
    
    @IBOutlet weak var arabLbl: UILabel! {
        didSet {
            arabLbl.font = UIFont.poppinsRegularFontWith(size: 18)
        }
    }
    @IBOutlet weak var arabImg: UIImageView!
    
    var languageData: [Languages] = [Languages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getLanguage()
    }
    
    private func getLanguage() {
        
        APIManager.shared.getCall(APPURL.getLanguages, withHeader: false) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"]["languages"].arrayValue
            
            for obj in dataDict {
                self.languageData.append(Languages(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.englishLbl.text = self.languageData.first?.title
                self.enlishImg.downloadImage(url: self.languageData.first?.icon) { img in
                    self.enlishImg.image = img
                }
                
                self.arabLbl.text = self.languageData.last?.title //"العربية"
                self.arabImg.downloadImage(url: self.languageData.last?.icon) { img in
                    self.arabImg.image = img
                }
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    @IBAction func englishAction(_ sender: Any) {
        UserDefaultHelper.language = "ar"
        DispatchQueue.main.async {
            let userLanguage = UserDefaultHelper.language
            UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
            UserDefaultHelper.isLanguageSelected = "yes"
            let loginVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @IBAction func arabAction(_ sender: Any) {
        UserDefaultHelper.language = "en"
        DispatchQueue.main.async {
            let userLanguage = UserDefaultHelper.language
            UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
            UserDefaultHelper.isLanguageSelected = "yes"
            let loginVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
