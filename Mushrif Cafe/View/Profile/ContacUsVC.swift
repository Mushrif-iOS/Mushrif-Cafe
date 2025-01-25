//
//  ContacUsVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
//import ProgressHUD

class ContacUsVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
            titleText.text = "contact_us".localized()
        }
    }
    
    @IBOutlet weak var fullName: UILabel! {
        didSet {
            fullName.font = UIFont.poppinsRegularFontWith(size: 16)
            fullName.text = "\("full_name".localized())*"
        }
    }
    
    @IBOutlet weak var txtFullName: UITextField! {
        didSet {
            txtFullName.font = UIFont.poppinsMediumFontWith(size: 16)
            txtFullName.tintColor = UIColor.primaryBrown
            txtFullName.setPlaceholderColor(UIColor.black.withAlphaComponent(0.6))
        }
    }
    
    @IBOutlet weak var msgTitle: UILabel! {
        didSet {
            msgTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            msgTitle.text = "\("message".localized())*"
        }
    }
    
    @IBOutlet weak var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            descLabel.tintColor = UIColor.primaryBrown
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("send".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if txtFullName.text!.isEmpty {
//            ProgressHUD.fontBannerTitle = UIFont.poppinsMediumFontWith(size: 18)
//            ProgressHUD.fontBannerMessage = UIFont.poppinsLightFontWith(size: 14)
//            ProgressHUD.colorBanner = UIColor.red
//            ProgressHUD.banner("error".localized(), "name_error".localized())
            self.showBanner(message: "name_error".localized(), status: .error)
        } else if descLabel.text!.isEmpty {
//            ProgressHUD.fontBannerTitle = UIFont.poppinsMediumFontWith(size: 18)
//            ProgressHUD.fontBannerMessage = UIFont.poppinsLightFontWith(size: 14)
//            ProgressHUD.colorBanner = UIColor.red
//            ProgressHUD.banner("error".localized(), "message_error".localized())
            self.showBanner(message: "message_error".localized(), status: .error)
        } else {
            
            let aParams: [String: Any] = ["name": "\(self.txtFullName.text!)", "message": "\(self.descLabel.text!)"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.submit_feedback, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                            
                let msg = responseJSON["message"].stringValue
                print(msg)
                
                self.showBanner(message: msg, status: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
