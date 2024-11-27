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
    
    @IBOutlet var categoryStack: UIStackView!
    @IBOutlet var categoryTop: NSLayoutConstraint!
    @IBOutlet var categoryView1: UIView!
    @IBOutlet var categorySeperatorHeight1: NSLayoutConstraint!
    @IBOutlet var categoryTitleTop1: NSLayoutConstraint!
    @IBOutlet var categoryTitleBottom1: NSLayoutConstraint!
    @IBOutlet var categoryLabel1: UILabel! {
        didSet {
            categoryLabel1.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet weak var categoryTblView1: UITableView!
    @IBOutlet var categoryTblHeight1: NSLayoutConstraint!
    
    @IBOutlet var categoryView2: UIView!
    @IBOutlet var categorySeperatorHeight2: NSLayoutConstraint!
    @IBOutlet var categoryTitleTop2: NSLayoutConstraint!
    @IBOutlet var categoryTitleBottom2: NSLayoutConstraint!
    @IBOutlet var categoryLabel2: UILabel! {
        didSet {
            categoryLabel2.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet weak var categoryTblView2: UITableView!
    @IBOutlet var categoryTblHeight2: NSLayoutConstraint!
    
    @IBOutlet var categoryView3: UIView!
    @IBOutlet var categorySeperatorHeight3: NSLayoutConstraint!
    @IBOutlet var categoryTitleTop3: NSLayoutConstraint!
    @IBOutlet var categoryTitleBottom3: NSLayoutConstraint!
    @IBOutlet var categoryLabel3: UILabel! {
        didSet {
            categoryLabel3.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet weak var categoryTblView3: UITableView!
    @IBOutlet var categoryTblHeight3: NSLayoutConstraint!
    
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
    var originalBasePrice: Double = Double()
    
    var itemPrice: Double = Double()
    var qtyChangeValue: Double = Double()
    var mealTypePrice: Double = Double()
    var variationPrice: Double = Double()
    var adOnPrice: Double = Double()
    
    var qtyValue: Int = 1
    
    var descString = String()
    
    let userLanguage = UserDefaultHelper.language
    
    var firstBoxSelectedRows: [IndexPath] = []
    var ingredientSelectedRows: [IndexPath] = []
    var categorySelecteIndex1: IndexPath?
    var categorySelecteIndex2: IndexPath?
    var categorySelecteIndex3: IndexPath?
    var variationSelectedIndex: IndexPath?
    var addOnSelectedRows: [IndexPath] = []
    var isPlainSelected: Bool = false
    
    var itemId: String = ""
    
    var detailsData: ItemDetailsResponse?
    var ingredientsArr : [FoodItemIngredient] = [FoodItemIngredient]()
    var comboDetails: ItemComboDetail?
    var categoryArr1 : [Category] = [Category]()
    var categoryArr2 : [Category] = [Category]()
    var categoryArr3 : [Category] = [Category]()
    var variationArr : [VariationPrice] = [VariationPrice]()
    var addOnArr : [AddonProduct] = [AddonProduct]()
    
    var selectedVariationId: Int?
    var selectedComboId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealTypeTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.stuffTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.categoryTblView1.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.categoryTblView2.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.categoryTblView3.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.variationTblView.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.addOnTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        
        if #available(iOS 15.0, *) {
            mealTypeTblView.sectionHeaderTopPadding = 0
            stuffTblView.sectionHeaderTopPadding = 0
            categoryTblView1.sectionHeaderTopPadding = 0
            categoryTblView2.sectionHeaderTopPadding = 0
            categoryTblView3.sectionHeaderTopPadding = 0
            variationTblView.sectionHeaderTopPadding = 0
            addOnTblView.sectionHeaderTopPadding = 0
        }
        
        self.getDetails()
    }
    
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
        self.addToCartApi()
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
            
            let comboData = dataDict["combo_details"]
            self.comboDetails = ItemComboDetail(fromJson: comboData)
            
            if self.detailsData?.haveCombo == 1 {
                
                if self.comboDetails?.categories.count == 1 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [Category]()
                }
                if self.comboDetails?.categories.count == 2 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [Category]()
                    self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [Category]()
                }
                if self.comboDetails?.categories.count == 3 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [Category]()
                    self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [Category]()
                    self.categoryArr3 = self.comboDetails?.categories[2].comboItems ?? [Category]()
                }
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
            self.variationTop.constant = 0
            self.categorySeperatorHeight1.constant = 0
            self.categorySeperatorHeight2.constant = 0
            self.categorySeperatorHeight3.constant = 0
            self.categoryTblHeight1.constant = 0
            self.categoryTblHeight2.constant = 0
            self.categoryTblHeight3.constant = 0
            self.categoryLabel1.text = ""
            self.categoryLabel2.text = ""
            self.categoryLabel3.text = ""
            
            self.categoryView1.isHidden = true
            self.categoryView2.isHidden = true
            self.categoryView3.isHidden = true
            
            self.selectedComboId = nil
            
        } else {
            self.typeOfMealLabel.text = data?.name
            self.requiredLabel.text = data?.comboDetails.comboTitle
            self.mealTypeTblHeight.constant = 2 * 52
            self.mealTypeTblView.reloadData()
            
            if self.comboDetails?.categories.count == 1 {
                self.categoryView1.isHidden = false
                self.categoryView2.isHidden = true
                self.categoryView3.isHidden = true
                self.categoryLabel1.text = self.comboDetails?.categories[0].name
                self.categoryTblHeight1.constant = CGFloat(self.categoryArr1.count * 52)
                self.categoryTblView1.reloadData()
            }
            
            if self.comboDetails?.categories.count == 2 {
                self.categoryView1.isHidden = false
                self.categoryLabel1.text = self.comboDetails?.categories[0].name
                self.categoryTblHeight1.constant = CGFloat(self.categoryArr1.count * 52)
                self.categoryTblView1.reloadData()
                
                self.categoryView2.isHidden = false
                self.categoryLabel2.text = self.comboDetails?.categories[1].name
                self.categoryTblHeight2.constant = CGFloat(self.categoryArr2.count * 52)
                self.categoryTblView2.reloadData()
                
                self.categoryView3.isHidden = true
            }
            
            if self.comboDetails?.categories.count == 3 {
                self.categoryView1.isHidden = false
                self.categoryLabel1.text = self.comboDetails?.categories[0].name
                self.categoryTblHeight1.constant = CGFloat(self.categoryArr1.count * 52)
                self.categoryTblView1.reloadData()
                
                self.categoryView2.isHidden = false
                self.categoryLabel2.text = self.comboDetails?.categories[1].name
                self.categoryTblHeight2.constant = CGFloat(self.categoryArr2.count * 52)
                self.categoryTblView2.reloadData()
                
                self.categoryView3.isHidden = false
                self.categoryLabel3.text = self.comboDetails?.categories[2].name
                self.categoryTblHeight3.constant = CGFloat(self.categoryArr3.count * 52)
                self.categoryTblView3.reloadData()
            }
            self.selectedComboId = data?.comboDetails.id
        }
        if self.ingredientsArr.count > 0 {
            self.stuffTblHeight.constant = CGFloat(self.ingredientsArr.count * 52) + 52
            self.stuffTblView.reloadData()
        } else {
            self.stuffTblHeight.constant = 52
        }
        
        if self.variationArr.count == 0 {
            self.variationTop.constant = 20
            self.variationSeperatorHeight.constant = 0
            self.addOnTop.constant = 0
            self.variationTblHeight.constant = 0
            self.variationTitleTop.constant = 0
            self.variationTitleBottom.constant = 0
            self.variationLabel.text = ""
            self.variationView.isHidden = true
        } else {
            self.variationTop.constant = 20
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
        
        if data?.haveCombo != 1 && self.variationArr.count == 0 {
            self.categoryTop.constant = 0
            self.variationTop.constant = 0
            self.addOnTop.constant = 0
        }
        
        if data?.specialPrice != "" {
            self.itemPrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.mealTypePrice + self.variationPrice + self.adOnPrice
            self.originalBasePrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
        } else {
            self.itemPrice = Double(self.detailsData?.price ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.mealTypePrice + self.variationPrice + self.adOnPrice
            self.originalBasePrice = Double(self.detailsData?.price ?? "") ?? 0.0
        }
        self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        self.setPriceAttritubte()
    }
}

extension MealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.mealTypeTblView {
            return 2
        } else if tableView == self.stuffTblView {
            return self.ingredientsArr.count
        } else if tableView == self.categoryTblView1 {
            return self.categoryArr1.count
        } else if tableView == self.categoryTblView2 {
            return self.categoryArr2.count
        } else if tableView == self.categoryTblView3 {
            return self.categoryArr3.count
        } else if tableView == self.variationTblView {
            return self.variationArr.count
        } else {
            return self.addOnArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mealTypeTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            if firstBoxSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
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
            
            cell.callBackTap = {
                if self.firstBoxSelectedRows.contains(indexPath) {
                    self.firstBoxSelectedRows.remove(at: self.firstBoxSelectedRows.firstIndex(of: indexPath)!)
                    if indexPath.row == 0 {
                        if self.detailsData?.specialPrice != "" {
                            let doubleValue = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                            self.mealTypePrice -= doubleValue
                        } else {
                            let doubleValue = Double(self.detailsData?.price ?? "") ?? 0.0
                            self.mealTypePrice -= doubleValue
                        }
                        print("self.mealTypePrice", self.mealTypePrice)
                    } else {
                        if self.detailsData?.comboDetails.offerPrice != "" {
                            let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                            self.mealTypePrice -= doubleValue
                            
                        } else {
                            let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                            self.mealTypePrice -= doubleValue
                        }
                        print("self.mealTypePrice", self.mealTypePrice)
                    }
                } else {
                    self.firstBoxSelectedRows.append(indexPath)
                    if indexPath.row == 0 {
                        if self.detailsData?.specialPrice != "" {
                            let doubleValue = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                            self.mealTypePrice += doubleValue
                        } else {
                            let doubleValue = Double(self.detailsData?.price ?? "") ?? 0.0
                            self.mealTypePrice += doubleValue
                        }
                        print("self.mealTypePrice", self.mealTypePrice)
                    } else {
                        if self.detailsData?.comboDetails.offerPrice != "" {
                            let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                            self.mealTypePrice += doubleValue
                            
                        } else {
                            let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                            self.mealTypePrice += doubleValue
                        }
                        print("self.mealTypePrice", self.mealTypePrice)
                    }
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                self.setPriceAttritubte()
                //print("IndexPath firstBoxSelectedRows: ", self.firstBoxSelectedRows)
            }
            
            return cell
        } else if tableView == self.stuffTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.ingredientsArr[indexPath.row]
            cell.nameLabel.text = dict.ingredientDetails.name
            cell.priceLabel.text = ""
            
            if ingredientSelectedRows.contains(indexPath) || dict.requirementStatus == 1 {
                cell.tickButton.isSelected = true
                cell.nameLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
                cell.isUserInteractionEnabled = false
                self.ingredientSelectedRows.append(indexPath)
            } else {
                cell.tickButton.isSelected = false
                cell.nameLabel.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
                self.ingredientSelectedRows.removeAll()
            }
            cell.callBackTap = {
                if self.ingredientSelectedRows.contains(indexPath) {
                    self.ingredientSelectedRows.remove(at: self.ingredientSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.ingredientSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath ingredientSelectedRows: ", self.ingredientSelectedRows)
            }
            return cell
        } else if tableView == self.categoryTblView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell") as! SingleSelectionCell
            
            let dict = self.categoryArr1[indexPath.row]
            cell.nameLabel.text = dict.name
            cell.priceLabel.text = ""
            
            if indexPath == self.categorySelecteIndex1 {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            return cell
        } else if tableView == self.categoryTblView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell") as! SingleSelectionCell
            
            let dict = self.categoryArr2[indexPath.row]
            cell.nameLabel.text = dict.name
            cell.priceLabel.text = ""
            
            if indexPath == self.categorySelecteIndex2 {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            return cell
        } else if tableView == self.categoryTblView3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell") as! SingleSelectionCell
            
            let dict = self.categoryArr3[indexPath.row]
            cell.nameLabel.text = dict.name
            cell.priceLabel.text = ""
            
            if indexPath == self.categorySelecteIndex3 {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            return cell
        } else if tableView == self.variationTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell") as! SingleSelectionCell
            
            let dict = self.variationArr[indexPath.row]
            var nameArr = [String]()
            
            for i in 0..<dict.option.count {
                nameArr.append(dict.option[i].name)
            }
            
            cell.nameLabel.text = nameArr.joined(separator: ", ")
            self.selectedVariationId = dict.id
            if dict.specialPrice != "" {
                let doubleValue = Double(dict.specialPrice) ?? 0.0
                cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            } else {
                let doubleValue = Double(dict.price) ?? 0.0
                cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            }
            
            if indexPath == self.variationSelectedIndex {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.addOnArr[indexPath.row]
            cell.nameLabel.text = dict.name
            let doubleValueAddOn = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValueAddOn.rounded(toPlaces: 2)) KD"
            
            if addOnSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                if self.addOnSelectedRows.contains(indexPath) {
                    let doubleValueRemoved = Double(self.addOnArr[indexPath.row].price) ?? 0.0
                    self.adOnPrice -= doubleValueRemoved
                    print("self.adOnPrice", self.adOnPrice)
                    self.addOnSelectedRows.remove(at: self.addOnSelectedRows.firstIndex(of: indexPath)!)
                    self.setPriceAttritubte()
                } else {
                    self.addOnSelectedRows.append(indexPath)
                    self.adOnPrice += doubleValueAddOn
                    print("self.adOnPrice", self.adOnPrice)
                    self.setPriceAttritubte()
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: CellSelectionTVC.identifier) as! CellSelectionTVC
        headerView.nameLabel.text = "plain".localized()
        headerView.priceLabel.text = ""
        
        var tempArr = [FoodItemIngredient]()
        var tempRows = [IndexPath]()
        
        for i in 0..<self.ingredientsArr.count {
            if self.ingredientsArr[i].plainRequirementStatus == 1 {
                print("Index Number: ", "\(i)")
                tempArr.append(self.ingredientsArr[i])
                tempRows.append(IndexPath(row: i, section: 0))
                print("tempRows", tempRows)
            }
        }
        
        headerView.callBackTap = {
            if headerView.tickButton.isSelected {
                headerView.tickButton.isSelected = false
                print("self.ingredientSelectedRows TRUE", self.ingredientSelectedRows)
            } else {
                headerView.tickButton.isSelected = true
                print("self.ingredientSelectedRows FALSE", self.ingredientSelectedRows)
            }
//                self.isPlainSelected.toggle()
//                self.ingredientSelectedRows.append(contentsOf: tempRows)
            tableView.reloadData()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.stuffTblView {
            return 52
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.categoryTblView1 {
            if let currentSelectedIndex = self.categorySelecteIndex1, currentSelectedIndex == indexPath {
                self.categorySelecteIndex1 = nil
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                self.categorySelecteIndex1 = indexPath
            }
            tableView.reloadData()
        } else if tableView == self.categoryTblView2 {
            if let currentSelectedIndex = self.categorySelecteIndex2, currentSelectedIndex == indexPath {
                self.categorySelecteIndex2 = nil
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                self.categorySelecteIndex2 = indexPath
            }
            tableView.reloadData()
        } else if tableView == self.categoryTblView3 {
            if let currentSelectedIndex = self.categorySelecteIndex3, currentSelectedIndex == indexPath {
                self.categorySelecteIndex3 = nil
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                self.categorySelecteIndex3 = indexPath
            }
            tableView.reloadData()
        } else if tableView == self.variationTblView {
            
            let dict = self.variationArr[indexPath.row]
            if let currentSelectedIndex = self.variationSelectedIndex, currentSelectedIndex == indexPath {
                self.variationSelectedIndex = nil
                tableView.deselectRow(at: indexPath, animated: true)
                self.selectedVariationId = nil
                self.variationPrice = 0
                if self.qtyChangeValue > 0 {
                    self.qtyChangeValue = self.originalBasePrice
                } else {
                    self.itemPrice = self.originalBasePrice
                }
                print("self.variationPrice", self.variationPrice)
                self.setPriceAttritubte()
            } else {
                self.selectedVariationId = dict.id
                self.variationSelectedIndex = indexPath
                if dict.specialPrice != "" {
                    self.variationPrice = Double(dict.specialPrice) ?? 0.0
                } else {
                    self.variationPrice = Double(dict.price) ?? 0.0
                }
                print("self.variationPrice", self.variationPrice)
                self.setPriceAttritubte()
            }
            tableView.reloadData()
        }
    }
    
    func setPriceAttritubte() {
        if self.qtyChangeValue > 0 {
            self.basePrice = self.qtyChangeValue + self.mealTypePrice + self.variationPrice + self.adOnPrice
            //self.originalBasePrice = self.qtyChangeValue + self.mealTypePrice + self.variationPrice + self.adOnPrice
        } else {
            self.basePrice = self.itemPrice + self.mealTypePrice + self.variationPrice + self.adOnPrice
            //self.originalBasePrice = self.itemPrice + self.mealTypePrice + self.variationPrice + self.adOnPrice
        }
        
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(self.basePrice.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
    
    func addToCartApi() {
                
//        let orderType = UserDefaultHelper.orderType ?? ""
//        let hallId = UserDefaultHelper.hallId ?? ""
//        let tableId = UserDefaultHelper.tableId ?? ""
//        let groupId = UserDefaultHelper.groupId ?? ""
//        
//        let aParams = ["hall_id": hallId, "table_id": tableId, "group_id": groupId, "order_type": orderType, "item_id": "\(self.detailsData?.id ?? 0)", "variation_id": "\(self.selectedVariationId ?? 0)", "combo_id": "\(self.selectedComboId ?? 0)", "unit_price": "\(self.basePrice)", "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
//        
//        print(aParams)
//        
//        APIManager.shared.postCall(APPURL.add_item_cart, params: aParams, withHeader: true) { responseJSON in
//            print("Response JSON \(responseJSON)")
//            
//            let searchDataDict = responseJSON["response"]["data"].arrayValue
//            print(searchDataDict)
////            for obj in searchDataDict {
////                self.searchData.append(SearchData(fromJson: obj))
////            }
////            
////            DispatchQueue.main.async {
////
////            }
//            
//        } failure: { error in
//            print("Error \(error.localizedDescription)")
//        }
    }
}
