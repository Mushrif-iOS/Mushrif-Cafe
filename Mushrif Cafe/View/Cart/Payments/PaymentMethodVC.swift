//
//  PaymentMethodVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit
import MFSDK
import ProgressHUD
import PassKit

class PaymentMethodVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    @IBOutlet weak var appleLabel: UILabel! {
        didSet {
            appleLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            appleLabel.text = "Apple Pay"
            appleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var onlineKnetLabel: UILabel! {
        didSet {
            onlineKnetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            onlineKnetLabel.text = "Online KNET"
        }
    }
    
    @IBOutlet weak var swipeKnetLabel: UILabel! {
        didSet {
            swipeKnetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            swipeKnetLabel.text = "KNET - Swipe Machine"
        }
    }
    
    @IBOutlet weak var keepLabel: UILabel! {
        didSet {
            keepLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            keepLabel.text = "keep_order_open".localized()
        }
    }
    
    var delegate: PayNowDelegate?
    
    var totalCost: String = ""
        
    private var payment : PKPaymentRequest = PKPaymentRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MFSettings.shared.delegate = self
        
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
        
        self.initiatePayment()
    }
    
    @IBAction func appleAction(_ sender: Any) {
        payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "pay_now".localized(), amount: NSDecimalNumber(string: self.totalCost))]
                    
        let controller = PKPaymentAuthorizationViewController(paymentRequest: payment)
        if controller != nil {
            controller!.delegate = self
            self.present(controller!, animated: true, completion: nil)
        }
    }
    
    @IBAction func onlineKnetAction(_ sender: Any) {
        //self.delegate?.onInput(text: "knet")
        
        self.executePayment(paymentMethodId: 1)
    }
    
    @IBAction func swipeKnetAction(_ sender: Any) {
        self.delegate?.onSelect(type: "knet_swipe", paymentId: "")
        
        self.dismiss(animated: true)
    }
    
    @IBAction func keepAction(_ sender: Any) {
        self.delegate?.onSelect(type: "open", paymentId: "")
        self.dismiss(animated: true)
    }
}

extension PaymentMethodVC : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let transactionID = payment.token.transactionIdentifier
        print("Transaction ID: \(transactionID)")
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
        controller.dismiss(animated: true) {
            self.delegate?.onSelect(type: "apple_pay", paymentId: "\(transactionID)")
            self.dismiss(animated: true)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
}

extension PaymentMethodVC: MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print("#\(invoiceId)")
    }
    
    func initiatePayment() {
        ProgressHUD.animate()
        ProgressHUD.colorAnimation = UIColor.primaryBrown
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(string: self.totalCost) ?? 0, currencyIso: .kuwait_KWD)
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
                    self.delegate?.onSelect(type: "knet", paymentId: "\(invoiceId)")
                    self.dismiss(animated: true)
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
            }
        }
    }
    
    private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
        let invoiceValue = Decimal(string: self.totalCost) ?? 0
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue , paymentMethod: paymentMethodId)
        request.customerEmail = UserDefaultHelper.userEmail ?? ""
        request.customerMobile = UserDefaultHelper.mobile ?? ""
        request.customerCivilId = ""
        request.customerName = UserDefaultHelper.userName ?? ""
//        let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
//        request.customerAddress = address
        request.customerReference = "\(Bundle.applicationName) Customer"
        request.language = UserDefaultHelper.language == "ar" ? .arabic :  .english
        request.mobileCountryCode = MFMobileCountryCodeISO.kuwait.rawValue
        request.displayCurrencyIso = .kuwait_KWD
        let date = Date().addingTimeInterval(1000)
        request.expiryDate = date
        
        // Uncomment this to add products for your invoice
        //         var productList = [MFProduct]()
        //        let product = MFProduct(name: "ABC", unitPrice: 1.887, quantity: 1)
        //         productList.append(product)
        //         request.invoiceItems = productList
        return request
    }
}
