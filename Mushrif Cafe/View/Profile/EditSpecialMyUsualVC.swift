//
//  EditSpecialMyUsualVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 03/04/25.
//

import UIKit
import ProgressHUD

class EditSpecialMyUsualVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet var mealImg: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 22)
        }
    }
    
    @IBOutlet var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    
    @IBOutlet var txtViewHeight: NSLayoutConstraint!
    
    @IBOutlet var typeOfMealTop: NSLayoutConstraint!
    @IBOutlet var typeOfMealView: UIView!
    @IBOutlet var typeOfMealSeperatorHeight: NSLayoutConstraint!
    @IBOutlet var typeOfMealLabel: UILabel! {
        didSet {
            typeOfMealLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet var requiredLabel: UILabel! {
        didSet {
            requiredLabel.font = UIFont.poppinsMediumFontWith(size: 13)
        }
    }
    
    @IBOutlet var maximumLabel: UILabel! {
        didSet {
            maximumLabel.font = UIFont.poppinsSemiBoldFontWith(size: 80)
        }
    }
    
    @IBOutlet weak var stepperView: UIView!
    
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 30)
            qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    @IBOutlet weak var mealTypeTblView: UITableView!
    @IBOutlet var mealTypeTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addButton: UIButton!
    
    var basePrice: Double = Double()
    var originalBasePrice: Double = Double()
    
    var itemPrice: Double = Double()
    var qtyChangeValue: Double = Double()
    
    var qtyValue: Int = 1
    
    let userLanguage = UserDefaultHelper.language
    
    var itemId: String = ""
    
    var choiceArr : [ChoiceGroup] = [ChoiceGroup]()
            
    var usualCartDetails : UsualDetailsItem?
    
    var specialMaxTotal = Int()
    var totalQuantity = 0 {
        didSet {
            maximumLabel.text = "\(totalQuantity)"
        }
    }
    var specialQuantities: [Int] = []
    var selectedSpecialItems: [Int: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealTypeTblView.register(SpecialMealTVC.nib(), forCellReuseIdentifier: SpecialMealTVC.identifier)
        
        if #available(iOS 15.0, *) {
            mealTypeTblView.sectionHeaderTopPadding = 0
        }
        
        self.mealTypeTblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
                
        DispatchQueue.main.async {
            self.editSetupUI()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustTextViewHeight()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.mealTypeTblHeight.constant = newsize.height
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if qtyValue > 1 {
            qtyValue -= 1
            
            self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        }
        qty.text = userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        self.setPriceAttritubte()
    }
    
    @IBAction func plusAction(_ sender: Any) {
        if qtyValue < 200 {
            qtyValue += 1
            
            self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        }
        qty.text = userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        self.setPriceAttritubte()
    }
    
    @IBAction func nextAscreenAction(_ sender: Any) {
        self.addToCartApi()
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = descLabel.frame.size.width
        let newSize = descLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtViewHeight.constant = newSize.height
    }
    
    private func editSetupUI() {
        
        let data = self.usualCartDetails
        
        DispatchQueue.main.async {
            
            self.mealImg.loadURL(urlString: data?.product?.image, placeholderImage: UIImage(named: "appLogo"))
            self.nameLabel.text = data?.product?.name
            self.descLabel.text = data?.product?.productDesc
            
            self.qtyValue = data?.quantity ?? 1
            self.qty.text = "\(self.qtyValue)"
            
            self.choiceArr = data?.product.choiceGroups ?? []
            if self.choiceArr.count > 0 {
                self.typeOfMealLabel.text = UserDefaultHelper.language == "ar" ? self.choiceArr.first?.titleAr : self.choiceArr.first?.title
                self.requiredLabel.text = "\("required".localized()): \("selectAny".localized()) \(self.choiceArr.first?.minSelection ?? 0) \("option".localized())"
                self.specialMaxTotal = self.choiceArr.first?.maxSelection ?? 0
                
                self.specialQuantities = self.choiceArr.first?.choices.map { $0.quantity } ?? []
                self.totalQuantity = self.specialQuantities.reduce(0, +)
                
                for choice in self.choiceArr.first?.choices ?? [] {
                    if choice.selectionStatus == 1 {
                        self.selectedSpecialItems[choice.id] = choice.quantity
                    }
                }
                
                self.mealTypeTblView.reloadData()
                self.updateSelectedItemsString()
            }
            
            if data?.product.specialPrice != "" {
                self.itemPrice = Double(data?.product.specialPrice ?? "") ?? 0.0
                self.basePrice = self.itemPrice
                self.originalBasePrice = Double(data?.product.specialPrice ?? "") ?? 0.0
            } else {
                self.itemPrice = Double(data?.product.price ?? "") ?? 0.0
                self.basePrice = self.itemPrice
                self.originalBasePrice = Double(data?.product.price ?? "") ?? 0.0
            }
            self.qtyChangeValue = (self.itemPrice*Double(self.qtyValue))
            self.setPriceAttritubte()
        }
    }
}

extension EditSpecialMyUsualVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choiceArr.first?.choices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SpecialMealTVC.identifier) as! SpecialMealTVC
        
        let dict = self.choiceArr.first?.choices[indexPath.row]
        cell.nameLabel.text = UserDefaultHelper.language == "ar" ? "\(dict?.choiceAr ?? "")" : "\(dict?.choice ?? "")"
        
        cell.qty.text = "\(self.specialQuantities[indexPath.row])"
        
        cell.quantity = self.specialQuantities[indexPath.row]
        cell.onQuantityChanged = { [weak self] change in
            guard let self = self else { return }
            let newTotal = self.totalQuantity + change
            let newQuantity = self.specialQuantities[indexPath.row] + change
            if (change > 0 && newTotal <= self.specialMaxTotal) || (change < 0 && newQuantity >= 0) {
                self.totalQuantity = newTotal
                self.specialQuantities[indexPath.row] = newQuantity
                self.updateSelectedItemsString()
                self.mealTypeTblView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        return cell
    }
    
    func updateSelectedItemsString() {
        selectedSpecialItems.removeAll() // Clear previous selections
        
        for (index, quantity) in self.specialQuantities.enumerated() {
            if quantity > 0 {
                if let choiceId = self.choiceArr.first?.choices[index].id {
                    selectedSpecialItems[choiceId] = quantity
                }
            }
        }
                
        let selectedIDsString = selectedSpecialItems.keys.map { String($0) }.joined(separator: ",")
        let selectedQuantitiesString = selectedSpecialItems.values.map { String($0) }.joined(separator: ",")
        
        print("Selected IDs: \(selectedIDsString)")
        print("Selected Quantities: \(selectedQuantitiesString)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setPriceAttritubte() {
        if self.qtyChangeValue > 0 {
            self.basePrice = self.qtyChangeValue
        } else {
            self.basePrice = self.itemPrice
        }
        if UserDefaultHelper.language == "en" {
            let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(self.basePrice.toRoundedString(toPlaces: 2)) \("kwd".localized())", attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
//            attrString.append(NSMutableAttributedString(string: " \("kwd".localized())",
//                                                        attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
            self.addButton.setAttributedTitle(attrString, for: .normal)
        } else {
            let attrString = NSMutableAttributedString(string: "\("add".localized()) - \("kwd".localized()) \(self.basePrice.toRoundedString(toPlaces: 2))", attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
            self.addButton.setAttributedTitle(attrString, for: .normal)
        }
    }
    
    func addToCartApi() {
        
        let orderType = UserDefaultHelper.orderType ?? ""
        let hallId = UserDefaultHelper.hallId ?? ""
        let tableId = UserDefaultHelper.tableId ?? ""
        let groupId = UserDefaultHelper.groupId ?? ""
        
        let selectedIDsString = selectedSpecialItems.keys.map { String($0) }.joined(separator: ",")
        let selectedQuantitiesString = selectedSpecialItems.values.map { String($0) }.joined(separator: ",")
        
        if Int(self.maximumLabel.text!) ?? 0 >= self.choiceArr.first?.minSelection ?? 0 {
            
            if tableId != "" {
                
                let aParams = ["hall_id": hallId,
                               "table_id": tableId,
                               "group_id": groupId,
                               "order_type": orderType,
                               "item_id": "\(self.usualCartDetails?.id ?? 0)",
                               "quantity": "\(self.qtyValue)",
                               "is_customized": "Y",
                               "is_plain": "N",
                               "ingredients_id": "",
                               "combo_product_id": "",
                               "choice_group_id": "\(selectedIDsString)",
                               "choice_group_quantity": "\(selectedQuantitiesString)",
                               "combo_id": "",
                               "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
                
                print(aParams)
                
                APIManager.shared.postCall(APPURL.my_usuals_edit, params: aParams, withHeader: true) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    
                    let dataDict = responseJSON["response"]["data"].arrayValue
                    print(dataDict)
                    let msg = responseJSON["message"].stringValue
                    print(msg)
                    DispatchQueue.main.async {
                        self.showBanner(message: msg, status: .success)
                        self.navigationController?.popViewController(animated: true)
                    }
                } failure: { error in
                    print("Error \(error.localizedDescription)")
                }
                
            } else {
                self.showBanner(message: "please_scan".localized(), status: .warning)
                let scanVC = ScanTableVC.instantiate()
                scanVC.title = "Details"
                scanVC.modalPresentationStyle = .formSheet
                self.present(scanVC, animated: true)
            }
        } else {
            self.showBanner(message: "\("selectAny".localized()) \(self.choiceArr.first?.minSelection ?? 0) \("option".localized())", status: .failed)
        }
    }
}
