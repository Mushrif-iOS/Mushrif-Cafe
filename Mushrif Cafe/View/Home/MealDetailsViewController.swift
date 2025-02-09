//
//  MealDetailsViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit
import ProgressHUD

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
    
    @IBOutlet weak var stuffView: UIView!
    @IBOutlet var stuffViewHeight: NSLayoutConstraint!
    @IBOutlet var stuffSeperatorHeight: NSLayoutConstraint!
    @IBOutlet var stuffLebelTop: NSLayoutConstraint!
    @IBOutlet var stuffLebelBottom: NSLayoutConstraint!
    @IBOutlet var stuffLabel: UILabel! {
        didSet {
            stuffLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            stuffLabel.text = "select_Ingredients".localized()
        }
    }
    
    @IBOutlet var stuffTblTop: NSLayoutConstraint!
    @IBOutlet var stuffTblBottom: NSLayoutConstraint!
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
    
    @IBOutlet weak var choiceTblView: UITableView!
    @IBOutlet var choiceTblHeight: NSLayoutConstraint!
    @IBOutlet var choiceTblTop: NSLayoutConstraint!
    @IBOutlet var choiceTblBottom: NSLayoutConstraint!
    
    @IBOutlet weak var addButton: UIButton!
    
    var basePrice: Double = Double()
    var originalBasePrice: Double = Double()
    
    var itemPrice: Double = Double()
    var qtyChangeValue: Double = Double()
    var variationPrice: Double = Double()
    
    var qtyValue: Int = 1
        
    let userLanguage = UserDefaultHelper.language
    
    var firstBoxSelectedRows: [IndexPath] = []
    var mealTypeIndex: IndexPath?
    var categorySelecteIndex1: IndexPath?
    var categorySelecteIndex2: IndexPath?
    var categorySelecteIndex3: IndexPath?
    var choiceSelectedRows: [IndexPath] = []
    var isPlainSelected: Bool = false
    
    var itemId: String = ""
    
    var detailsData: ItemDetailsResponse?
    var ingredientsArr : [FoodItemIngredient] = [FoodItemIngredient]()
    var comboDetails: ItemComboDetail?
    var categoryArr1 : [Category] = [Category]()
    var categoryArr2 : [Category] = [Category]()
    var categoryArr3 : [Category] = [Category]()
    var choiceArr : [ChoiceGroup] = [ChoiceGroup]()
    var selectedChoices: [IndexPath: Choice] = [:]
    var selectedChoiceIDs: [Int] = []
    
    var initfinalngredientIDs: [Int] = []
    var finalngredientIDs: [Int] = []
    var footerView: CellSelectionTVC?
        
    var selectedComboId: Int?
    
    var delegate: ToastDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealTypeTblView.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.stuffTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.categoryTblView1.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.categoryTblView2.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        self.categoryTblView3.register(SingleSelectionCell.nib(), forCellReuseIdentifier: SingleSelectionCell.identifier)
        
        if #available(iOS 15.0, *) {
            mealTypeTblView.sectionHeaderTopPadding = 0
            stuffTblView.sectionHeaderTopPadding = 0
            categoryTblView1.sectionHeaderTopPadding = 0
            categoryTblView2.sectionHeaderTopPadding = 0
            categoryTblView3.sectionHeaderTopPadding = 0
            choiceTblView.sectionHeaderTopPadding = 0
        }
        
        self.mealTypeTblView.allowsMultipleSelection = false
        self.choiceTblView.allowsMultipleSelection = true
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        self.mealTypeTblView.selectRow(at: firstIndexPath, animated: false, scrollPosition: .none)
        
        if let selectedIndexPath = self.mealTypeTblView.indexPathForSelectedRow {
            self.mealTypeIndex = selectedIndexPath
        }
        
        self.choiceTblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.getDetails()
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
                    self.choiceTblHeight.constant = newsize.height
                }
            }
        }
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
            
            let ingredientsDict = responseJSON["response"]["ingredients"].arrayValue
            
            for obj in ingredientsDict {
                self.ingredientsArr.append(FoodItemIngredient(fromJson: obj))
            }
            //New Changes
            //self.finalngredientIDs = self.ingredientsArr.filter { $0.requirementStatus == 1 }.map { $0.ingredientDetails.id }
            self.initfinalngredientIDs = self.ingredientsArr.map { $0.ingredientDetails.id }
            self.finalngredientIDs = self.ingredientsArr.map { $0.ingredientDetails.id }
            for index in self.ingredientsArr.indices {
                //New Changes
//                if self.ingredientsArr[index].requirementStatus == 1 {
//                    self.ingredientsArr[index].isChecked = true
//                }
                self.ingredientsArr[index].isChecked = true
            }
            //self.updatePlainCheckedStatus()
            
            let choiceDict = responseJSON["response"]["choice_groups"].arrayValue
            
            for obj in choiceDict {
                self.choiceArr.append(ChoiceGroup(fromJson: obj))
            }
            
            let comboData = dataDict["combo_details"]
            self.comboDetails = ItemComboDetail(fromJson: comboData)
            
            DispatchQueue.main.async {
                
                self.mealImg.loadURL(urlString: self.detailsData?.image, placeholderImage: UIImage(named: "appLogo"))
                self.nameLabel.text = self.detailsData?.name
                self.descLabel.text = self.detailsData?.prodDetails
                
                self.setupUI()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    @objc func footerViewTapped() {
        togglePlainSelection()
    }
    
    func togglePlainSelection() {
        self.isPlainSelected.toggle()
        self.footerView?.isChecked = isPlainSelected
        print("self.isPlainSelected", self.isPlainSelected)
        
        // Select/deselect ingredients with plain_requirement_status == 1
        for index in self.ingredientsArr.indices {
            let ingredient = self.ingredientsArr[index]
            if self.isPlainSelected {
                
                if ingredient.plainRequirementStatus == 1 {
                    ingredient.isChecked = true
                    if !self.finalngredientIDs.contains(ingredient.ingredientDetails.id) {
                        self.finalngredientIDs.append(ingredient.ingredientDetails.id)
                    }
                }
                // Deselect and remove from selected IDs if plain_requirement_status is 0
                else {
                    ingredient.isChecked = false
                    if let idIndex = self.finalngredientIDs.firstIndex(of: ingredient.ingredientDetails.id) {
                        self.finalngredientIDs.remove(at: idIndex)
                    }
                }
            } else {
                if ingredient.plainRequirementStatus == 1 && ingredient.requirementStatus != 1 {
                    ingredient.isChecked = false
                    if let idIndex = self.finalngredientIDs.firstIndex(of: ingredient.ingredientDetails.id) {
                        self.finalngredientIDs.remove(at: idIndex)
                    }
                }
            }
        }
        self.stuffTblView.reloadData()
        print("self.finalngredientIDs", self.finalngredientIDs)
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
            self.typeOfMealLabel.text = "type_of_meal".localized()//data?.name
            self.requiredLabel.text = "required_combo".localized()//data?.comboDetails.comboTitle
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
        }
        if self.ingredientsArr.count > 0 {
            self.stuffTblHeight.constant = CGFloat(self.ingredientsArr.count * 52) + 52
            self.stuffTblView.reloadData()
        } else {
            self.typeOfMealTop.constant = 0
            self.typeOfMealBottom.constant = 0
       
            self.stuffLebelTop.constant = 0
            self.stuffLabel.text = ""
            self.stuffLebelBottom.constant = 0
            self.stuffViewHeight.constant = 0
            self.stuffSeperatorHeight.constant = 0
            self.stuffTblTop.constant = 0
            self.stuffTblHeight.constant = 0
            self.stuffTblBottom.constant = 0
            self.stuffView.isHidden = true
        }
        
        if data?.haveCombo != 1 {
            self.categoryTop.constant = 0
        }
        
        if self.choiceArr.count > 0 {
            self.choiceTblView.reloadData()
        }
        
        self.showComboDetailsView()
        
        if data?.specialPrice != "" {
            self.itemPrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.variationPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
            self.originalBasePrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
        } else {
            self.itemPrice = Double(self.detailsData?.price ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.variationPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
            self.originalBasePrice = Double(self.detailsData?.price ?? "") ?? 0.0
        }
        self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        self.setPriceAttritubte()
    }
    
    private func showComboDetailsView() {
        if self.detailsData?.haveCombo == 1 {
            if self.selectedComboId == self.detailsData?.comboDetails.id {
                
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
                self.categoryTop.constant = 20
                self.categorySeperatorHeight1.constant = 0.3
                self.categorySeperatorHeight2.constant = 0.3
                self.categorySeperatorHeight3.constant = 0.3
            } else {
                self.categoryTop.constant = 0
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
            }
        }
    }
}

extension MealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.choiceTblView {
            return self.choiceArr.count
        } else {
            return 1
        }
    }
    
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
        } else {
            return self.choiceArr[section].choices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mealTypeTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell") as! SingleSelectionCell
            
            if indexPath == self.mealTypeIndex {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            if indexPath.row == 0 {
                cell.nameLabel.text = self.detailsData?.name
                if self.detailsData?.specialPrice != "" {
                    let doubleValue = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                } else {
                    let doubleValue = Double(self.detailsData?.price ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                }
            } else {
                cell.nameLabel.text = self.detailsData?.comboDetails.comboTitle
                if self.detailsData?.comboDetails.offerPrice != "" {
                    let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                } else {
                    let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
                }
            }
            return cell
        } else if tableView == self.stuffTblView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let ingredient = self.ingredientsArr[indexPath.row]
            cell.nameLabel.text = ingredient.ingredientDetails.name
            cell.priceLabel.text = ""
            cell.isChecked = ingredient.isChecked
            
            if ingredient.requirementStatus == 1 {
                cell.tickButton.isSelected = true
                cell.tickButton.alpha = 0.6
                cell.nameLabel.textColor = UIColor.lightGray.withAlphaComponent(0.8)
                cell.isUserInteractionEnabled = false
            } else {
                cell.tickButton.isSelected = false
                cell.tickButton.alpha = 1.0
                cell.nameLabel.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
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
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceRowTVCell") as! ChoiceRowTVCell
            
            if indexPath.row == self.choiceArr[indexPath.section].choices.count - 1 {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
            } else {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            }
            
            let dict = self.choiceArr[indexPath.section].choices[indexPath.row]
            let isSelected = selectedChoices[indexPath] != nil
            cell.configure(with: dict, isSelected: isSelected)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.choiceTblView {
            let dict = self.choiceArr[section]
            let headerView = tableView.dequeueReusableCell(withIdentifier: "ChoiceHeaderTVCell") as! ChoiceHeaderTVCell
            
            headerView.typeOfMealLabel.text = dict.title
            
            if dict.minSelection > 0 {
                headerView.requiredLabel.text = "\("required".localized()) • \("selectAny".localized()) \(dict.minSelection) \("option".localized())"
            } else {
                headerView.requiredLabel.text = "\("optional".localized())"
            }
            return headerView
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.choiceTblView {
            return 80
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.stuffTblView {
            if footerView == nil {
                footerView = Bundle.main.loadNibNamed("CellSelectionTVC", owner: self, options: nil)?.first as? CellSelectionTVC
                footerView?.nameLabel.text = "plain".localized()
                footerView?.priceLabel.text = ""
                //footerView?.isChecked = isPlainSelected
                
                // Add tap gesture recognizer to footer view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(footerViewTapped))
                tapGesture.numberOfTapsRequired = 1
                footerView?.addGestureRecognizer(tapGesture)
            }
            return footerView
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.mealTypeTblView {
            if let currentSelectedIndex = self.mealTypeIndex, currentSelectedIndex == indexPath {
                self.mealTypeIndex = indexPath
                if indexPath.row == 0 {
                    
                    if self.detailsData?.specialPrice != "" {
                        self.itemPrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                    } else {
                        self.itemPrice = Double(self.detailsData?.price ?? "") ?? 0.0
                    }
                    self.selectedComboId = nil
                    print("self.itemPrice", self.itemPrice)
                } else {
                    if self.detailsData?.comboDetails.offerPrice != "" {
                        let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                        
                    } else {
                        let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                    }
                    self.selectedComboId = self.detailsData?.comboDetails.id
                    print("self.itemPrice", self.itemPrice)
                }
                self.showComboDetailsView()
            } else {
                self.mealTypeIndex = indexPath
                
                if indexPath.row == 0 {
                    if self.detailsData?.specialPrice != "" {
                        self.itemPrice = Double(self.detailsData?.specialPrice ?? "") ?? 0.0
                    } else {
                        self.itemPrice = Double(self.detailsData?.price ?? "") ?? 0.0
                    }
                    self.selectedComboId = nil
                    print("self.itemPrice", self.itemPrice)
                } else {
                    if self.detailsData?.comboDetails.offerPrice != "" {
                        let doubleValue = Double(self.detailsData?.comboDetails.offerPrice ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                        
                    } else {
                        let doubleValue = Double(self.detailsData?.comboDetails.price ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                    }
                    self.selectedComboId = self.detailsData?.comboDetails.id
                    print("self.itemPrice", self.itemPrice)
                }
                self.showComboDetailsView()
            }
            self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
            self.setPriceAttritubte()
            tableView.reloadData()
        } else if tableView == self.categoryTblView1 {
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
        } else if tableView == self.choiceTblView {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let group = self.choiceArr[indexPath.section]
            let selectedForSection = selectedChoices.filter { $0.key.section == indexPath.section }
            
            if selectedChoices[indexPath] != nil {
                if let price = Double(group.choices[indexPath.row].choicePrice) {
                    self.variationPrice -= price
                }
                selectedChoices.removeValue(forKey: indexPath)
                if let index = selectedChoiceIDs.firstIndex(of: group.choices[indexPath.row].id) {
                    selectedChoiceIDs.remove(at: index)
                }
            } else if selectedForSection.count < group.maxSelection {
                if let price = Double(group.choices[indexPath.row].choicePrice) {
                    self.variationPrice += price
                }
                selectedChoices[indexPath] = group.choices[indexPath.row]
                selectedChoiceIDs.append(group.choices[indexPath.row].id)
            } else {
                print("Maximum selection reached")
                ProgressHUD.error("\("only".localized()) \(group.maxSelection) \("allowed".localized())")
                return
            }
            
            let selectedCount = selectedChoices.filter { $0.key.section == indexPath.section }.count
            if selectedCount >= group.minSelection, selectedCount <= group.maxSelection {
                print("Total selected price: \(self.variationPrice)")
                print("Selected choice IDs: \(self.selectedChoiceIDs)")
                self.setPriceAttritubte()
            } else {
                print("Selection out of bounds")
                self.setPriceAttritubte()
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if tableView == self.stuffTblView {
            tableView.deselectRow(at: indexPath, animated: true)
            let ingredient = self.ingredientsArr[indexPath.row]
            
            if ingredient.requirementStatus == 1 {
                return
            }
            
            if ingredient.plainRequirementStatus == 1 {
                self.isPlainSelected = true
                self.footerView?.isChecked = isPlainSelected
                
                for index in self.ingredientsArr.indices {
                    let ing = self.ingredientsArr[index]
                    if ing.plainRequirementStatus == 1 {
                        ing.isChecked = true
                        if !self.finalngredientIDs.contains(ing.ingredientDetails.id) {
                            self.finalngredientIDs.append(ing.ingredientDetails.id)
                        }
                    } else {
                        ing.isChecked = false
                        if let idIndex = self.finalngredientIDs.firstIndex(of: ing.ingredientDetails.id) {
                            self.finalngredientIDs.remove(at: idIndex)
                        }
                    }
                }
                tableView.reloadData()
            } else {
                
                self.isPlainSelected = false
                self.footerView?.isChecked = isPlainSelected
                
                for index in self.ingredientsArr.indices {
                    let ing = self.ingredientsArr[index]
                    if ing.plainRequirementStatus == 1 {
                        ing.isChecked = false
                        if ing.requirementStatus != 1 {
                            if let idIndex = self.finalngredientIDs.firstIndex(of: ing.ingredientDetails.id) {
                                self.finalngredientIDs.remove(at: idIndex)
                            }
                        }
                    }
                }
                
                // Toggle the checkbox state for the selected ingredient cell
                ingredient.isChecked.toggle()
                
                // Update the selectedIngredientDetailIDs array
                if ingredient.isChecked {
                    self.finalngredientIDs.append(ingredient.ingredientDetails.id)
                } else {
                    if let index = self.finalngredientIDs.firstIndex(of: ingredient.ingredientDetails.id) {
                        self.finalngredientIDs.remove(at: index)
                    }
                }
                tableView.reloadData()
            }
            // Ensure requirement_status == 1 IDs are always in the array
            for ingr in self.ingredientsArr {
                if ingr.requirementStatus == 1 && !self.finalngredientIDs.contains(ingr.ingredientDetails.id) {
                    self.finalngredientIDs.append(ingr.ingredientDetails.id)
                }
            }
            //tableView.reloadRows(at: [indexPath], with: .automatic)

            print("self.finalngredientIDs", self.finalngredientIDs)
            print("self.isPlainSelected", self.isPlainSelected)
            //self.updatePlainCheckedStatus()
        }
    }
    
//    func updatePlainCheckedStatus() {
//        // Check if there is any plain cell selected
//        let anyPlainSelected = self.ingredientsArr.contains { ingredient in
//            ingredient.plainRequirementStatus != 1 && ingredient.isChecked
//        }
//        
//        // Check if there is any ingredient with plainRequirementStatus == 1 that is selected
//        let anyPlainRequirementSelected = self.ingredientsArr.contains { ingredient in
//            ingredient.plainRequirementStatus == 1 && ingredient.isChecked
//        }
//        
//        // Update the isPlainChecked status based on the conditions
//        self.isPlainSelected = anyPlainSelected && anyPlainRequirementSelected
//        updateFooterView()
//    }
    
    func setPriceAttritubte() {
        if self.qtyChangeValue > 0 {
            self.basePrice = self.qtyChangeValue//self.qtyChangeValue + self.mealTypePrice + self.variationPrice
        } else {
            self.basePrice = self.itemPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
        }
        self.basePrice = self.basePrice + self.variationPrice
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
        
        let ingredientsjsonString = finalngredientIDs.map{String($0)}.joined(separator: ",")
        
        var comboProduct = [Category]()
        if categorySelecteIndex1 != nil {
            comboProduct.append(self.categoryArr1[categorySelecteIndex1!.row])
        } 
        if categorySelecteIndex2 != nil {
            comboProduct.append(self.categoryArr2[categorySelecteIndex2!.row])
        } 
        if categorySelecteIndex3 != nil {
            comboProduct.append(self.categoryArr3[categorySelecteIndex3!.row])
        }
        
        if categorySelecteIndex1 == nil {
            if self.detailsData?.comboDetails != nil {
                if self.selectedComboId == self.detailsData?.comboDetails.id {
                    if self.comboDetails?.categories.count ?? 0 > 0 {
                        ProgressHUD.error("\("select_combo_req".localized()) \(self.comboDetails?.categories[0].name ?? "")")
                        return
                    }
                }
            }
        }
        if categorySelecteIndex2 == nil {
            if self.detailsData?.comboDetails != nil {
                if self.selectedComboId == self.detailsData?.comboDetails.id {
                    if self.comboDetails?.categories.count ?? 0 > 1 {
                        ProgressHUD.error("\("select_combo_req".localized()) \(self.comboDetails?.categories[1].name ?? "")")
                        return
                    }
                }
            }
        }
        if categorySelecteIndex3 == nil {
            if self.detailsData?.comboDetails != nil {
                if self.selectedComboId == self.detailsData?.comboDetails.id {
                    if self.comboDetails?.categories.count ?? 0 > 2 {
                        ProgressHUD.error("\("select_combo_req".localized()) \(self.comboDetails?.categories[2].name ?? "")")
                        return
                    }
                }
            }
        }
        var combo_product_id = [Int]()
        for i in 0..<comboProduct.count {
            combo_product_id.append(comboProduct[i].id ?? 0)
        }
        let combojsonString = combo_product_id.map{String($0)}.joined(separator: ",")
        
        for (sectionIndex, group) in self.choiceArr.enumerated() {
            let selectedForSection = selectedChoices.filter { $0.key.section == sectionIndex }
            if selectedForSection.count < group.minSelection {
                ProgressHUD.error("\("select_atleast".localized()) \(group.minSelection) \("choice_for".localized()) \(group.title).")
                return
            }
        }
        
        let choicejsonString = self.selectedChoiceIDs.map{String($0)}.joined(separator: ",")
        print(choicejsonString)
        
        var isCustomized: Bool = false
            if selectedComboId != nil || self.isPlainSelected == true || self.initfinalngredientIDs != self.finalngredientIDs || combo_product_id.count != 0 || self.selectedChoiceIDs.count != 0 || self.basePrice != self.originalBasePrice {
            isCustomized = true
        }
        
        print("\(self.basePrice)")
        
        let aParams = ["hall_id": hallId,
                       "table_id": tableId,
                       "group_id": groupId,
                       "order_type": orderType,
                       "item_id": "\(self.detailsData?.id ?? 0)",
                       "combo_id": "\(self.selectedComboId ?? 0)",
                       "unit_price": "\(self.basePrice)",
                       "quantity": "\(self.qtyValue)",
                       "is_customized": isCustomized == true ? "Y" : "N",
                       "is_plain": self.isPlainSelected ? "Y" : "N",
                       "ingredients_id": "\(ingredientsjsonString)",
                       "combo_product_id": "\(combojsonString)",
                       "choice_group_id": "\(choicejsonString)",
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
                //                UserDefaultHelper.totalItems! += self.qtyValue
                //                UserDefaultHelper.totalPrice! += Double("\(self.basePrice)") ?? 0.0
                UserDefaultHelper.totalItems! = self.qtyValue
                UserDefaultHelper.totalPrice! = Double("\(self.basePrice)") ?? 0.0
                self.dismiss(animated: true) {
                    self.delegate?.dismissed()
                }
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}
