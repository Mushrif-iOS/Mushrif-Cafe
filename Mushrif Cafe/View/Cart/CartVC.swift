//
//  CartVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit
import ProgressHUD

class CartVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text =  "cart".localized()
        }
    }
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var takewayLabel: UILabel! {
        didSet {
            takewayLabel.font = UIFont.poppinsRegularFontWith(size: 14)
            takewayLabel.text =  "want_takeaway".localized()
        }
    }
    
    @IBOutlet weak var placeOrderButton: UIButton! {
        didSet {
            placeOrderButton.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            placeOrderButton.setTitle("\("place_order".localized())", for: .normal)
        }
    }
    
    @IBOutlet weak var inactiveTableView: UITableView!
    @IBOutlet weak var inActiveTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topGap: NSLayoutConstraint!
    @IBOutlet weak var gapBetweenTbl: NSLayoutConstraint!
    
    @IBOutlet weak var activeTableView: UITableView!
    @IBOutlet weak var activeTblHeight: NSLayoutConstraint!
    
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
            discountLabel.text = "-9.000 KWD"
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
    
    var cartData: CartResponse?
    var cartArray : [CartItem] = [CartItem]()
    var activeCartArray : [CartItem] = [CartItem]()
    var inActiveCartArray : [CartItem] = [CartItem]()
    
    var successOrderDetails: SuccessOrderResponse?
    
    var totalCost: String = ""
    var orderType: String = "dinein"
        
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
        orderType = checkBoxBtn.isSelected == true ? "takeaway" : "dinein"
        print(orderType)
        
//        if checkBoxBtn.isSelected == true {
//            self.changePaymentOptionBtn.isUserInteractionEnabled = false
//        } else {
//            self.changePaymentOptionBtn.isUserInteractionEnabled = true
//        }
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
        self.inActiveCartArray.removeAll()
        self.activeCartArray.removeAll()
        self.cartArray.removeAll()
        
        let aParams = ["locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
        print(aParams)
        
        APIManager.shared.postCall(APPURL.get_cart, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]
            self.cartData = CartResponse(fromJson: dataDict)
            
            let activeCartItemDict = responseJSON["response"]["active_items"].arrayValue
            for obj in activeCartItemDict {
                //self.activeCartArray.append(CartItem(fromJson: obj))
                self.cartArray.append(CartItem(fromJson: obj))
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
            
            self.amtLabel.text = "\(data?.subTotal != "" ? "\(data?.subTotal ?? "") KWD" : "")"
            self.totalLabel.text = "\(data?.subTotal != "" ? "\(data?.subTotal ?? "") KWD" : "")"
            self.totalCost = "\(data?.subTotal != "" ? data?.subTotal ?? "" : "")"

//            UserDefaultHelper.totalItems! = data?.items ?? 0
            UserDefaultHelper.totalPrice! = Double("\(data?.subTotal != "" ? data?.subTotal ?? "" : "")") ?? 0.0
            
            if self.inActiveCartArray.count > 0 {
                self.inactiveTableView.isHidden = false
                self.topGap.constant = 20
                self.inactiveTableView.reloadData()
            } else {
                self.inactiveTableView.isHidden = true
                self.inActiveTblHeight.constant = 0
                //self.inactiveTableView.reloadData()
            }
            if self.cartArray.count > 0 {
                UserDefaultHelper.totalItems! = self.cartArray.count
                self.placeOrderButton.isUserInteractionEnabled = true
                self.activeTableView.isHidden = false
                self.activeTableView.reloadData()
            } else {
                self.placeOrderButton.isUserInteractionEnabled = false
                self.placeOrderButton.alpha = 0.5
                self.activeTableView.isHidden = true
                self.activeTblHeight.constant = 0
                //self.inactiveTableView.reloadData()
            }
        }
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
//        if self.cartArray.count == 0 {
//            self.showBanner(message: "no_cart_item".localized(), status: .failed)
//        } else
        if UserDefaultHelper.totalPrice ?? 0.0 <= 0.0 {
            self.showBanner(message: "no_cost_product".localized(), status: .failed)
        } else {
            
            let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": "open", "order_type": self.orderType]
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
            let doubleValue = Double(dict.unitPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KWD"//"\(doubleValue) KD"
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
        } else {
            cell.isCart = "Y"
            cell.didRemoveBlock = {
                self.cartArray.removeAll()
                self.getCartItem()
            }
            
            cell.didChangePriceBlock = {
                DispatchQueue.main.async {
                    let doubleValue = Double(UserDefaultHelper.totalPrice ?? 0.0)
                    self.amtLabel.text =  "\(doubleValue.rounded(toPlaces: 2)) KWD"
                    self.totalLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                }
            }
            
            let dict = self.cartArray[indexPath.row]
            cell.nameLabel.text = dict.product.name
            cell.itemId = "\(dict.id)"
            let doubleValue = Double(dict.unitPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.toRoundedString(toPlaces: 2)) KWD"//"\(doubleValue) KD"
            
            let addedTitles = dict.ingredientsList?.map { group in
                return group.isAdded == 1 ? "\("add".localized()) \(group.title)" : "\("remove".localized()) \(group.title)"
            }.joined(separator: "\n")
            cell.descLabel.text = addedTitles
            cell.instructionLabel.text = "\n\(dict.instruction)"
            cell.qty.text = "\(dict.quantity)"
            cell.qtyValue = dict.quantity
            
            let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
            cell.otherPriceLabel.text = "\(prc.toRoundedString(toPlaces: 2)) KWD"
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
        
        if dict.productType == 5 {
            let editVC = SpecialProductVC.instantiate()
            editVC.cartDetails = dict
            editVC.title = "Edit"
            self.navigationController?.pushViewController(editVC, animated: true)
        } else {
            let editVC = EditCartVC.instantiate()
            editVC.cartDetails = dict
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
}
