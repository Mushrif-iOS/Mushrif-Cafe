//
//  CartVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit

class CartVC: UIViewController, Instantiatable, AddMoneyDelegate, InputBoxDelegate {
    static var storyboard: AppStoryboard = .cart
    
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
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
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
            orderIdLabel.text = "233332"
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
            paidByLabel.text = "Bhushan"
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
            dateTimeLabel.text = "2/2/22 - 23:13"
        }
    }
    
    var cartData: CartResponse?
    var cartArray : [CartItem] = [CartItem]()
    
    var paymentType: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        self.mainTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.getCartItem()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxAction(_ sender: Any) {
        checkBoxBtn.isSelected = !checkBoxBtn.isSelected
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
        self.present(addVC, animated: true, completion: nil)
    }
    
    func onInput(text: String) {
        self.paymentType = text
        
        if text == "apple_pay" {
            self.paymentLabel.text =  "Apple Pay"
            self.paymentIconBtn.setImage(UIImage(named: "cc-apple-pay"), for: .normal)
        } else if text == "knet" {
            self.paymentLabel.text =  "Online KNET"
            self.paymentIconBtn.setImage(UIImage(named: "kNet"), for: .normal)
        } else if text == "knet_swipe" {
            self.paymentLabel.text =  "KNET - Swipe Machine"
            self.paymentIconBtn.setImage(UIImage(named: "knet_swipe"), for: .normal)
        } else if text == "open" {
            self.paymentLabel.text =  "Open Order"
            self.paymentIconBtn.setImage(UIImage(named: "plate-utensils_black"), for: .normal)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.tblHeight.constant = newsize.height
                }
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
            
            DispatchQueue.main.async {
                self.setupUI()
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        
        let data = self.cartData
        
        self.amtLabel.text = "\(data?.subTotal ?? "") KD"
        self.totalLabel.text = "\(data?.subTotal ?? "") KD"
        self.setPriceAttritubte(price: Double(data?.subTotal ?? "") ?? 0.0, label: self.priceLabel)
        
        UserDefaultHelper.totalItems! = self.cartArray.count
        UserDefaultHelper.totalPrice! = Double("\(data?.subTotal ?? "")") ?? 0.0
        
        if self.cartArray.count > 0 {
            self.mainTableView.reloadData()
        }
        
        if self.cartData?.orderType == "takeaway" {
            self.tableLabel.text =  ""
        } else {
            self.tableLabel.text =  UserDefaultHelper.tableName
        }
        
        let doubleValue = Double(UserDefaultHelper.walletBalance ?? "") ?? 0.0
        self.walletBalanceLabel.text =  "\("balance".localized()): \(doubleValue.rounded(toPlaces: 2)) KWD"
    }
    
    private func setPriceAttritubte(price: Double, label: UILabel) {
        
        let attrString = NSMutableAttributedString(string: "\(price.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 18)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 13)]))
        label.attributedText =  attrString
    }
    
    @IBAction func selectTableAction(_ sender: Any) {
        let scanVC = ScanTableVC.instantiate()
        self.navigationController?.push(viewController: scanVC)
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
        let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": self.paymentType, "payment_id": ""]
        
        print(aParams)
        
        APIManager.shared.postCall(APPURL.place_order, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let msg = responseJSON["message"].stringValue
            print(msg)
            DispatchQueue.main.async {
                self.showBanner(message: msg, status: .success)
                let orderVC = OrderSuccessVC.instantiate()
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        cell.isCart = "Y"
        cell.didRemoveBlock = {
            self.cartArray.removeAll()
            self.getCartItem()
        }
        if indexPath.row == 0 {
            cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
        } else if indexPath.row == self.cartArray.count - 1 {
            cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
        } else {
            cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
        }
        
        let dict = self.cartArray[indexPath.row]
        cell.nameLabel.text = dict.product.name
        cell.itemId = "\(dict.id)"
        if dict.product.specialPrice != "" {
            let doubleValue = Double(dict.product.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue) KD"
        } else {
            let doubleValue = Double(dict.product.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue) KD"
        }
        
        cell.descLabel.text = dict.instruction
        cell.qty.text = "\(dict.quantity)"
        cell.otherPriceLabel.text = "\(dict.unitPrice) KD"
        cell.itemValue = "\(dict.unitPrice)"
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 15))
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    @objc func editAction(sender: UIButton) {
        
        let dict = self.cartArray[sender.tag]
        
        let editVC = EditCartVC.instantiate()
        editVC.cartDetails = dict
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
