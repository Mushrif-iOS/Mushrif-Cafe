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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.inactiveTableView.isHidden = true
        self.inActiveTblHeight.constant = 0
        
        self.inActiveCartArray.removeAll()
        self.cartArray.removeAll()
        
        self.getCartItem()
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
        if walletCheckBoxBtn.isSelected {
            appleCheckBoxBtn.isSelected = false
            knetCheckBoxBtn.isSelected = false
            self.walletDiscountStack.isHidden = false
            self.walletTotalStack.isHidden = false
            
            if (Double(UserDefaultHelper.walletBalance ?? "0") ?? 0) > (Double(self.totalCost) ?? 0) {
                self.discountLabel.text = "-\(self.totalCost) KWD"
                self.totalLabel.text = "0.0 KWD"
                //self.totalCost = "0.0"
                print(self.totalCost)
            } else {
                let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
                self.discountLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                
                let totalValue = abs((Double(self.totalCost) ?? 0) - (Double(UserDefaultHelper.walletBalance ?? "0") ?? 0))
                self.totalLabel.text = "\(totalValue.rounded(toPlaces: 2)) KWD"
                //self.totalCost = "\(totalValue)"
                print(self.totalCost)
            }
        } else {
            self.walletDiscountStack.isHidden = true
            self.walletTotalStack.isHidden = true
            self.setupUI()
        }
        
        paymentType = "wallet"
        print(paymentType)
    }
    @IBAction func appleCheckBoxAction(_ sender: Any) {
        appleCheckBoxBtn.isSelected = !appleCheckBoxBtn.isSelected
        if appleCheckBoxBtn.isSelected {
            walletCheckBoxBtn.isSelected = false
            knetCheckBoxBtn.isSelected = false
            self.walletDiscountStack.isHidden = true
            self.walletTotalStack.isHidden = true
        }
        self.paymentType = "apple_pay"
        print(paymentType)
        self.setupUI()
    }
    @IBAction func knetCheckBoxAction(_ sender: Any) {
        knetCheckBoxBtn.isSelected = !knetCheckBoxBtn.isSelected
        if knetCheckBoxBtn.isSelected {
            walletCheckBoxBtn.isSelected = false
            appleCheckBoxBtn.isSelected = false
            self.walletDiscountStack.isHidden = true
            self.walletTotalStack.isHidden = true
        }
        self.paymentType = "knet"
        print(paymentType)
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
            self.setupUI()
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
                
        DispatchQueue.main.async {
            
            //self.totalLabel.text = "\(data?.subTotal != "" ? data?.subTotal ?? "" : "") KWD"
            
            let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
            self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 2)) KWD"
            
            if self.inActiveCartArray.count > 0 {
                
                let totalPrice = self.inActiveCartArray.compactMap { item in
                    let unitPrice = Double(item.unitPrice) ?? 0.0
                    let quantity = item.quantity
                    return (unitPrice) * Double(quantity)
                }.reduce(0.0, +)
                
                print("Total Price: \(totalPrice)")
                self.amtLabel.text = "\(totalPrice) KWD"
                self.totalCost = "\(totalPrice)"
                print(self.totalCost)
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
            
            /*let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": "apple_pay", "order_type": UserDefaultHelper.tableName == "" ? "takeaway" : "dinein"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.place_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                self.orderID = "\(self.successOrderDetails?.id ?? 0)"
                
                self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "pay_now".localized(), amount: NSDecimalNumber(string: self.totalCost))]
                
                let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
                if controller != nil {
                    controller!.delegate = self
                    self.present(controller!, animated: true, completion: nil)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }*/
            self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "pay_now".localized(), amount: NSDecimalNumber(string: self.totalCost))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
            if controller != nil {
                controller!.delegate = self
                self.present(controller!, animated: true, completion: nil)
            }
        } else if self.paymentType == "knet" {
            
            /*let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": "knet", "order_type": UserDefaultHelper.tableName == "" ? "takeaway" : "dinein"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.place_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                //self.orderID = "\(self.successOrderDetails?.id ?? 0)"
                self.executePayment(paymentMethodId: 1)
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }*/
            self.executePayment(paymentMethodId: 1)
        } else if self.paymentType == "wallet" {
            if (Double(UserDefaultHelper.walletBalance ?? "0") ?? 0) < (Double(self.totalCost) ?? 0) {
                self.showBanner(message: "insf_waller_amt".localized(), status: .failed)
            } else {
                let aParams = ["order_id": "\(self.cartData?.orderId ?? 0)", "payment_type": "wallet", "payment_id": "", "payment_status": "Paid", "amount": self.totalCost]
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
                        //self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 2)) KWD"
                    }
                    
                    UserDefaultHelper.tableName = ""
                    
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
        } else {
            self.showBanner(message: "checkout_no_method".localized(), status: .failed)
        }
    }
    
    private func paymentOrder(orderId: String, type: String, payId: String, paymentStatus: String) {
        
        if type == "apple_pay" && payId != "" {
            let aParams = ["order_id": orderId, "payment_type": type, "payment_id": payId, "payment_status": paymentStatus, "amount": self.totalCost]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                UserDefaultHelper.tableName = ""
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
            let aParams = ["order_id": orderId, "payment_type": type, "payment_id": payId, "payment_status": paymentStatus, "amount": self.totalCost]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                UserDefaultHelper.tableName = ""
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
//        else {
//            DispatchQueue.main.async {
//                let orderVC = OrderSuccessVC.instantiate()
//                orderVC.successOrderDetails = self.successOrderDetails
//                self.navigationController?.pushViewController(orderVC, animated: true)
//            }
//        }
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
        cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KWD"//"\(doubleValue) KD"
        cell.priceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        
        let addedTitles = dict.ingredientsList?.map { group in
            return group.isAdded == 1 ? "\("add".localized()) \(group.title)" : "\("remove".localized()) \(group.title)"
        }.joined(separator: "\n")
        cell.descLabel.text = addedTitles
        cell.descLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.qty.text = "\(dict.quantity)"
        cell.qty.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.qtyValue = dict.quantity
        
        let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
        cell.otherPriceLabel.text = "\(prc.toRoundedString(toPlaces: 2)) KWD"
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
            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "\(transactionID)", paymentStatus: "Paid")
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
            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "", paymentStatus: "")
        }
    }
    
    func paymentAuthorizationViewControllerDidCancel(_ controller: PKPaymentAuthorizationViewController) {
        // Handle the event when the user cancels the payment
        print("User canceled the payment.")
        controller.dismiss(animated: true) {
            self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "apple_pay", payId: "", paymentStatus: "")
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
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: invoiceStatus)
                        self.dismiss(animated: true)
                    }
                } else {
                    if let invoiceId = invoiceId {
                        self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: "")
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let failError):
                ProgressHUD.error(failError)
                if let invoiceId = invoiceId {
                    self.paymentOrder(orderId: "\(self.cartData?.orderId ?? 0)", type: "knet", payId: "\(invoiceId)", paymentStatus: "")
                    self.dismiss(animated: true)
                }
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
