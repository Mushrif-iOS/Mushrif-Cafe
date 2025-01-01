//
//  CartVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit

class CartVC: UIViewController, Instantiatable, AddMoneyDelegate, PayNowDelegate {
    
    static var storyboard: AppStoryboard = .cart
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text =  "cart".localized()
        }
    }
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var walletLabel: UILabel! {
        didSet {
            walletLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            walletLabel.text =  "wallet".localized()
        }
    }
    
    @IBOutlet weak var walletBalanceLabel: UILabel! {
        didSet {
            walletBalanceLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var addFundBtn: UIButton! {
        didSet {
            addFundBtn.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            addFundBtn.setAttributedTitle(NSAttributedString(string: "add_fund".localized(), attributes:
                                                                [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        }
    }
    
    @IBOutlet weak var payWithLabel: UILabel! {
        didSet {
            payWithLabel.font = UIFont.poppinsBoldFontWith(size: 16)
            payWithLabel.text =  "pay_with".localized()
        }
    }
    
    @IBOutlet weak var paymentIconBtn: UIButton!
    @IBOutlet weak var paymentLabel: UILabel! {
        didSet {
            paymentLabel.font = UIFont.poppinsLightFontWith(size: 14)
            paymentLabel.text =  "Apple Pay"
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var placeOrderLabel: UILabel! {
        didSet {
            placeOrderLabel.font = UIFont.poppinsMediumFontWith(size: 18)
            placeOrderLabel.text =  "place_order".localized()
        }
    }
    
    @IBOutlet weak var inactiveTableView: UITableView!
    @IBOutlet weak var inActiveTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topGap: NSLayoutConstraint!
    @IBOutlet weak var gapBetweenTbl: NSLayoutConstraint!
    
    @IBOutlet weak var activeTableView: UITableView!
    @IBOutlet weak var activeTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var couponTitle: UILabel! {
        didSet {
            couponTitle.font = UIFont.poppinsMediumFontWith(size: 18)
            couponTitle.text =  "coupons".localized()
        }
    }
    
    @IBOutlet weak var couponText: UITextField! {
        didSet {
            couponText.font = UIFont.poppinsMediumFontWith(size: 16)
            couponText.placeholder = "enter_coupon".localized()
        }
    }
    
    @IBOutlet weak var applyBtn: UIButton! {
        didSet {
            applyBtn.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            applyBtn.setTitle("apply".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bookedTitle: UILabel! {
        didSet {
            bookedTitle.font = UIFont.poppinsMediumFontWith(size: 18)
            bookedTitle.text =  "book_for".localized()
        }
    }
    
    @IBOutlet weak var tableLabel: UILabel! {
        didSet {
            tableLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            tableLabel.text = ""
        }
    }
    
    @IBOutlet weak var selectBtn: UIButton! {
        didSet {
            selectBtn.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            selectBtn.setTitle("select".localized(), for: .normal)
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
    
    @IBOutlet var discountTitle: UILabel! {
        didSet {
            discountTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            discountTitle.text = "discount_apl".localized()
        }
    }
    @IBOutlet var discountLabel: UILabel! {
        didSet {
            discountLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            discountLabel.textColor = UIColor.red
            discountLabel.text = "-9.000 KD"
        }
    }
    
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
    
    @IBOutlet var orderIdTitle: UILabel! {
        didSet {
            orderIdTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            orderIdTitle.text = "order_id".localized()
        }
    }
    @IBOutlet var orderIdLabel: UILabel! {
        didSet {
            orderIdLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    
    @IBOutlet var paidByTitle: UILabel! {
        didSet {
            paidByTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            paidByTitle.text = "paid_by".localized()
        }
    }
    @IBOutlet var paidByLabel: UILabel! {
        didSet {
            paidByLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            paidByLabel.text = "-"
        }
    }
    
    @IBOutlet var dateTimeTitle: UILabel! {
        didSet {
            dateTimeTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            dateTimeTitle.text = "order_on".localized()
        }
    }
    @IBOutlet var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            dateTimeLabel.numberOfLines = 0
        }
    }
    
    var cartData: CartResponse?
    var cartArray : [CartItem] = [CartItem]()
    var activeCartArray : [CartItem] = [CartItem]()
    var inActiveCartArray : [CartItem] = [CartItem]()
    
    var successOrderDetails: SuccessOrderResponse?
    
    var paymentType: String = "open"
    var paymentId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        inactiveTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        activeTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            self.inactiveTableView.sectionHeaderTopPadding = 0
            self.activeTableView.sectionHeaderTopPadding = 0
        }
        self.inactiveTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
        self.activeTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
        
        self.paymentLabel.text =  "Open Order"
        self.paymentIconBtn.setImage(UIImage(named: "plate-utensils_black"), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.inactiveTableView.isHidden = true
        self.activeTableView.isHidden = true
        self.inActiveTblHeight.constant = 0
        self.activeTblHeight.constant = 0
        
        self.inActiveCartArray.removeAll()
        self.activeCartArray.removeAll()
        self.cartArray.removeAll()
        
        self.getCartItem()
    }
    
    // Clean up observer
    deinit {
        self.inactiveTableView.removeObserver(self, forKeyPath: "contentSize")
        self.activeTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        checkBoxBtn.isSelected = !checkBoxBtn.isSelected
        paymentType = checkBoxBtn.isSelected == true ? "wallet" : "open"
        print(paymentType)
    }
    
    @IBAction func addFundAction(_ sender: Any) {
        
        let addVC = AddFundViewController.instantiate()
        
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
    
    func completed() {
        print("Wallet Amount")
        let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
        self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 2)) KD"
    }
    
    @IBAction func changePaymentAction(_ sender: Any) {
        
        let addVC = PaymentMethodVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.delegate = self
        addVC.totalCost = "\(self.cartData?.subTotal != "" ? self.cartData?.subTotal ?? "" : "")"
        self.present(addVC, animated: true, completion: nil)
    }
    
    func onSelect(type: String, paymentId: String) {
        self.paymentType = type
        self.paymentId = paymentId
        if type == "apple_pay" {
            self.paymentLabel.text =  "Apple Pay"
            self.paymentIconBtn.setImage(UIImage(named: "cc-apple-pay"), for: .normal)
        } else if type == "knet" {
            self.paymentLabel.text =  "Online KNET"
            self.paymentIconBtn.setImage(UIImage(named: "kNet"), for: .normal)
        } else if type == "knet_swipe" {
            self.paymentLabel.text =  "KNET - Swipe Machine"
            self.paymentIconBtn.setImage(UIImage(named: "knet_swipe"), for: .normal)
        } else if type == "open" {
            self.paymentLabel.text =  "Open Order"
            self.paymentIconBtn.setImage(UIImage(named: "plate-utensils_black"), for: .normal)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object as? UITableView == self.inactiveTableView {
                let contentHeight = self.inactiveTableView.contentSize.height
                self.inActiveTblHeight?.constant = contentHeight
            } else if object as? UITableView == self.activeTableView {
                let contentHeight = self.activeTableView.contentSize.height
                self.activeTblHeight?.constant = contentHeight
            }
        }
    }
    
    private func getCartItem() {
        
        let aParams = ["locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
        
        print(aParams)
        
        APIManager.shared.postCall(APPURL.get_cart, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]
            self.cartData = CartResponse(fromJson: dataDict)
            
            let cartItemDict = responseJSON["response"]["cart_items"].arrayValue
            for obj in cartItemDict {
                self.cartArray.append(CartItem(fromJson: obj))
            }
            
            let activeCartItemDict = responseJSON["response"]["active_items"].arrayValue
            for obj in activeCartItemDict {
                self.activeCartArray.append(CartItem(fromJson: obj))
            }
            
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
        
        let data = self.cartData
        
        DispatchQueue.main.async {
            
            self.amtLabel.text = "\(data?.subTotal != "" ? data?.subTotal ?? "" : "") KD"
            self.totalLabel.text = "\(data?.subTotal != "" ? data?.subTotal ?? "" : "") KD"
            
            self.orderIdLabel.text = "\(data?.orderNo ?? "")" != "" ? "#\(data?.orderNo ?? "")" : "-"

            self.dateTimeLabel.text = "\(data?.orderDate ?? "")" != "" ? "\(data?.orderDate ?? "")" : "-"
            
            UserDefaultHelper.totalItems! = self.cartArray.count
            UserDefaultHelper.totalPrice! = Double("\(data?.subTotal != "" ? data?.subTotal ?? "" : "")") ?? 0.0
            self.setPriceAttritubte(price: UserDefaultHelper.totalPrice ?? 0.0)
            
            if self.cartData?.orderType == "takeaway" {
                self.tableLabel.text =  ""
            } else {
                self.tableLabel.text =  UserDefaultHelper.tableName
            }
            
            let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
            self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 2)) KD"
            
            if self.inActiveCartArray.count > 0 {
                self.inactiveTableView.isHidden = false
                self.topGap.constant = 20
                self.inactiveTableView.reloadData()
            } else {
                self.inactiveTableView.isHidden = true
                self.inActiveTblHeight.constant = 0
                self.inactiveTableView.reloadData()
            }
            if self.activeCartArray.count > 0 {
                self.activeTableView.isHidden = false
                self.activeTableView.reloadData()
            } else {
                self.activeTableView.isHidden = true
                self.activeTblHeight.constant = 0
                self.inactiveTableView.reloadData()
            }
        }
    }
    
    private func setPriceAttritubte(price: Double) {
        
        let attrString = NSMutableAttributedString(string: "\(price.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 18)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 13)]))
        self.priceLabel.attributedText = attrString
    }
    
    @IBAction func selectTableAction(_ sender: Any) {
        let scanVC = ScanTableVC.instantiate()
        self.navigationController?.push(viewController: scanVC)
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
        if self.cartArray.count == 0 {
            self.showBanner(message: "no_product".localized(), status: .warning)
        } else {
            
            let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": self.paymentType, "payment_id": self.paymentId]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.place_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                self.successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
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

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.inactiveTableView {
            return self.inActiveCartArray.count
        } else {
            return self.cartArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        
        if tableView == self.inactiveTableView {
            
            let dict = self.inActiveCartArray[indexPath.row]
            cell.nameLabel.text = dict.product.name
            cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.itemId = "\(dict.id)"
//            if dict.product.specialPrice != "" {
//                let doubleValue = Double(dict.product.specialPrice) ?? 0.0
//                cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
//            } else {
//                let doubleValue = Double(dict.product.price) ?? 0.0
//                cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
//            }
            let doubleValue = Double(dict.unitPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
            cell.priceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            
            cell.descLabel.text = dict.instruction
            cell.descLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.qty.text = "\(dict.quantity)"
            cell.qty.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.qtyValue = dict.quantity
            
            let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
            cell.otherPriceLabel.text = "\(prc.toRoundedString(toPlaces: 2)) KD"
            cell.otherPriceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.itemValue = "\(dict.unitPrice)"
            cell.contentView.isUserInteractionEnabled = false
            cell.minusButton.isUserInteractionEnabled = false
            cell.plusButton.isUserInteractionEnabled = false
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
        } else {
            cell.isCart = "Y"
            cell.didRemoveBlock = {
                self.cartArray.removeAll()
                self.getCartItem()
            }
            
            cell.didChangePriceBlock = {
                DispatchQueue.main.async {
                    self.setPriceAttritubte(price: UserDefaultHelper.totalPrice ?? 0.0)
                    let doubleValue = Double(UserDefaultHelper.totalPrice ?? 0.0)
                    self.amtLabel.text =  "\(doubleValue.rounded(toPlaces: 2)) KD"
                    self.totalLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                }
            }
            
            let dict = self.cartArray[indexPath.row]
            cell.nameLabel.text = dict.product.name
            cell.itemId = "\(dict.id)"
//            if dict.product.specialPrice != "" {
//                let doubleValue = Double(dict.product.specialPrice) ?? 0.0
//                cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
//            } else {
//                let doubleValue = Double(dict.product.price) ?? 0.0
//                cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
//            }
            let doubleValue = Double(dict.unitPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KD"//"\(doubleValue) KD"
            
            cell.descLabel.text = dict.instruction
            cell.qty.text = "\(dict.quantity)"
            cell.qtyValue = dict.quantity
            
            let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
            cell.otherPriceLabel.text = "\(prc.toRoundedString(toPlaces: 2)) KD"
            cell.itemValue = "\(dict.unitPrice)"
            
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editAction(sender: )), for: .touchUpInside)
            
            cell.backView.layer.masksToBounds = true
            DispatchQueue.main.async {
                if self.cartArray.count == 1 {
                    cell.backView.roundCorners(corners: .allCorners, radius: 18)
                } else {
                    if indexPath.row == 0 {
                        cell.backView.layer.cornerRadius = 18
                        cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    } else if indexPath.row == self.cartArray.count - 1 {
                        cell.backView.layer.cornerRadius = 18
                        cell.backView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    } else {
                        cell.backView.roundCorners(corners: .allCorners, radius: 0)
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func editAction(sender: UIButton) {
        
        let dict = self.cartArray[sender.tag]
        
        let editVC = EditCartVC.instantiate()
        editVC.cartDetails = dict
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
