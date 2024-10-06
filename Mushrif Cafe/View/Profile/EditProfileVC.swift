//
//  EditProfileVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import ProgressHUD

class EditProfileVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
            titleText.text = "complete_profile".localized()
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
    
    @IBOutlet weak var emailTitle: UILabel! {
        didSet {
            emailTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            emailTitle.text = "email".localized()
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.font = UIFont.poppinsMediumFontWith(size: 16)
            txtEmail.tintColor = UIColor.primaryBrown
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("update".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var deleteBtn: UIButton! {
        didSet {
            deleteBtn.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            deleteBtn.setTitle("delete_account".localized(), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {

        if txtEmail.text?.isValidEmail == false {
            ProgressHUD.banner("error".localized(), "email_error".localized())
        } else {
            DispatchQueue.main.async {
                UserDefaultHelper.userloginId = "Bhushan"
                let scanVC = ScanTableVC.instantiate()
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        AlertView.show(message: "Are you sure ?", preferredStyle: .alert, buttons: ["delete".localized(), "cancel".localized()]) { (button) in
            if button == "delete".localized() {
                print("Done")
            }
        }
    }
}
