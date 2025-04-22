//
//  AddFundViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import IQKeyboardManagerSwift
import PassKit
import MFSDK
import ProgressHUD

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
            txtAmt.setPlaceholderColor(UIColor.black.withAlphaComponent(0.6))
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
    
    var paymentID: String = ""
    
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
        
        MFSettings.shared.delegate = self
        self.initiatePayment()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
    
    @IBAction func appleAction(_ sender: Any) {
        
        if txtAmt.text!.isEmpty {
            self.showBanner(message: "amount_error".localized(), status: .failed)
        } else {
            
            self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "add_to_wallet".localized(), amount: NSDecimalNumber(string: self.txtAmt.text!))]
                        
            let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
            if controller != nil {
                controller!.delegate = self
                self.present(controller!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func knetAction(_ sender: Any) {

        if txtAmt.text!.isEmpty {
            self.showBanner(message: "amount_error".localized(), status: .failed)
        } else {
            self.executePayment(paymentMethodId: 1)
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
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let transactionID = payment.token.transactionIdentifier
        print("Transaction ID: \(transactionID)")
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
        controller.dismiss(animated: true) {
                        
            let aParams: [String: Any] = ["amount": "\(self.txtAmt.text!)", "payment_type": "apple_pay", "payment_id": "\(transactionID)", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.add_money, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let msg = responseJSON["message"].stringValue
                print(msg)

                self.showBanner(message: msg, status: .success)
                
                UserDefaultHelper.walletBalance = responseJSON["response"]["balance"].stringValue
                DispatchQueue.main.async {
                    self.delegate?.completed()
                    self.dismiss(animated: true)
                    print("\(transactionID)")
                }
                
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
}

extension AddFundViewController: MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print("#\(invoiceId)")
    }
    
    func initiatePayment() {
        ProgressHUD.animate()
        ProgressHUD.colorAnimation = UIColor.primaryBrown
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(string: "\(self.txtAmt.text!)") ?? 0, currencyIso: .kuwait_KWD)
        MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: UserDefaultHelper.language == "ar" ? .arabic :  .english, completion: { (result) in
            ProgressHUD.dismiss()
            switch result {
            case .success(let initiatePaymentResponse):
                for obj in 0..<(initiatePaymentResponse.paymentMethods?.count ?? 0) {
                    print(initiatePaymentResponse.paymentMethods?[obj].paymentMethodEn ?? "")
                    print(initiatePaymentResponse.paymentMethods?[obj].paymentMethodId ?? "")
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
            }
        })
    }

    func executePayment(paymentMethodId: Int) {
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.primaryBrown, navigationTitle: "payment".localized(), cancelButtonTitle: "cancel".localized())
        MFSettings.shared.setTheme(theme: them)
        let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
        ProgressHUD.animate()
        ProgressHUD.colorAnimation = UIColor.primaryBrown
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .arabic) { response, invoiceId  in
            ProgressHUD.dismiss()
            switch response {
            case .success(let executePaymentResponse):
                if let invoiceStatus = executePaymentResponse.invoiceStatus {
                    ProgressHUD.success(invoiceStatus)
                }
                if let invoiceId = invoiceId {
                    print("Success with invoiceId \(invoiceId)")
                    
                    let aParams: [String: Any] = ["amount": "\(self.txtAmt.text!)", "payment_type": "knet", "payment_id": "\(invoiceId)", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
                    
                    print(aParams)
                    
                    APIManager.shared.postCall(APPURL.add_money, params: aParams, withHeader: true) { responseJSON in
                        print("Response JSON \(responseJSON)")
                        
                        let msg = responseJSON["message"].stringValue
                        print(msg)

                        self.showBanner(message: msg, status: .success)
                        
                        UserDefaultHelper.walletBalance = responseJSON["response"]["balance"].stringValue
                        DispatchQueue.main.async {
                            self.delegate?.completed()
                            self.dismiss(animated: true)
                        }
                        
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }

                    self.dismiss(animated: true)
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
            }
        }
    }
    
    private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
        let invoiceValue = Decimal(string: "\(self.txtAmt.text!)") ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue , paymentMethod: paymentMethodId)
        request.customerEmail = UserDefaultHelper.userEmail ?? ""
        request.customerMobile = UserDefaultHelper.mobile ?? ""
        request.customerCivilId = ""
        request.customerName = UserDefaultHelper.userName ?? ""
        request.customerReference = "\(Bundle.applicationName) Customer"
        request.language = UserDefaultHelper.language == "ar" ? .arabic :  .english
        request.mobileCountryCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.displayCurrencyIso = .kuwait_KWD
        let date = Date().addingTimeInterval(1000)
        request.expiryDate = date
        return request
    }
}
