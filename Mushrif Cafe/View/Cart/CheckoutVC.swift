//
//  CheckoutVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 25/03/25.
//

import UIKit
import MFSDK
import ProgressHUD
import PassKit

class CheckoutVC: UIViewController, Instantiatable {
    
    static var storyboard: AppStoryboard = .cart
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text =  "checkout".localized()
        }
    }
    
    @IBOutlet weak var inactiveTableView: UITableView!
    @IBOutlet weak var inActiveTblHeight: NSLayoutConstraint!
    
    @IBOutlet var paymentOption: UILabel! {
        didSet {
            paymentOption.font = UIFont.poppinsMediumFontWith(size: 18)
            paymentOption.text = "paymentOption".localized()
        }
    }
    @IBOutlet weak var walletCheckBoxBtn: UIButton!
    
    @IBOutlet weak var walletLabel: UILabel! {
        didSet {
            walletLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            walletLabel.text =  "wallet".localized()
            walletLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var walletBalanceLabel: UILabel! {
        didSet {
            walletBalanceLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            walletBalanceLabel.text = ""
            walletBalanceLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var appleCheckBoxBtn: UIButton!
    @IBOutlet weak var applePaymentLabel: UILabel! {
        didSet {
            applePaymentLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            applePaymentLabel.text = "apple_pay".localized()
        }
    }
    @IBOutlet weak var knetCheckBoxBtn: UIButton!
    @IBOutlet weak var onlineKnetLabel: UILabel! {
        didSet {
            onlineKnetLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            onlineKnetLabel.text = "online_knet".localized()
        }
    }

    @IBOutlet var summaryTitle: UILabel! {
        didSet {
            summaryTitle.font = UIFont.poppinsMediumFontWith(size: 18)
            summaryTitle.text = "summary".localized()
        }
    }
    @IBOutlet var amtTitle: UILabel! {
        didSet {
            amtTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            amtTitle.text = "amount".localized()
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var walletDiscountStack: UIStackView!
    @IBOutlet var discountTitle: UILabel! {
        didSet {
            discountTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            discountTitle.text = "wallet_amt".localized()
        }
    }
    @IBOutlet var discountLabel: UILabel! {
        didSet {
            discountLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            discountLabel.textColor = UIColor.red
        }
    }
    @IBOutlet weak var walletTotalStack: UIStackView!
    @IBOutlet var totalTitle: UILabel! {
        didSet {
            totalTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            totalTitle.text = "total".localized()
        }
    }
    @IBOutlet var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var placeOrderButton: UIButton! {
        didSet {
            placeOrderButton.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 18)
            placeOrderButton.setTitle("\("pay_now".localized())", for: .normal)
        }
    }
    
    var cartData: CartResponse?
    var cartArray : [CartItem] = [CartItem]()
    var inActiveCartArray : [CartItem] = [CartItem]()
    
    var successOrderDetails: SuccessOrderResponse?
    
    var paymentType: String = ""
    
    private var payment : PKPaymentRequest = PKPaymentRequest()
    var totalCost: String = ""
    var remainingAmountAfterWallet: String = ""
    
    var paymentDetail: TransactionMethod?
    
    //var orderID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        inactiveTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            self.inactiveTableView.sectionHeaderTopPadding = 0
        }
        self.inactiveTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
                
        MFSettings.shared.delegate = self
        
//        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa, .quicPay]
//        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
//            payment.merchantIdentifier = "merchant.com.mushifa.cafe"
//            payment.supportedCountries = ["IN", "KW"]
//            payment.merchantCapabilities = .capability3DS
//            payment.countryCode = "KW"
//            payment.currencyCode = "KWD"
//            payment.supportedNetworks = paymentNetworks
//        } else {
//            AlertView.show(message: "Unable to make Apple Pay transaction.", preferredStyle: .alert, buttons: ["ok".localized()]) { (button) in
//                
//            }
//        }
        
        self.initiatePayment()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.inactiveTableView.isHidden = true
        self.inActiveTblHeight.constant = 0
        
        self.inActiveCartArray.removeAll()
        self.cartArray.removeAll()
        
        self.getCartItem()
        
        let walletBalance = Double(UserDefaultHelper.walletBalance ?? "0") ?? 0
        
        if walletBalance <= 0.0 {
            walletCheckBoxBtn.isUserInteractionEnabled = false
        } else {
            walletCheckBoxBtn.isUserInteractionEnabled = true
        }
        
        let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
        self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): \(doubleValue.rounded(toPlaces: 3))"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object as? UITableView == self.inactiveTableView {
                let contentHeight = self.inactiveTableView.contentSize.height
                self.inActiveTblHeight?.constant = contentHeight
            }
        }
    }
    
    deinit {
        self.inactiveTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.pop()
    }
    
    @IBAction func walletCheckBoxAction(_ sender: Any) {
        walletCheckBoxBtn.isSelected = !walletCheckBoxBtn.isSelected
        let walletBalance = Double(UserDefaultHelper.walletBalance ?? "0") ?? 0
        let totalCostValue = Double(self.totalCost) ?? 0
        
        if walletCheckBoxBtn.isSelected {
            if walletBalance >= totalCostValue {
                // Wallet amount is sufficient, ONLY allow Wallet selection
                appleCheckBoxBtn.isSelected = false
                knetCheckBoxBtn.isSelected = false
                self.walletDiscountStack.isHidden = false
                self.walletTotalStack.isHidden = false
                
                self.discountLabel.text = UserDefaultHelper.language == "en" ? "-\(self.totalCost) \("kwd".localized())" : "\("kwd".localized()) \(self.totalCost)-"
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "0.0 \("kwd".localized())" : "\("kwd".localized()) 0.0"
                print("Remaining amount: 0.0 \("kwd".localized())")
                self.remainingAmountAfterWallet = ""
                paymentType = "wallet"
                
                let doubleValue = Double((Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0) - totalCostValue)
                self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): \(doubleValue.rounded(toPlaces: 3))"
                
            } else {
                // Wallet amount is insufficient, allow partial payment with either Apple Pay or Knet
                self.walletDiscountStack.isHidden = false
                self.walletTotalStack.isHidden = false
                
                let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
                self.discountLabel.text = UserDefaultHelper.language == "en" ? "-\(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 3))-"
                
                let remainingAmount = abs(totalCostValue - walletBalance)
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(remainingAmount.rounded(toPlaces: 3))"
                print("Remaining amount: \(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())")
                self.remainingAmountAfterWallet = "\(remainingAmount.rounded(toPlaces: 3))"
                
                // Dynamically set paymentType based on other selections
                if appleCheckBoxBtn.isSelected {
                    paymentType = "wallet_and_apple_pay"
                } else if knetCheckBoxBtn.isSelected {
                    paymentType = "wallet_and_knet"
                } else {
                    paymentType = "wallet"
                }
                
                self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): 0.0 \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): 0.0"
            }
        } else {
            // Wallet deselected
            self.walletDiscountStack.isHidden = true
            self.walletTotalStack.isHidden = true
            self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(totalCostValue) \("kwd".localized())" : "\("kwd".localized()) \(totalCostValue)"
            paymentType = appleCheckBoxBtn.isSelected ? "apple_pay" : knetCheckBoxBtn.isSelected ? "knet" : ""
            
            let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
            self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): \(doubleValue.rounded(toPlaces: 3))"
        }
        
        print("Selected paymentType: \(paymentType)")
        self.setupUI()
    }
    @IBAction func appleCheckBoxAction(_ sender: Any) {
        appleCheckBoxBtn.isSelected = !appleCheckBoxBtn.isSelected
        let walletBalance = Double(UserDefaultHelper.walletBalance ?? "0") ?? 0
        let totalCostValue = Double(self.totalCost) ?? 0
        
        if appleCheckBoxBtn.isSelected {
            if walletBalance >= totalCostValue {
                // Wallet balance is sufficient, ONLY allow one method selection
                walletCheckBoxBtn.isSelected = false
                knetCheckBoxBtn.isSelected = false
                self.walletDiscountStack.isHidden = true
                self.walletTotalStack.isHidden = true
                paymentType = "apple_pay"
                
                let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
                self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): \(doubleValue.rounded(toPlaces: 3))"
            } else {
                // Allow partial payment with Wallet if Wallet is insufficient
                knetCheckBoxBtn.isSelected = false  // Ensure Knet is deselected
                
                if walletCheckBoxBtn.isSelected {
                    let remainingAmount = abs(totalCostValue - walletBalance)
                    self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(remainingAmount.rounded(toPlaces: 3))"
                    paymentType = "wallet_and_apple_pay"
                    print("Remaining amount: \(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())")
                    self.remainingAmountAfterWallet = "\(remainingAmount.rounded(toPlaces: 3))"
                } else {
                    self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(totalCostValue) \("kwd".localized())" : "\("kwd".localized()) \(totalCostValue)"
                    paymentType = "apple_pay"
                }
            }
        } else {
            // Apple Pay deselected
            if walletCheckBoxBtn.isSelected && walletBalance < totalCostValue {
                let remainingAmount = abs(totalCostValue - walletBalance)
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(remainingAmount.rounded(toPlaces: 3))"
                paymentType = "wallet"
            } else {
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(totalCostValue) \("kwd".localized())" : "\("kwd".localized()) \(totalCostValue)"
                
                paymentType = knetCheckBoxBtn.isSelected ? "knet" : ""
            }
        }
        
        print("Selected paymentType: \(paymentType)")
        self.setupUI()
    }
    @IBAction func knetCheckBoxAction(_ sender: Any) {
        knetCheckBoxBtn.isSelected = !knetCheckBoxBtn.isSelected
        let walletBalance = Double(UserDefaultHelper.walletBalance ?? "0") ?? 0
        let totalCostValue = Double(self.totalCost) ?? 0
        
        if knetCheckBoxBtn.isSelected {
            if walletBalance >= totalCostValue {
                // Wallet balance is sufficient, ONLY allow one method selection
                walletCheckBoxBtn.isSelected = false
                appleCheckBoxBtn.isSelected = false
                self.walletDiscountStack.isHidden = true
                self.walletTotalStack.isHidden = true
                paymentType = "knet"
                
                let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
                self.walletBalanceLabel.text = UserDefaultHelper.language == "en" ? "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \("balance".localized()): \(doubleValue.rounded(toPlaces: 3))"
            } else {
                // Allow partial payment with Wallet if Wallet is insufficient
                appleCheckBoxBtn.isSelected = false  // Ensure Apple Pay is deselected
                
                if walletCheckBoxBtn.isSelected {
                    let remainingAmount = abs(totalCostValue - walletBalance)
                    self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(remainingAmount.rounded(toPlaces: 3))"
                    paymentType = "wallet_and_knet"
                    print("Remaining amount: \(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())")
                    self.remainingAmountAfterWallet = "\(remainingAmount.rounded(toPlaces: 3))"
                } else {
                    self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(totalCostValue) \("kwd".localized())" : "\("kwd".localized()) \(totalCostValue)"
                    paymentType = "knet"
                }
            }
        } else {
            // Knet deselected
            if walletCheckBoxBtn.isSelected && walletBalance < totalCostValue {
                let remainingAmount = abs(totalCostValue - walletBalance)
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(remainingAmount.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(remainingAmount.rounded(toPlaces: 3))"
                paymentType = "wallet"
            } else {
                self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(totalCostValue) \("kwd".localized())" : "\("kwd".localized()) \(totalCostValue)"
                paymentType = appleCheckBoxBtn.isSelected ? "apple_pay" : ""
            }
        }
        
        print("Selected paymentType: \(paymentType)")
        self.setupUI()
    }
    
    private func getCartItem() {
        
        let aParams = ["locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
        print(aParams)
        
        APIManager.shared.postCall(APPURL.get_cart, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]
            self.cartData = CartResponse(fromJson: dataDict)
            let inActiveCartItemDict = responseJSON["response"]["inactive_items"].arrayValue
            for obj in inActiveCartItemDict {
                self.inActiveCartArray.append(CartItem(fromJson: obj))
            }
            let paymentDetailData = responseJSON["response"]["transactionMethod"]
            self.paymentDetail = TransactionMethod(fromJson: paymentDetailData)
            
            UserDefaultHelper.minimumWalletAmt = "\(self.paymentDetail?.walletRecharge ?? "")"
            UserDefaultHelper.minimumAppleAmt = "\(self.paymentDetail?.applePay ?? "")"
            UserDefaultHelper.minimumKNETAmt = "\(self.paymentDetail?.knet ?? "")"
            self.setupUI()
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
                
        DispatchQueue.main.async {
                        
            if self.inActiveCartArray.count > 0 {
                
                let totalPrice = self.inActiveCartArray.compactMap { item in
                    let unitPrice = Double(item.unitPrice) ?? 0.0
                    let quantity = item.quantity
                    return (unitPrice) * Double(quantity)
                }.reduce(0.0, +)
                
                print("Total Price: \(totalPrice.rounded(toPlaces: 3))")
                
                self.amtLabel.text = UserDefaultHelper.language == "en" ? "\(totalPrice.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(totalPrice.rounded(toPlaces: 3))"
                self.totalCost = "\(totalPrice.rounded(toPlaces: 3))"
                print("Total Cost: \(self.totalCost)")
                self.inactiveTableView.isHidden = false
                self.inactiveTableView.reloadData()
            } else {
                self.inactiveTableView.isHidden = true
                self.inActiveTblHeight.constant = 0
                self.inactiveTableView.reloadData()
            }
        }
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
        if self.paymentType == "apple_pay" {
            if let enteredAmount = Double(self.totalCost),
               let minAmount = Double(UserDefaultHelper.minimumAppleAmt ?? ""),
                      enteredAmount < minAmount {
                let msg = UserDefaultHelper.language == "en" ? "The minimum order amount for online payment is \(minAmount.rounded(toPlaces: 3)) \("kwd".localized()). You may also call a waiter to settle the payment directly." :
                "الحد الأدنى للدفع الإلكتروني هو \("kwd".localized()) \(minAmount.rounded(toPlaces: 3)) دينار كويتي. يمكنك أيضًا طلب النادل لتسديد الدفعة مباشرة."
                
                self.showBanner(message: msg, status: .failed)
                return
            }
//            self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "pay_now".localized(), amount: NSDecimalNumber(string: self.totalCost))]
//            
//            let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
//            if controller != nil {
//                controller!.delegate = self
//                self.present(controller!, animated: true, completion: nil)
//            }
            self.executeApplePayment(paymentMethodId: 11)
        } else if self.paymentType == "knet" {
            if let enteredAmount = Double(self.totalCost),
               let minAmount = Double(UserDefaultHelper.minimumKNETAmt ?? ""),
                      enteredAmount < minAmount {
                let msg = UserDefaultHelper.language == "en" ? "The minimum order amount for online payment is \(minAmount.rounded(toPlaces: 3)) \("kwd".localized()). You may also call a waiter to settle the payment directly." :
                "الحد الأدنى للدفع الإلكتروني هو \("kwd".localized()) \(minAmount.rounded(toPlaces: 3)) دينار كويتي. يمكنك أيضًا طلب النادل لتسديد الدفعة مباشرة."
                
                self.showBanner(message: msg, status: .failed)
                return
            }
            self.executePayment(paymentMethodId: 1)
        } else if self.paymentType == "wallet" {
            if (Double(UserDefaultHelper.walletBalance ?? "0") ?? 0) < (Double(self.totalCost) ?? 0) {
                self.showBanner(message: "insf_waller_amt".localized(), status: .failed)
            } else {
                let aParams: [String : Any] = ["order_id": "\(self.cartData?.orderId ?? 0)", "payment_type": "wallet", "payment_id": "", "payment_status": "Paid", "amount": self.totalCost, "with_wallet": 0, "wallet_amount": "0", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
                print(aParams)
                
                APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    let dataDict = responseJSON["response"]
                    self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                    
                    let msg = responseJSON["message"].stringValue
                    print(msg)
                    let bal = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
                    if bal > 0 {
                        let doubleValue = (Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0) - (Double(self.totalCost) ?? 0.0)
                        UserDefaultHelper.walletBalance = "\(doubleValue)"
                        //self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 3)) KWD"
                    }
                    
                    //UserDefaultHelper.tableName = ""
                    UserDefaultHelper.deleteTableId()
                    UserDefaultHelper.deleteTableName()
                    
                    DispatchQueue.main.async {
                        self.showBanner(message: msg, status: .success)
                        let orderVC = OrderSuccessVC.instantiate()
                        orderVC.successOrderDetails = self.successOrderDetails
                        orderVC.successMsg = msg
                        self.navigationController?.pushViewController(orderVC, animated: true)
                    }
                } failure: { error in
                    print("Error \(error.localizedDescription)")
                }
            }
        } else if self.paymentType == "wallet_and_apple_pay" {
            if let enteredAmount = Double(self.totalCost),
               let minAmount = Double(UserDefaultHelper.minimumAppleAmt ?? ""),
                      enteredAmount < minAmount {
                let msg = UserDefaultHelper.language == "en" ? "The minimum order amount for online payment is \(minAmount.rounded(toPlaces: 3)) \("kwd".localized()). You may also call a waiter to settle the payment directly." :
                "الحد الأدنى للدفع الإلكتروني هو \("kwd".localized()) \(minAmount.rounded(toPlaces: 3)) دينار كويتي. يمكنك أيضًا طلب النادل لتسديد الدفعة مباشرة."
                
                self.showBanner(message: msg, status: .failed)
                return
            }
            self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "pay_now".localized(), amount: NSDecimalNumber(string: self.remainingAmountAfterWallet))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
            if controller != nil {
                controller!.delegate = self
                self.present(controller!, animated: true, completion: nil)
            }
        } else if self.paymentType == "wallet_and_knet" {
            if let enteredAmount = Double(self.totalCost),
               let minAmount = Double(UserDefaultHelper.minimumKNETAmt ?? ""),
                      enteredAmount < minAmount {
                let msg = UserDefaultHelper.language == "en" ? "The minimum order amount for online payment is \(minAmount.rounded(toPlaces: 3)) \("kwd".localized()). You may also call a waiter to settle the payment directly." :
                "الحد الأدنى للدفع الإلكتروني هو \("kwd".localized()) \(minAmount.rounded(toPlaces: 3)) دينار كويتي. يمكنك أيضًا طلب النادل لتسديد الدفعة مباشرة."
                
                self.showBanner(message: msg, status: .failed)
                return
            }
            self.executePayment(paymentMethodId: 1)
        } else {
            self.showBanner(message: "checkout_no_method".localized(), status: .failed)
        }
    }
    
    private func paymentOrder(orderId: String, type: String, payId: String, paymentStatus: String) {
        
        if type == "apple_pay" && payId != "" {
            let aParams: [String : Any] = ["order_id": orderId, "payment_type": type, "payment_id": payId, "payment_status": paymentStatus, "amount": self.totalCost, "with_wallet": 0, "wallet_amount": "0", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                UserDefaultHelper.deleteTableId()
                UserDefaultHelper.deleteTableName()
                DispatchQueue.main.async {
                    self.showBanner(message: msg, status: .success)
                    let orderVC = OrderSuccessVC.instantiate()
                    orderVC.successOrderDetails = self.successOrderDetails
                    orderVC.successMsg = msg
                    self.navigationController?.pushViewController(orderVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        } else if type == "knet" && paymentStatus != "" {
            let aParams: [String : Any] = ["order_id": orderId, "payment_type": type, "payment_id": payId, "payment_status": paymentStatus, "amount": self.totalCost, "with_wallet": 0, "wallet_amount": "0", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                UserDefaultHelper.deleteTableId()
                UserDefaultHelper.deleteTableName()
                DispatchQueue.main.async {
                    self.showBanner(message: msg, status: .success)
                    let orderVC = OrderSuccessVC.instantiate()
                    orderVC.successOrderDetails = self.successOrderDetails
                    orderVC.successMsg = msg
                    self.navigationController?.pushViewController(orderVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        } else if type == "wallet_and_apple_pay" && payId != "" {
            let aParams: [String : Any] = ["order_id": orderId, "payment_type": "apple_pay", "payment_id": payId, "payment_status": paymentStatus, "amount": self.remainingAmountAfterWallet, "with_wallet": 1, "wallet_amount": "\(Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0)", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                
                UserDefaultHelper.walletBalance = ""
                
                UserDefaultHelper.deleteTableId()
                UserDefaultHelper.deleteTableName()
                DispatchQueue.main.async {
                    self.showBanner(message: msg, status: .success)
                    let orderVC = OrderSuccessVC.instantiate()
                    orderVC.successOrderDetails = self.successOrderDetails
                    orderVC.successMsg = msg
                    self.navigationController?.pushViewController(orderVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        } else if type == "wallet_and_knet" && paymentStatus != "" {
            let aParams: [String : Any] = ["order_id": orderId, "payment_type": "knet", "payment_id": payId, "payment_status": paymentStatus, "amount": self.remainingAmountAfterWallet, "with_wallet": 1, "wallet_amount": "\(Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0)", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                
                UserDefaultHelper.walletBalance = ""
                
                UserDefaultHelper.deleteTableId()
                UserDefaultHelper.deleteTableName()
                DispatchQueue.main.async {
                    self.showBanner(message: msg, status: .success)
                    let orderVC = OrderSuccessVC.instantiate()
                    orderVC.successOrderDetails = self.successOrderDetails
                    orderVC.successMsg = msg
                    self.navigationController?.pushViewController(orderVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inActiveCartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        
        let dict = self.inActiveCartArray[indexPath.row]
        cell.nameLabel.text = dict.product.name
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.itemId = "\(dict.id)"
        let doubleValue = Double(dict.unitPrice) ?? 0.0
        cell.priceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 3))"
        cell.priceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        
        let addedTitles = dict.ingredientsList?.map { group in
            return group.isAdded == 1 ? "\("add".localized()) \(group.title)" : "\("remove".localized()) \(group.title)"
        }.joined(separator: "\n")
        cell.descLabel.text = addedTitles
        cell.descLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.instructionLabel.text = "\n\(dict.instruction)"
        cell.instructionLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.qty.text = "\(dict.quantity)"
        cell.qty.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.qtyValue = dict.quantity
        
        let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
        cell.otherPriceLabel.text = UserDefaultHelper.language == "en" ? "\(prc.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(prc.rounded(toPlaces: 3))"
        cell.otherPriceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.itemValue = "\(dict.unitPrice)"
        cell.contentView.isUserInteractionEnabled = false
        cell.minusButton.isUserInteractionEnabled = false
        cell.plusButton.isUserInteractionEnabled = false
        cell.editButton.isUserInteractionEnabled = false
        cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        
        cell.backView.layer.masksToBounds = true
        DispatchQueue.main.async {
            if self.inActiveCartArray.count == 1 {
                cell.backView.roundCorners(corners: .allCorners, radius: 18)
            } else {
                if indexPath.row == 0 {
                    cell.backView.layer.cornerRadius = 18
                    cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } else if indexPath.row == self.inActiveCartArray.count - 1 {
                    cell.backView.layer.cornerRadius = 18
                    cell.backView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                } else {
                    cell.backView.roundCorners(corners: .allCorners, radius: 0)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CheckoutVC : PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let transactionID = payment.token.transactionIdentifier
        print("Transaction ID: \(transactionID)")
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
        controller.dismiss(animated: true) {
            if self.paymentType == "wallet_and_apple_pay" {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "\(transactionID)", paymentStatus: "Paid")
            } else {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "\(transactionID)", paymentStatus: "Paid")
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didFailWithError error: Error) {
        // Handle payment failure
        print("Payment failed with error: \(error.localizedDescription)")
        controller.dismiss(animated: true) {
            if self.paymentType == "wallet_and_apple_pay" {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "", paymentStatus: "")
            } else {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "", paymentStatus: "")
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidCancel(_ controller: PKPaymentAuthorizationViewController) {
        // Handle the event when the user cancels the payment
        print("User canceled the payment.")
        controller.dismiss(animated: true) {
            if self.paymentType == "wallet_and_apple_pay" {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "", paymentStatus: "")
            } else {
                self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "", paymentStatus: "")
            }
        }
    }
}

extension CheckoutVC: MFPaymentDelegate {
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
                    
                    if let invoiceId = invoiceId {
                        print("Success with invoiceId \(invoiceId)")
                        if self.paymentType == "wallet_and_knet" {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_knet", payId: "\(invoiceId)", paymentStatus: invoiceStatus)
                        } else {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: invoiceStatus)
                        }
                        self.dismiss(animated: true)
                    }
                } else {
                    if let invoiceId = invoiceId {
                        if self.paymentType == "wallet_and_knet" {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_knet", payId: "\(invoiceId)", paymentStatus: "")
                        } else {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: "")
                        }
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
                if let invoiceId = invoiceId {
                    if self.paymentType == "wallet_and_knet" {
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_knet", payId: "\(invoiceId)", paymentStatus: "")
                    } else {
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: "")
                    }
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func executeApplePayment(paymentMethodId: Int) {
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
                    
                    if let invoiceId = invoiceId {
                        print("Success with invoiceId \(invoiceId)")
                        if self.paymentType == "wallet_and_apple_pay" {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "\(invoiceId)", paymentStatus: "Paid")
                        } else {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "\(invoiceId)", paymentStatus: "Paid")
                        }
                        self.dismiss(animated: true)
                    }
                } else {
                    if let invoiceId = invoiceId {
                        if self.paymentType == "wallet_and_apple_pay" {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "\(invoiceId)", paymentStatus: "")
                        } else {
                            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "\(invoiceId)", paymentStatus: "")
                        }
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
                if let invoiceId = invoiceId {
                    if self.paymentType == "wallet_and_apple_pay" {
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "wallet_and_apple_pay", payId: "\(invoiceId)", paymentStatus: "")
                    } else {
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "\(invoiceId)", paymentStatus: "")
                    }
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.primaryBrown, navigationTitle: "payment".localized(), cancelButtonTitle: "cancel".localized())
        MFSettings.shared.setTheme(theme: them)
        let invoiceValue = self.paymentType == "wallet_and_knet" ? Decimal(string: self.remainingAmountAfterWallet) ?? 0 : Decimal(string: self.totalCost) ?? 0
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
