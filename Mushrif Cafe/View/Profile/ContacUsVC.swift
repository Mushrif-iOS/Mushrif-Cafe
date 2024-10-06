//
//  ContacUsVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import ProgressHUD

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
            fullName.text = "full_name".localized()
        }
    }
    
    @IBOutlet weak var txtFullName: UITextField! {
        didSet {
            txtFullName.font = UIFont.poppinsMediumFontWith(size: 16)
            txtFullName.tintColor = UIColor.primaryBrown
        }
    }
    
    @IBOutlet weak var msgTitle: UILabel! {
        didSet {
            msgTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            msgTitle.text = "message".localized()
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
        
        ProgressHUD.success()
    }
}
