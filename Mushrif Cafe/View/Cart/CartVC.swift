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
    
    @IBOutlet weak var viewDiscount: UIStackView!
    @IBOutlet weak var lblTbl: UILabel!
    @IBOutlet weak var btnPayNow: UIButton!{
        didSet {
            btnPayNow.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            btnPayNow.setTitle("\("pay_now".localized())", for: .normal)
        }
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var mainScrollView: UIScrollView!
    private let locationManager = LocationManager()
    private var isNearByCafe = true
    var profileData: Customer?

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
            discountLabel.text = ""
        }
    }
    
   
    
    var cartData: CartResponse?
    var cartArray : [CartItem] = [CartItem]()
    var activeCartArray : [CartItem] = [CartItem]()
    var inActiveCartArray : [CartItem] = [CartItem]()
    
    var successOrderDetails: SuccessOrderResponse?
    
    var orderType: String = "dinein"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.setArabic()
        lblTbl.font = UIFont.poppinsSemiBoldFontWith(size: 15)
        lblTbl.text = ""
        if (UserDefaultHelper.tableId ?? "").isBlank  == false {
            //self.selectTableLabel.text = UserDefaultHelper.tableName
            self.lblTbl.text = UserDefaultHelper.tableName
            self.lblTbl.textColor = .black
        }
        // Do any additional setup after loading the view.
        inactiveTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        activeTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        btnPayNow.isHidden = true
        if #available(iOS 15.0, *) {
            self.inactiveTableView.sectionHeaderTopPadding = 0
            self.activeTableView.sectionHeaderTopPadding = 0
        }
        self.inactiveTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
        self.activeTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .initial], context: nil)
       
    }
    private func getProfile() {
        let aParams: [String: Any] = [:]
        
        APIManager.shared.getCallWithParams(APPURL.getProfileDetails, params: aParams) { [self] responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"].dictionaryValue
            
            let customerData = dataDict["customer"]
            self.profileData = Customer(fromJson: customerData)

            if  self.profileData?.specialcustomer != 1 { ///  2 step we will check here custmer is special or if custmer is special then hallId tableId groupId was automatic assign
                setupLocation()
                placeOrderButton.isHidden = true
            }
            
            print("Customer Data", self.profileData!.phone)

        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
    func setupLocation()  { /// first  we will check location acces that user  is near by cafe or not
        // Set up closures
        locationManager.onLocationReceived = { [weak self] loc in
            if let location = loc {
                print("✅ One-time Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                   // Update UI here if needed
                self!.placeOrderButton.isHidden = false
                self!.isNearByCafe = Utility.isNearByCafe(userLocation: location)
                let title = self!.isNearByCafe ? "\("place_order".localized())" : "\("Next".localized())"
                self!.placeOrderButton.setTitle(title, for: .normal)
            }
         
        }

           locationManager.onLocationDenied = { [weak self] in
               self!.placeOrderButton.isHidden = false
           }

           locationManager.onError = { error in
               self.placeOrderButton.isHidden = false
           }

           locationManager.requestSingleLocation()
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
        getProfile()

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
                if self.inActiveCartArray.count == 0 {
                    self.inActiveTblHeight?.constant = 0
                }
            } else if object as? UITableView == self.activeTableView {
                let contentHeight = self.activeTableView.contentSize.height
                self.activeTblHeight?.constant = contentHeight
                if self.cartArray.count == 0 {
                    self.activeTblHeight?.constant = 0
                }
            }
        }
    }
    
    private func getCartItem(isFromNavigate: Bool = true) {
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
            if self.inActiveCartArray.count > 0 &&  self.cartArray.count <= 0 {
                self.btnPayNow.isHidden = false
                self.placeOrderButton.isHidden =  true
            } else {
                self.btnPayNow.isHidden = true
                self.placeOrderButton.isHidden =  false
            }
            
            if self.cartData?.table != nil {
                UserDefaultHelper.hallId = "\(self.cartData?.table.hallId ?? "")"
                UserDefaultHelper.tableId = "\(self.cartData?.table.tableId ?? "")"
                UserDefaultHelper.groupId = "\(self.cartData?.table.groupId ?? "")"
                UserDefaultHelper.tableName = "\(self.cartData?.table.tableName ?? "")"
                //UserDefaultHelper.tableNameFull = "\(self.cartData?.table.tableName ?? "")"
            }
            self.setupUI(isFromNavigate: isFromNavigate)
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    func setAmountAndDiscount(dicount: Double, special_sub_total: Double) {
        self.discountLabel.text = "\(dicount.rounded(toPlaces: 3)) \("kwd".localized())"
        self.amtLabel.text = "\(special_sub_total.rounded(toPlaces: 3)) \("kwd".localized())"

    }
    private func setupUI(isFromNavigate: Bool = true) {
        
        let data = self.cartData
        
        DispatchQueue.main.async { [self] in
           
            let discount = Double(data?.discount ?? 0)
            let special_sub_total = Double(data?.special_sub_total ?? 0)

            setAmountAndDiscount(dicount: discount, special_sub_total: special_sub_total)


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
            UserDefaultHelper.totalItems = self.cartArray.count
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if isFromNavigate {
                    self.scrollToLastRow()
                }
            }


        }
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        if isNearByCafe {

            if cartArray.contains(where: { $0.isCustomizePending == 1 }) {
                showBanner(message: "pending_custimization_addtoCart".localized(), status: .failed)
                return
            } else {
                
                let aParams = ["cart_id": "\(self.cartData?.id ?? 0)", "payment_type": "open", "order_type": self.orderType, "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
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
            
        } else {
            let checkoutVC = CheckoutVC.instantiate()
            checkoutVC.isFromDiretPayment = true
            checkoutVC.orderType =  orderType
            self.navigationController?.pushViewController(checkoutVC, animated: true)

        }
//        if self.cartArray.count == 0 {
//            self.showBanner(message: "no_cart_item".localized(), status: .failed)
//        } else self.cartArray
        

    }
    
    @IBAction func btnPayNowTapped(_ sender: Any) {
        let dashboardVC = CheckoutVC.instantiate()
        self.navigationController?.push(viewController: dashboardVC)

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
            let place = "place_on".localized()
            cell.lblDate.text = place + " \(dict.placed_on)"
            
            let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
            cell.otherPriceLabel.text = UserDefaultHelper.language == "en" ? "\(prc.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(prc.rounded(toPlaces: 3))"
            cell.otherPriceLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.itemValue = "\(dict.unitPrice)"
            cell.contentView.isUserInteractionEnabled = false
            cell.minusButton.isUserInteractionEnabled = false
            cell.plusButton.isUserInteractionEnabled = false
            cell.editButton.isUserInteractionEnabled = false
            cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
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
            
            cell.didChangePriceBlock = { sub_total, discount in
                DispatchQueue.main.async { [self] in
                    setAmountAndDiscount(dicount: Double(discount) ?? 0, special_sub_total: Double(sub_total) ?? 0)


                }
            }
            
            let dict = self.cartArray[indexPath.row]
            cell.nameLabel.text = dict.product.name
            cell.itemId = "\(dict.id)"
            let doubleValue = Double(dict.unitPrice) ?? 0.0
            cell.lblDate.text = ""
            
            cell.priceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 3))"
            
            let addedTitles = dict.ingredientsList?.map { group in
                return group.isAdded == 1 ? "\("add".localized()) \(group.title)" : "\("remove".localized()) \(group.title)"
            }.joined(separator: "\n")
            
            if dict.isCustomizePending == 1 {
                cell.descLabel.text = "pending_custimization".localized()
                cell.descLabel.textColor = UIColor.systemYellow
            } else {
                cell.descLabel.text = addedTitles
            }
            cell.instructionLabel.text = "\n\(dict.instruction)"
            cell.qty.text = "\(dict.quantity)"
            cell.qtyValue = dict.quantity
            cell.setImageInMinusButton()
            let prc = Double((Double(dict.unitPrice) ?? 0.0)*Double(dict.quantity))
            cell.otherPriceLabel.text = UserDefaultHelper.language == "en" ? "\(prc.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(prc.rounded(toPlaces: 3))"
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
    
    // MARK: - Swipe to Delete with Confirmation

      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          
          guard tableView == self.activeTableView else {
                return nil // No swipe actions for other table views
            }

          var obj : CartItem?
            obj = self.cartArray[indexPath.row]
          
          let deleteAction = UIContextualAction(style: .destructive, title: "delete".localized()) { [weak self] (_, _, completionHandler) in
              guard let self = self else { return }
              let message = "cart_item_deelete_message".localized()
              UIAlertController.showAlert(controller: self, title: "confirm_delete".localized(), message: "\(message) \"\(obj?.product.name ?? "")\"?", style: .alert, cancelButton: "cancel".localized(), distrutiveButton: "delete".localized(), otherButtons: nil) { (_, btnStr) in
                  if btnStr == "delete".localized() {
                      self.deleteCartItemAPI(cartID: obj?.id ?? 0)
                      completionHandler(true)
                  }
              }
          }

          return UISwipeActionsConfiguration(actions: [deleteAction])
      }
    func scrollToLastRow() {
        DispatchQueue.main.async {
                self.view.layoutIfNeeded()  // Force layout pass to update contentSize
                let bottomOffset = CGPoint(x: 0, y: self.mainScrollView.contentSize.height - self.mainScrollView.bounds.height + self.mainScrollView.contentInset.bottom)
                if bottomOffset.y > 0 {
                    self.mainScrollView.setContentOffset(bottomOffset, animated: true)
                }
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
    private func deleteCartItemAPI(cartID: Int) {
        var aParams: [String: Any] = [:]
        aParams["locale"]  = UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"
        aParams["cart_item_id"]  = cartID
        APIManager.shared.postCall(APPURL.remove_cart_item, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let msg = responseJSON["message"].stringValue
            self.showBanner(message: msg , status: .success)
            self.getCartItem(isFromNavigate: false)
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}
