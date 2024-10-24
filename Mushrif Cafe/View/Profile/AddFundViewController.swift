//
//  AddFundViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import IQKeyboardManagerSwift
import PassKit

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
    
    private var payment : PKPaymentRequest = PKPaymentRequest()
    
    var delegate: AddMoneyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 215
        txtAmt.becomeFirstResponder()
        txtAmt.delegate = self
        
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa, .quicPay]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            payment.merchantIdentifier = "merchant.com.mushifa.cafe"
            payment.supportedCountries = ["IN", "KW"]
            payment.merchantCapabilities = .capability3DS
            payment.countryCode = "KW"
            payment.currencyCode = "KWD"
            payment.supportedNetworks = paymentNetworks
        } else {
            AlertView.show(message: "Unable to make Apple Pay transaction.", preferredStyle: .alert, buttons: ["ok".localized()]) { (button) in
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
    
    @IBAction func appleAction(_ sender: Any) {
        
        if txtAmt.text!.isEmpty {
            self.showBanner(message: "amount_error".localized(), status: .error)
        } else {
            
            payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "Add to Wallet", amount: NSDecimalNumber(string: txtAmt.text!))]
                        
            let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
            if controller != nil {
                controller!.delegate = self
                self.present(controller!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func knetAction(_ sender: Any) {
        
        if txtAmt.text!.isEmpty {
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
        
        if textField.text?.count == 0 && string == "0" {
            return false
        }
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

extension AddFundViewController : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
