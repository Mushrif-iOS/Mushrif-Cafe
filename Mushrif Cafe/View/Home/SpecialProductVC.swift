//
//  SpecialProductVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/03/25.
//

import UIKit
import ProgressHUD

class SpecialProductVC: UIViewController, Instantiatable {
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
    
    var detailsData: ItemDetailsResponse?
    var choiceArr : [ChoiceGroup] = [ChoiceGroup]()
        
    var delegate: ToastDelegate?
    
    var noteText: String = ""
    private var lastEnteredText: String = ""
    
    var cartDetails : CartItem?
    
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
        
        self.setupFloatingButton()
        
        if title == "Edit" {
            DispatchQueue.main.async {
                self.editSetupUI()
            }
        } else {
            self.getDetails()
        }
    }

    func setupFloatingButton() {
        let floatingButton = UIButton(type: .system)
        
        // Set button properties
        floatingButton.setImage(UIImage(systemName: "pencil.and.scribble")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .normal)
        floatingButton.backgroundColor = UIColor.primaryBrown
        floatingButton.layer.cornerRadius = 22
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOpacity = 0.3
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        floatingButton.layer.shadowRadius = 5
        
        // Set button size
        floatingButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        // Add target action
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        // Add to view and position it
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            floatingButton.widthAnchor.constraint(equalToConstant: 44),
            floatingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        floatingButton.addGestureRecognizer(panGesture)
    }
    
    @objc func floatingButtonTapped() {
        let instructionAlert = FoodInstructionAlertController()
        instructionAlert.modalPresentationStyle = .overFullScreen
        instructionAlert.instructionValue = title == "Edit" ? noteText : lastEnteredText
        
        if title == "Edit" {
            instructionAlert.title = "Edit"
        }
        
        instructionAlert.onSave = { [weak self] enteredText in
            guard let self = self else { return }
            let trimmedText = enteredText.trimmingCharacters(in: .whitespacesAndNewlines)
            print("User entered: \(trimmedText)")
            
            // Store in both places
            self.lastEnteredText = trimmedText
            self.noteText = trimmedText
            
            // Update UI or perform other actions as needed
        }
        present(instructionAlert, animated: true)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let floatingButton = gesture.view else { return }
        
        let translation = gesture.translation(in: self.view)
        
        // Update the button's position based on the drag
        var newCenter = CGPoint(x: floatingButton.center.x + translation.x, y: floatingButton.center.y + translation.y)
        
        // Check if the new position would push the button off the screen
        newCenter.x = max(min(newCenter.x, self.view.bounds.width - floatingButton.bounds.width / 2), floatingButton.bounds.width / 2)
        newCenter.y = max(min(newCenter.y, self.view.bounds.height - floatingButton.bounds.height / 2), floatingButton.bounds.height / 2)
        
        floatingButton.center = newCenter
        
        // Reset the gesture's translation to zero so that we get incremental changes
        gesture.setTranslation(.zero, in: self.view)
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
        if title == "Edit" {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
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
        if qtyValue < 10 {
            qtyValue += 1
            
            self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        }
        qty.text = userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        self.setPriceAttritubte()
    }
    
    @IBAction func nextAscreenAction(_ sender: Any) {
        if UserDefaultHelper.authToken != "" {
            self.addToCartApi()
        } else {
            self.dismiss(animated: true) {
                self.delegate?.dismissed()
            }
        }
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = descLabel.frame.size.width
        let newSize = descLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtViewHeight.constant = newSize.height
    }
    
    func getDetails() {
        
        var aParams: [String: Any]?
        
        if UserDefaultHelper.language == "en" {
            aParams = ["item_id": self.itemId, "locale": "English---us"]
        } else if UserDefaultHelper.language == "ar" {
            aParams = ["item_id": self.itemId, "locale": "Arabic---ae"]
        }
        print(aParams!)
        
        APIManager.shared.postCall(APPURL.food_item_details, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"]
            
            self.detailsData = ItemDetailsResponse(fromJson: dataDict)
            let choiceDict = responseJSON["response"]["choice_groups"].arrayValue
            
            for obj in choiceDict {
                self.choiceArr.append(ChoiceGroup(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                
                self.mealImg.loadURL(urlString: self.detailsData?.image, placeholderImage: UIImage(named: "appLogo"))
                self.nameLabel.text = self.detailsData?.name
                self.descLabel.text = self.detailsData?.prodDetails
                
                if self.choiceArr.count > 0 {
                    self.typeOfMealLabel.text = self.choiceArr.first?.title
                    self.requiredLabel.text = "\("required".localized()): \("selectAny".localized()) \(self.choiceArr.first?.minSelection ?? 0) \("option".localized())"
                    self.maximumLabel.text = "0"
                    self.specialMaxTotal = self.choiceArr.first?.maxSelection ?? 0
                    
                    self.specialQuantities = self.choiceArr.first?.choices.map { _ in 0 } ?? []
                    self.mealTypeTblView.reloadData()
                }
                self.setupUI()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        
        let data = self.detailsData
        
        if data?.specialPrice != "" {
            self.itemPrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
            self.basePrice = self.itemPrice
            self.originalBasePrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
        } else {
            self.itemPrice = Double(self.detailsData?.price ?? "") ?? 0.0
            self.basePrice = self.itemPrice
            self.originalBasePrice = Double(self.detailsData?.price ?? "") ?? 0.0
        }
        self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        self.setPriceAttritubte()
    }
    
    private func editSetupUI() {
        
        let data = self.cartDetails
        
        DispatchQueue.main.async {
            
            self.mealImg.loadURL(urlString: data?.product?.image, placeholderImage: UIImage(named: "appLogo"))
            self.nameLabel.text = data?.product?.name
            self.descLabel.text = data?.product?.productDesc
            
            self.noteText =  data?.instruction ?? ""
            self.qtyValue = data?.quantity ?? 1
            self.qty.text = "\(self.qtyValue)"
            
            self.choiceArr = data?.product.choiceGroups ?? []
            if self.choiceArr.count > 0 {
                self.typeOfMealLabel.text = self.choiceArr.first?.title
                self.requiredLabel.text = "\("required".localized()): \("selectAny".localized()) \(self.choiceArr.first?.minSelection ?? 0) \("option".localized())"
                //self.maximumLabel.text = "0"
                self.specialMaxTotal = self.choiceArr.first?.maxSelection ?? 0
                
//                self.specialQuantities = self.choiceArr.first?.choices.map { $0.selectionStatus == 1 ? 1 : 0 } ?? []
//                self.totalQuantity = self.specialQuantities.reduce(0, +)
                
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

extension SpecialProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choiceArr.first?.choices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SpecialMealTVC.identifier) as! SpecialMealTVC
        
        let dict = self.choiceArr.first?.choices[indexPath.row]
        cell.nameLabel.text = "\(dict?.choice ?? "")"
        
        cell.qty.text = "\(self.specialQuantities[indexPath.row])"
        
        if title == "Edit" {
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
        } else {
            cell.onQuantityChanged = { [weak self] change in
                guard let self = self else { return }
                let newTotal = self.totalQuantity + change
                if newTotal <= self.specialMaxTotal && newTotal >= 0 {
                    let newQuantity = self.specialQuantities[indexPath.row] + change
                    if newQuantity >= 0 {
                        self.totalQuantity = newTotal
                        self.specialQuantities[indexPath.row] = newQuantity
                        cell.quantity = newQuantity
                        self.updateSelectedItemsString()
                    }
                }
            }
        }
        
        return cell
    }
    
    func updateSelectedItemsString() {
        
//        for (index, quantity) in self.specialQuantities.enumerated() {
//            if quantity > 0 {
//                if let choiceId = self.choiceArr.first?.choices[index].id {
//                    selectedSpecialItems[choiceId] = quantity
//                }
//            }
//        }
//        
//        let selectedIDsString = selectedSpecialItems.keys.map { String($0) }.joined(separator: ",")
//        let selectedQuantitiesString = selectedSpecialItems.values.map { String($0) }.joined(separator: ",")
//        
//        print("Selected IDs: \(selectedIDsString)")
//        print("Selected Quantities: \(selectedQuantitiesString)")
        
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
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(self.basePrice.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KWD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
    
    func addToCartApi() {
        
        let orderType = UserDefaultHelper.orderType ?? ""
        let hallId = UserDefaultHelper.hallId ?? ""
        let tableId = UserDefaultHelper.tableId ?? ""
        let groupId = UserDefaultHelper.groupId ?? ""
        
        var isCustomized: Bool = false
        if self.basePrice != self.originalBasePrice {
            isCustomized = true
        }
        
        print("\(self.basePrice)")
        
        let selectedIDsString = selectedSpecialItems.keys.map { String($0) }.joined(separator: ",")
        let selectedQuantitiesString = selectedSpecialItems.values.map { String($0) }.joined(separator: ",")
        
        if Int(self.maximumLabel.text!) ?? 0 >= self.choiceArr.first?.minSelection ?? 0 {
            
            if UserDefaultHelper.tableName != "" {
                
                if title == "Edit" {
                    
                    let aParams = ["hall_id": hallId,
                                   "table_id": tableId,
                                   "group_id": groupId,
                                   "order_type": orderType,
                                   "item_id": "\(self.cartDetails?.id ?? 0)",
                                   "combo_id": "",
                                   "unit_price": "\(self.basePrice)",
                                   "quantity": "\(self.qtyValue)",
                                   "is_customized": "Y",
                                   "is_plain": "N",
                                   "ingredients_id": "",
                                   "combo_product_id": "",
                                   "choice_group_id": "\(selectedIDsString)",
                                   "choice_group_quantity": "\(selectedQuantitiesString)",
                                   "instruction": self.noteText,
                                   "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
                    
                    print(aParams)
                    
                    APIManager.shared.postCall(APPURL.customize_cart_item, params: aParams, withHeader: true) { responseJSON in
                        print("Response JSON \(responseJSON)")
                        
                        let dataDict = responseJSON["response"]["data"].arrayValue
                        print(dataDict)
                        let msg = responseJSON["message"].stringValue
                        print(msg)
                        DispatchQueue.main.async {
                            self.showBanner(message: msg, status: .success)
                            UserDefaultHelper.totalPrice! = Double("\(self.basePrice)") ?? 0.0
                            self.delegate?.dismissed()
                            self.navigationController?.popViewController(animated: true)
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                } else {
                    
                    let aParams = ["hall_id": hallId,
                                   "table_id": tableId,
                                   "group_id": groupId,
                                   "order_type": orderType,
                                   "item_id": "\(self.detailsData?.id ?? 0)",
                                   "combo_id": "",
                                   "unit_price": "\(self.basePrice)",
                                   "quantity": "\(self.qtyValue)",
                                   "is_customized": isCustomized == true ? "Y" : "N",
                                   "is_plain": "N",
                                   "ingredients_id": "",
                                   "combo_product_id": "",
                                   "choice_group_id": "\(selectedIDsString)",
                                   "choice_group_quantity": "\(selectedQuantitiesString)",
                                   "instruction": self.noteText,
                                   "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
                    
                    print(aParams)
                    
                    APIManager.shared.postCall(APPURL.add_item_cart, params: aParams, withHeader: true) { responseJSON in
                        print("Response JSON \(responseJSON)")
                        
                        let dataDict = responseJSON["response"]["data"].arrayValue
                        print(dataDict)
                        let msg = responseJSON["message"].stringValue
                        print(msg)
                        DispatchQueue.main.async {
                            self.showBanner(message: msg, status: .success)
                            UserDefaultHelper.totalPrice! = Double("\(self.basePrice)") ?? 0.0
                            self.dismiss(animated: true) {
                                self.delegate?.dismissed()
                            }
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                    
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
