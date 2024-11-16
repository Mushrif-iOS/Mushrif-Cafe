//
//  MealDetailsViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit

class MealDetailsViewController: UIViewController, Instantiatable {
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
    @IBOutlet var typeOfMealHeight: NSLayoutConstraint!
    @IBOutlet var typeOfMealBottom: NSLayoutConstraint!
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
    
    @IBOutlet weak var stepperView: UIView!
    
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 30)
            qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    @IBOutlet weak var mealTypeTblView: UITableView!
    @IBOutlet var mealTypeTblHeight: NSLayoutConstraint!
    
    @IBOutlet var stuffLabel: UILabel! {
        didSet {
            stuffLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            stuffLabel.text = "select_Ingredients".localized()
        }
    }
    
    @IBOutlet weak var stuffTblView: UITableView!
    @IBOutlet var stuffTblHeight: NSLayoutConstraint!
    
    @IBOutlet var categoryTop: NSLayoutConstraint!
    @IBOutlet var categoryView: UIView!
    @IBOutlet var categorySeperatorHeight: NSLayoutConstraint!
    @IBOutlet var categoryTitleTop: NSLayoutConstraint!
    @IBOutlet var categoryTitleBottom: NSLayoutConstraint!
    @IBOutlet var categoryLabel: UILabel! {
        didSet {
            categoryLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet weak var categoryTblView: UITableView!
    @IBOutlet var categoryTblHeight: NSLayoutConstraint!
    
    @IBOutlet var variationLabel: UILabel! {
        didSet {
            variationLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet var variationTop: NSLayoutConstraint!
    @IBOutlet var variationViewHeight: NSLayoutConstraint!
    @IBOutlet var variationView: UIView!
    @IBOutlet weak var variationTblView: UITableView!
    @IBOutlet var variationTblHeight: NSLayoutConstraint!
    @IBOutlet var variationSeperatorHeight: NSLayoutConstraint!
    @IBOutlet var variationTitleTop: NSLayoutConstraint!
    @IBOutlet var variationTitleBottom: NSLayoutConstraint!
    
    @IBOutlet var addOnLabel: UILabel! {
        didSet {
            addOnLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    
    @IBOutlet var addOnTop: NSLayoutConstraint!
    @IBOutlet var addOnHeight: NSLayoutConstraint!
    @IBOutlet var addOnView: UIView!
    @IBOutlet weak var addOnTblView: UITableView!
    @IBOutlet var addOnTblHeight: NSLayoutConstraint!
    @IBOutlet var addOnBottom: NSLayoutConstraint!
    @IBOutlet var addOnSeperatorHeight: NSLayoutConstraint!
    @IBOutlet var addOnTitleTop: NSLayoutConstraint!
    @IBOutlet var addOnTitleBottom: NSLayoutConstraint!
    
    @IBOutlet weak var addButton: UIButton!
    
    var basePrice: Double = Double()
    var totalValue: Double = Double()
    var qtyValue: Int = 1
    
    var descString = String()
    
    let userLanguage = UserDefaultHelper.language
    
    var arrSelectedRows: [IndexPath] = []
    
    var itemId: String = ""
    
    var detailsData: ItemDetailsResponse?
    var ingredientsArr : [FoodItemIngredient] = [FoodItemIngredient]()
    var comboDetails: ItemComboDetail?
    var categoryArr : [Category] = [Category]()
    var variationArr : [VariationPrice] = [VariationPrice]()
    var addOnArr : [AddonProduct] = [AddonProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealTypeTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.stuffTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.categoryTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.variationTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.addOnTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        
//        self.mealTypeTblView.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
//        self.stuffTblView.addObserver(self, forKeyPath: "contentSize1", options: [.old, .new], context: nil)
//        self.variationTblView.addObserver(self, forKeyPath: "contentSize2", options: [.old, .new], context: nil)
//        self.addOnTblView.addObserver(self, forKeyPath: "contentSize3", options: [.old, .new], context: nil)
        if #available(iOS 15.0, *) {
            mealTypeTblView.sectionHeaderTopPadding = 0
            stuffTblView.sectionHeaderTopPadding = 0
            variationTblView.sectionHeaderTopPadding = 0
            addOnTblView.sectionHeaderTopPadding = 0
        }
        
        self.getDetails()
    }
    
    /*override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.mealTypeTblHeight.constant = newsize.height
                }
            }
            print(keyPath)
        }
        else if(keyPath == "contentSize1") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.stuffTblHeight.constant = newsize.height
                }
            }
            print(keyPath)
        }
        else if(keyPath == "contentSize2") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.variationTblHeight.constant = newsize.height
                }
            }
            print(keyPath)
        }
        else if(keyPath == "contentSize3") {
            if let newvalue2 = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue2 as! CGSize
                    self.addOnTblHeight.constant = newsize.height
                }
            }
            print(keyPath)
        }
    }*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustTextViewHeight()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if qtyValue > 1 {
            qtyValue -= 1
            
            self.totalValue = (self.basePrice*Double(qtyValue))
        }
        qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(totalValue.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
    
    @IBAction func plusAction(_ sender: Any) {
        if qtyValue < 10 {
            qtyValue += 1
            
            self.totalValue = (self.basePrice*Double(qtyValue))
        }
        qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(totalValue.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
    
    @IBAction func nextAscreenAction(_ sender: Any) {
        self.dismiss(animated: true)
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
            
            let ingredientsDict = responseJSON["response"]["ingredients"].arrayValue
            
            for obj in ingredientsDict {
                self.ingredientsArr.append(FoodItemIngredient(fromJson: obj))
            }
            
            let catDataDict = responseJSON["response"].dictionaryValue
            let comboData = dataDict["combo_details"]
            self.comboDetails = ItemComboDetail(fromJson: comboData)
                   
            if self.detailsData?.haveCombo == 1 {
                self.categoryArr = self.comboDetails?.categories.first?.comboItems ?? [Category]()
            }
            
            let varDict = responseJSON["response"]["variation_prices"].arrayValue
            
            var fetchVariationArr : [VariationPrice] = [VariationPrice]()
            
            for obj in varDict {
                fetchVariationArr.append(VariationPrice(fromJson: obj))
            }
            if(fetchVariationArr.count > 0) {
                for obj in 0..<fetchVariationArr.count {
                    if(fetchVariationArr[obj].isAvailable == 1) {
                        self.variationArr.append(fetchVariationArr[obj])
                    }
                }
            }
            
            let addOnDict = responseJSON["response"]["addon_products"].arrayValue
            
            for obj in addOnDict {
                self.addOnArr.append(AddonProduct(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                
                self.mealImg.loadURL(urlString: self.detailsData?.image, placeholderImage: UIImage(named: "pizza"))
                self.nameLabel.text = self.detailsData?.name
                self.descLabel.text = self.descString
                
                self.setupUI()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        
        let data = self.detailsData
        
        if data?.haveCombo != 1 {
            self.typeOfMealTop.constant = 20
            self.typeOfMealHeight.constant = 0
            self.typeOfMealSeperatorHeight.constant = 0
            self.typeOfMealBottom.constant = 0
            self.mealTypeTblHeight.constant = 0
            
            self.categoryTop.constant = 0
            self.categorySeperatorHeight.constant = 0
            self.variationTop.constant = 0
            self.categoryTblHeight.constant = 0
            self.categoryTitleTop.constant = 0
            self.categoryTitleBottom.constant = 0
            self.categoryLabel.text = ""
            self.categoryView.isHidden = true
        } else {
            self.typeOfMealLabel.text = data?.name
            self.requiredLabel.text = data?.comboDetails.comboTitle
            self.mealTypeTblHeight.constant = 2 * 52
            self.mealTypeTblView.reloadData()
            
            self.categoryView.isHidden = false
            self.categoryLabel.text = self.comboDetails?.categories.first?.name
            self.categoryTblHeight.constant = CGFloat(self.categoryArr.count * 52)
            self.categoryTblView.reloadData()
        }
        if self.ingredientsArr.count > 0 {
            self.stuffTblHeight.constant = CGFloat(self.ingredientsArr.count * 52) + 52
            self.stuffTblView.reloadData()
        } else {
            self.stuffTblHeight.constant = 52
        }
        
        if self.variationArr.count == 0 {
            self.variationTop.constant = 20
            //self.variationViewHeight.constant = 0
            self.variationSeperatorHeight.constant = 0
            self.addOnTop.constant = 0
            self.variationTblHeight.constant = 0
            self.variationTitleTop.constant = 0
            self.variationTitleBottom.constant = 0
            self.variationLabel.text = ""
            self.variationView.isHidden = true
        } else {
            self.variationView.isHidden = false
            self.variationLabel.text = "variations".localized()
            self.variationTblHeight.constant = CGFloat(self.variationArr.count * 52)
            self.variationTblView.reloadData()
        }
        
        if self.addOnArr.count == 0 {
            self.addOnTop.constant = 20
            //self.addOnHeight.constant = 0
            self.addOnSeperatorHeight.constant = 0
            self.addOnBottom.constant = 0
            self.addOnTblHeight.constant = 0
            self.addOnTitleTop.constant = 0
            self.addOnTitleBottom.constant = 0
            self.addOnLabel.text = ""
            self.addOnView.isHidden = true
        } else {
            self.addOnView.isHidden = false
            self.addOnLabel.text = "addOns".localized()
            self.addOnTblHeight.constant = CGFloat(self.addOnArr.count * 52)
            self.addOnTblView.reloadData()
        }
        
        if data?.specialPrice != "" {
            self.totalValue = Double(data?.specialPrice ?? "") ?? 0.0
            self.basePrice = Double(data?.specialPrice ?? "") ?? 0.0
        } else {
            self.totalValue = Double(data?.price ?? "") ?? 0.0
            self.basePrice = Double(data?.price ?? "") ?? 0.0
        }
        
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(totalValue.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
}

extension MealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.mealTypeTblView {
            return 2
        } else if tableView == self.stuffTblView {
            return self.ingredientsArr.count
        } else if tableView == self.categoryTblView {
            return self.categoryArr.count
        } else if tableView == self.variationTblView {
            return self.variationArr.count
        } else {
            return self.addOnArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mealTypeTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            if arrSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                cell.tickButton.isSelected = !cell.tickButton.isSelected
            }
            
            if indexPath.row == 0 {
                cell.nameLabel.text = self.detailsData?.name
                if self.detailsData?.specialPrice != "" {
                    let doubleValue = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                } else {
                    let doubleValue = Double(self.detailsData?.price ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                }
            } else {
                cell.nameLabel.text = self.detailsData?.comboDetails.comboTitle
                if self.detailsData?.comboDetails.offerPrice != "" {
                    let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                } else {
                    let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                }
            }
            
            return cell
        } else if tableView == self.categoryTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.categoryArr[indexPath.row]
            cell.nameLabel.text = dict.name
            cell.priceLabel.text = ""
            
            if arrSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
                cell.isUserInteractionEnabled = false
            } else {
                cell.tickButton.isSelected = false
                cell.isUserInteractionEnabled = true
            }
            cell.callBackTap = {
                if self.arrSelectedRows.contains(indexPath) {
                    self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.arrSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath: ", self.arrSelectedRows)
            }
            return cell
        } else if tableView == self.stuffTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.ingredientsArr[indexPath.row]
            cell.nameLabel.text = dict.ingredientDetails.name
            cell.priceLabel.text = ""
            
            if arrSelectedRows.contains(indexPath) || dict.requirementStatus == 1 {
                cell.tickButton.isSelected = true
                cell.isUserInteractionEnabled = false
            } else {
                cell.tickButton.isSelected = false
                cell.isUserInteractionEnabled = true
            }
            cell.callBackTap = {
                if self.arrSelectedRows.contains(indexPath) {
                    self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.arrSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath: ", self.arrSelectedRows)
            }
            return cell
        } else if tableView == self.variationTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.variationArr[indexPath.row]
            var nameArr = [String]()
            
            for i in 0..<dict.option.count {
                nameArr.append(dict.option[i].name)
            }
            
            cell.nameLabel.text = nameArr.joined(separator: ", ")
            if dict.specialPrice != "" {
                let doubleValue = Double(dict.specialPrice) ?? 0.0
                cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            } else {
                let doubleValue = Double(dict.price) ?? 0.0
                cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            }
            
            if arrSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
                cell.isUserInteractionEnabled = false
            } else {
                cell.tickButton.isSelected = false
                cell.isUserInteractionEnabled = true
            }
            cell.callBackTap = {
                if self.arrSelectedRows.contains(indexPath) {
                    self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.arrSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath: ", self.arrSelectedRows)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.addOnArr[indexPath.row]
            cell.nameLabel.text = dict.name
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            
            if arrSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                cell.tickButton.isSelected = !cell.tickButton.isSelected
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.stuffTblView {
            let headerView = tableView.dequeueReusableCell(withIdentifier: CellSelectionTVC.identifier) as! CellSelectionTVC
            headerView.nameLabel.text = "plain".localized()
            headerView.priceLabel.text = ""
            
            //            if arrSelectedRows.contains(IndexPath(row: 0, section: section)) {
            //                headerView.tickButton.isSelected = true
            //            } else {
            //                headerView.tickButton.isSelected = false
            //            }
            headerView.callBackTap = {
                headerView.tickButton.isSelected = !headerView.tickButton.isSelected
            }
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.stuffTblView {
            return 52
        } else {
            return 0
        }
    }
}
