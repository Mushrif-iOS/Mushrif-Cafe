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
    
    @IBOutlet weak var emailTitle: UILabel! {
        didSet {
            emailTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            emailTitle.text = "\("email".localized())"
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.font = UIFont.poppinsMediumFontWith(size: 16)
            txtEmail.tintColor = UIColor.primaryBrown
            txtEmail.setPlaceholderColor(UIColor.black.withAlphaComponent(0.6))
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
    
    var nameValue: String = ""
    var email: String = ""
    
    var customerData: Customer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtFullName.text = self.nameValue
        txtEmail.text = self.email
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if txtFullName.text!.isEmpty {
            self.showBanner(message: "name_error".localized(), status: .failed)
        } else if !(self.txtEmail.text?.count == 0) && txtEmail.text?.isValidEmail == false {
            self.showBanner(message: "email_error".localized(), status: .failed)
        } else {
            
            let aParams: [String: Any] = ["name": "\(self.txtFullName.text!)", "email": "\(self.txtEmail.text!)"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.updateProfile, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let dataDict = responseJSON["response"].dictionaryValue
                
                let custata = dataDict["customer"]
                self.customerData = Customer(fromJson: custata)
                
                print("Customer Data", self.customerData!.name)
                UserDefaultHelper.userName = "\(self.customerData?.name ?? "")"
                UserDefaultHelper.userEmail = "\(self.customerData?.email ?? "")"
                UserDefaultHelper.mobile = "\(self.customerData?.phone ?? "")"
                
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
    
    @IBAction func deleteAction(_ sender: Any) {
        
        AlertView.show(message: "Are you sure ?", preferredStyle: .alert, buttons: ["cancel".localized(), "delete".localized()]) { (button) in
            if button == "delete".localized() {
                
                let aParams: [String: Any] = [:]
                
                APIManager.shared.getCallWithParams(APPURL.deleteProfile, params: aParams) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    
                    let msg = responseJSON["message"].stringValue
                    print(msg)
                    
                    //self.showBanner(message: msg, status: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UserDefaultHelper.deleteCountryCode()
                        UserDefaultHelper.deleteUserLoginId()
                        UserDefaultHelper.deleteUserName()
                        UserDefaultHelper.deleteUserEmail()
                        UserDefaultHelper.deleteMobile()
                        UserDefaultHelper.deleteAuthToken()
                        UserDefaultHelper.deleteTotalItems()
                        UserDefaultHelper.deleteTotalPrice()
                        UserDefaultHelper.deletePaymentKey()
                        UserDefaultHelper.deletePaymentEnv()
                        
                        AlertView.show(message: msg, preferredStyle: .alert, buttons: ["ok".localized()]) { (button) in
                            if button == "ok".localized() {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.afterLogout()
                            }
                        }
                    }
                    
                } failure: {error in
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
}
