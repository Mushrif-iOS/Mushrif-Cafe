//
//  AddFundViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import IQKeyboardManagerSwift
//import ProgressHUD

class AddFundViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    @IBOutlet weak var txtAmt: UITextField! {
        didSet {
            txtAmt.font = UIFont.poppinsMediumFontWith(size: 16)
            txtAmt.tintColor = UIColor.primaryBrown
            txtAmt.placeholder = "enter_amt".localized()
        }
    }
    
    @IBOutlet weak var appleLabel: UILabel! {
        didSet {
            appleLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            appleLabel.text = "Apple Pay"
            appleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var knetLabel: UILabel! {
        didSet {
            knetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            knetLabel.text = "KNET"
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var delegate: AddMoneyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 215
        txtAmt.becomeFirstResponder()
        txtAmt.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
    
    @IBAction func appleAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func knetAction(_ sender: Any) {
        
        if txtAmt.text!.isEmpty {
//            ProgressHUD.fontBannerTitle = UIFont.poppinsMediumFontWith(size: 18)
//            ProgressHUD.fontBannerMessage = UIFont.poppinsLightFontWith(size: 14)
//            ProgressHUD.colorBanner = UIColor.red
//            ProgressHUD.banner("error".localized(), "amount_error".localized())
            self.showBanner(message: "amount_error".localized(), status: .error)
        } else {
            
            let aParams: [String: Any] = ["amount": "\(self.txtAmt.text!)"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.add_money, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let msg = responseJSON["message"].stringValue
                print(msg)

                self.showBanner(message: msg, status: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.delegate?.completed()
                    self.dismiss(animated: true)
                }
                
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension AddFundViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.) 244878
        if textField.text?.count == 0 && string == "0" {
            return false
        }
        //Have a decimal keypad. Which means user will be able to enter Double values. (Needless to say "." will be limited one)
        if (textField.text?.contains("."))! && string == "." {
            return false
        }
        
        if textField.text?.count == 0 && string == "." {
            return false
        }
        
        let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
        let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
        if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
            return false
        }
        return true
    }
}
