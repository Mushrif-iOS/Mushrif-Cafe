//
//  EditCartVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 07/12/24.
//

import UIKit
import ProgressHUD

class EditCartVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart
    
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
    
    @IBOutlet weak var choiceTblView: UITableView!
    @IBOutlet var choiceTblHeight: NSLayoutConstraint!
    @IBOutlet var choiceTblTop: NSLayoutConstraint!
    @IBOutlet var choiceTblBottom: NSLayoutConstraint!
    
    @IBOutlet weak var addButton: UIButton!
    
    var basePrice: Double = Double()
    var originalBasePrice: Double = Double()
    
    var itemPrice: Double = Double()
    var qtyChangeValue: Double = Double()
    //var mealTypePrice: Double = Double()
    var variationPrice: Double = Double()
    
    var qtyValue: Int = 1
    
    var descString = String()
    
    let userLanguage = UserDefaultHelper.language
    
    var firstBoxSelectedRows: [IndexPath] = []
    var ingredientSelectedRows: [IndexPath] = []
    var existingIngredientRows: [IndexPath] = []
    var categorySelecteIndex1: IndexPath?
    var categorySelecteIndex2: IndexPath?
    var categorySelecteIndex3: IndexPath?
    var choiceSelectedRows: [IndexPath] = []
    var isPlainSelected: Bool = false
    
    var itemId: String = ""
    
    //var detailsData: ItemDetailsResponse?
    var ingredientsArr : [FoodItemIngredient] = [FoodItemIngredient]()
    var comboDetails: CartComboDetail?
    var categoryArr1 : [CartComboItem] = [CartComboItem]()
    var categoryArr2 : [CartComboItem] = [CartComboItem]()
    var categoryArr3 : [CartComboItem] = [CartComboItem]()
    var choiceArr : [ChoiceGroup] = [ChoiceGroup]()
    
    var finalIngredientsArr : [IndexPath] = [IndexPath]()
    
    var selectedComboId: Int?
    
    var cartDetails : CartItem?
    
    var mealTypeIndex: IndexPath?
    
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
        self.choiceTblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.mealTypeTblView.allowsMultipleSelection = false
        
        DispatchQueue.main.async {
            self.setupUI()
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
                    self.choiceTblHeight.constant = newsize.height
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
    
    private func setupUI() {
        
        let data = self.cartDetails
        
        self.mealImg.loadURL(urlString: data?.product.image, placeholderImage: UIImage(named: "appLogo"))
        self.nameLabel.text = data?.product.name
        self.descLabel.text = data?.product.name
        
        self.comboDetails = data?.product.comboDetails
        
        self.selectedComboId = data?.comboId
        
        if self.cartDetails?.product?.comboDetails != nil {
            if self.cartDetails?.product?.comboDetails.selectionStatus == 1 {
                
                let firstIndexPath = IndexPath(row: 1, section: 0)
                self.mealTypeTblView.selectRow(at: firstIndexPath, animated: false, scrollPosition: .none)
                
                if let selectedIndexPath = self.mealTypeTblView.indexPathForSelectedRow {
                    self.mealTypeIndex = selectedIndexPath
                }
            } else if self.cartDetails?.product?.comboDetails.selectionStatus == 0 {
                let firstIndexPath = IndexPath(row: 0, section: 0)
                self.mealTypeTblView.selectRow(at: firstIndexPath, animated: false, scrollPosition: .none)
                
                if let selectedIndexPath = self.mealTypeTblView.indexPathForSelectedRow {
                    self.mealTypeIndex = selectedIndexPath
                }
            }
        }
        
//        if data?.comboId != nil {
//            
//            if self.comboDetails?.categories.count == 1 {
//                self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
//            }
//            if self.comboDetails?.categories.count == 2 {
//                self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
//                self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [CartComboItem]()
//            }
//            if self.comboDetails?.categories.count == 3 {
//                self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
//                self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [CartComboItem]()
//                self.categoryArr3 = self.comboDetails?.categories[2].comboItems ?? [CartComboItem]()
//            }
//        }
                
        if data?.product.haveCombo == 0 {
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
            
        } else {
            self.typeOfMealLabel.text = data?.product.name
            if self.cartDetails?.product?.comboDetails != nil {
                self.requiredLabel.text = self.cartDetails?.product?.comboDetails.comboTitle
                self.mealTypeTblHeight.constant = 2 * 52
            } else {
                self.requiredLabel.text = ""
                self.mealTypeTblHeight.constant = 52
            }
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
        self.ingredientsArr = data?.product.ingredients ?? []
        if self.ingredientsArr.count > 0 {
            self.stuffTblHeight.constant = CGFloat(self.ingredientsArr.count * 52) + 52
            self.stuffTblView.reloadData()
        } else {
            self.stuffTblHeight.constant = 52
        }
        
        print(data?.isPlain ?? "")
        self.isPlainSelected = data?.isPlain ?? "" == "Y" ? true : false
        self.stuffTblView.reloadData()
        
        if data?.comboId == nil {
            self.categoryTop.constant = 0
        }
        
        self.choiceArr = data?.product.choiceGroups ?? []
        if self.choiceArr.count > 0 {
            
            for obj in 0..<self.choiceArr.count {
                if self.choiceArr[0].choices[obj].selectionStatus == 1 {
                    self.choiceSelectedRows.append(IndexPath(row: obj, section: 0))
                }
            }
            self.choiceTblView.reloadData()
        }
        
        self.showComboDetailsView()
        
        if data?.product.specialPrice != "" {
            self.itemPrice = Double(data?.product.specialPrice ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.variationPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
            self.originalBasePrice = Double(data?.product.specialPrice ?? "") ?? 0.0
        } else {
            self.itemPrice = Double(data?.product.price ?? "") ?? 0.0
            self.basePrice = self.itemPrice + self.variationPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
            self.originalBasePrice = Double(data?.product.price ?? "") ?? 0.0
        }
        self.qtyChangeValue = (self.itemPrice*Double(qtyValue))
        self.setPriceAttritubte()
    }
    
    private func showComboDetailsView() {
        
        if self.cartDetails?.product?.haveCombo == 1 {
            if self.selectedComboId == self.cartDetails?.product?.comboDetails.id {
                
                if self.comboDetails?.categories.count == 1 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr1.count {
                        if self.comboDetails?.categories[0].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex1 = IndexPath(row: obj, section: 0)
                        }
                    }
                }
                if self.comboDetails?.categories.count == 2 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr1.count {
                        if self.comboDetails?.categories[0].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex1 = IndexPath(row: obj, section: 0)
                        }
                    }
                    self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr2.count {
                        if self.comboDetails?.categories[1].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex2 = IndexPath(row: obj, section: 0)
                        }
                    }
                }
                if self.comboDetails?.categories.count == 3 {
                    self.categoryArr1 = self.comboDetails?.categories[0].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr1.count {
                        if self.comboDetails?.categories[0].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex1 = IndexPath(row: obj, section: 0)
                        }
                    }
                    self.categoryArr2 = self.comboDetails?.categories[1].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr2.count {
                        if self.comboDetails?.categories[1].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex2 = IndexPath(row: obj, section: 0)
                        }
                    }
                    self.categoryArr3 = self.comboDetails?.categories[2].comboItems ?? [CartComboItem]()
                    for obj in 0..<self.categoryArr3.count {
                        if self.comboDetails?.categories[2].comboItems[obj].selectionStatus == 1 {
                            self.categorySelecteIndex3 = IndexPath(row: obj, section: 0)
                        }
                    }
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
                
                self.categorySelecteIndex1 = nil
                self.categorySelecteIndex2 = nil
                self.categorySelecteIndex3 = nil
            }
        }
    }
}

extension EditCartVC: UITableViewDelegate, UITableViewDataSource {
    
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
                cell.nameLabel.text = self.cartDetails?.product?.name
                if self.cartDetails?.product?.specialPrice != "" {
                    let doubleValue = Double(self.cartDetails?.product?.specialPrice ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                } else {
                    let doubleValue = Double(self.cartDetails?.product?.price ?? "") ?? 0.0
                    cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                }
            } else {
                if self.cartDetails?.product?.comboDetails != nil {
                    cell.nameLabel.text = self.cartDetails?.product?.comboDetails.comboTitle
                    if self.cartDetails?.product?.comboDetails.offerPrice != "" {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.offerPrice ?? "") ?? 0.0
                        cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                    } else {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.price ?? "") ?? 0.0
                        cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
                    }
                }
            }
            return cell
        } else if tableView == self.stuffTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            
            let dict = self.ingredientsArr[indexPath.row]
            cell.nameLabel.text = dict.ingredientDetails.name
            cell.priceLabel.text = ""
            
            if dict.requirementStatus == 1 || dict.ingredientDetails.selectionStatus == 0 {
                self.existingIngredientRows.append(indexPath)
            }
            
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
            
            if dict.ingredientDetails.selectionStatus == 1 {
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            
            self.ingredientSelectedRows = self.existingIngredientRows
            cell.callBackTap = {
                if self.ingredientSelectedRows.contains(indexPath) {
                    self.ingredientSelectedRows.remove(at: self.ingredientSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.ingredientSelectedRows.append(indexPath)
                }
                print("self.ingredientSelectedRows", self.ingredientSelectedRows)
                cell.tickButton.isSelected = !cell.tickButton.isSelected
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
            cell.nameLabel.text = dict.choice
            let doubleValue = Double(dict.choicePrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
            
            if choiceSelectedRows.contains(indexPath) {
                cell.tickButton.isSelected = true
                self.choiceSelectedRows.append(indexPath)
            } else {
                cell.tickButton.isSelected = false
                self.choiceSelectedRows.removeAll()
            }
            cell.callBackTap = {
                if self.choiceSelectedRows.contains(indexPath) {
                    let doubleValue = Double(dict.choicePrice) ?? 0.0
                    self.variationPrice -= doubleValue
                    print("self.variationPrice", self.variationPrice)
                    self.choiceSelectedRows.remove(at: self.choiceSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    for ind in 0..<self.choiceArr.count {
                        if indexPath.section == 0 {
                            if self.choiceSelectedRows.count >= self.choiceArr[ind].maxSelection {
                                return
                            }
                        } else if indexPath.section == 1  {
                            if self.choiceSelectedRows.count >= (self.choiceArr[0].maxSelection)+(self.choiceArr[1].maxSelection) {
                                return
                            }
                        }
                    }
                    
                    let doubleValue = Double(dict.choicePrice) ?? 0.0
                    self.variationPrice += doubleValue
                    print("self.variationPrice", self.variationPrice)
                    self.choiceSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath choiceSelectedRows: ", self.choiceSelectedRows)
                self.setPriceAttritubte()
            }
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
            let headerView = tableView.dequeueReusableCell(withIdentifier: CellSelectionTVC.identifier) as! CellSelectionTVC
            headerView.nameLabel.text = "plain".localized()
            headerView.priceLabel.text = ""
            
            var tempArr = [FoodItemIngredient]()
            var tempRows = [IndexPath]()
            
            for i in 0..<self.ingredientsArr.count {
                if self.ingredientsArr[i].plainRequirementStatus == 1 && self.ingredientsArr[i].requirementStatus != 1 {
                    tempArr.append(self.ingredientsArr[i])
                    tempRows.append(IndexPath(row: i, section: 0))
                }
                
                if self.ingredientsArr[i].plainRequirementStatus == 1 {
                    self.finalIngredientsArr = tempRows
                }
            }
            
            if self.isPlainSelected {
                headerView.tickButton.isSelected = true
                //self.isPlainSelected = false
            } else {
                headerView.tickButton.isSelected = false
                //self.isPlainSelected = true
            }
            
            headerView.callBackTap = {
                for i in 0..<tempRows.count {
                    if self.ingredientSelectedRows.contains(IndexPath(row: i, section: 0)) {
                        if let cell = self.stuffTblView.cellForRow(at: IndexPath(row: tempRows[i].row, section: 0)) as? CellSelectionTVC {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                cell.tickButton.isSelected = !cell.tickButton.isSelected
                                headerView.tickButton.isSelected = !headerView.tickButton.isSelected
                                self.isPlainSelected.toggle()
                            }
                        }
                        self.ingredientSelectedRows.remove(at: self.ingredientSelectedRows.firstIndex(of: IndexPath(row: i, section: 0))!)
                        print("self.ingredientSelectedRows", self.ingredientSelectedRows)
                    } else {
                        self.ingredientSelectedRows.append(IndexPath(row: i, section: 0))
                        print("self.ingredientSelectedRows", self.ingredientSelectedRows)
                        if let cell = self.stuffTblView.cellForRow(at: IndexPath(row: tempRows[i].row, section: 0)) as? CellSelectionTVC {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                cell.tickButton.isSelected = !cell.tickButton.isSelected
                                headerView.tickButton.isSelected = !headerView.tickButton.isSelected
                                self.isPlainSelected.toggle()
                            }
                        }
                    }
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if tableView == self.mealTypeTblView {
            if let currentSelectedIndex = self.mealTypeIndex, currentSelectedIndex == indexPath {
                self.mealTypeIndex = indexPath
                if indexPath.row == 0 {

                    if self.cartDetails?.product.specialPrice != "" {
                        self.itemPrice = Double(self.cartDetails?.product.specialPrice ?? "") ?? 0.0
                    } else {
                        self.itemPrice = Double(self.cartDetails?.product?.price ?? "") ?? 0.0
                    }
                    self.selectedComboId = nil
                    print("self.itemPrice", self.itemPrice)
                } else {
                    if self.cartDetails?.product?.comboDetails.offerPrice != "" {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.offerPrice ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                        
                    } else {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.price ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                    }
                    self.selectedComboId = self.cartDetails?.product.comboDetails.id
                    print("self.itemPrice", self.itemPrice)
                }
                self.showComboDetailsView()
            } else {
                self.mealTypeIndex = indexPath
                
                if indexPath.row == 0 {
                    
                    if self.cartDetails?.product.specialPrice != "" {
                        self.itemPrice = Double(self.cartDetails?.product.specialPrice ?? "") ?? 0.0
                    } else {
                        self.itemPrice = Double(self.cartDetails?.product.price ?? "") ?? 0.0
                    }
                    self.selectedComboId = nil
                    print("self.itemPrice", self.itemPrice)
                } else {
                    if self.cartDetails?.product?.comboDetails.offerPrice != "" {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.offerPrice ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                        
                    } else {
                        let doubleValue = Double(self.cartDetails?.product?.comboDetails.price ?? "") ?? 0.0
                        self.itemPrice = doubleValue
                    }
                    self.selectedComboId = self.cartDetails?.product?.comboDetails.id
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
        }
    }
    
    func setPriceAttritubte() {
        if self.qtyChangeValue > 0 {
            self.basePrice = self.qtyChangeValue + self.variationPrice//self.qtyChangeValue + self.mealTypePrice + self.variationPrice
        } else {
            self.basePrice = self.itemPrice + self.variationPrice//self.itemPrice + self.mealTypePrice + self.variationPrice
        }
        
        let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(self.basePrice.toRoundedString(toPlaces: 2))",
                                                   attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
        attrString.append(NSMutableAttributedString(string: " KD",
                                                    attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
        self.addButton.setAttributedTitle(attrString, for: .normal)
    }
    
    func addToCartApi() {
        
        for obj in 0..<self.choiceArr.count {
            if (self.choiceSelectedRows.count < self.choiceArr[obj].minSelection) {
                ProgressHUD.error("Please \(self.choiceArr[obj].title) minimum \(self.choiceArr[obj].minSelection) ")
                return
            }
        }
        
        var finalChoiceRows: [IndexPath] = []
        for obj in 0..<self.choiceArr.count {
            finalChoiceRows.append(IndexPath(row: choiceSelectedRows[obj].row, section: choiceSelectedRows[obj].section))
        }
        print("finalChoiceRows", finalChoiceRows)
        
        var choiceIds = [Int]()
        for i in 0..<finalChoiceRows.count {
            choiceIds.append(self.choiceArr[finalChoiceRows[i].section].choices[finalChoiceRows[i].row].id)
        }
        let choicejsonString = choiceIds.map{String($0)}.joined(separator: ", ")//SingleTon.sharedSingleTon.convertToJSON(arrayObject: choiceIds)
                
        let orderType = UserDefaultHelper.orderType ?? ""
        let hallId = UserDefaultHelper.hallId ?? ""
        let tableId = UserDefaultHelper.tableId ?? ""
        let groupId = UserDefaultHelper.groupId ?? ""
        
        var finalIngredientRows: [IndexPath] = []
        finalIngredientRows.append(contentsOf: existingIngredientRows)
        finalIngredientRows.append(contentsOf: ingredientSelectedRows)
        finalIngredientRows = finalIngredientRows.uniqued()
        
        if self.isPlainSelected {
            finalIngredientRows.append(contentsOf: self.finalIngredientsArr)
            finalIngredientRows = finalIngredientRows.uniqued()
        }
        
        var ingredients_id = [Int]()
        for i in 0..<finalIngredientRows.count {
            ingredients_id.append(self.ingredientsArr[finalIngredientRows[i].row].ingredientDetails.id)
        }
        let ingredientsjsonString = ingredients_id.map{String($0)}.joined(separator: ", ")//SingleTon.sharedSingleTon.convertToJSON(arrayObject: ingredients_id)
                
        var comboProduct = [CartComboItem]()
        if categorySelecteIndex1 != nil {
            comboProduct.append(self.categoryArr1[categorySelecteIndex1!.row])
        } else if categorySelecteIndex2 != nil {
            comboProduct.append(self.categoryArr2[categorySelecteIndex2!.row])
        } else if categorySelecteIndex3 != nil {
            comboProduct.append(self.categoryArr3[categorySelecteIndex3!.row])
        }
        
        var combo_product_id = [Int]()
        
        for i in 0..<comboProduct.count {
            combo_product_id.append(comboProduct[i].id)
        }
        let combojsonString = combo_product_id.map{String($0)}.joined(separator: ", ")//SingleTon.sharedSingleTon.convertToJSON(arrayObject: combo_product_id)
        
        let aParams = ["hall_id": hallId,
                       "table_id": tableId,
                       "group_id": groupId,
                       "order_type": orderType,
                       "item_id": "\(self.cartDetails?.id ?? 0)",
                       "cart_item_id": "\(self.cartDetails?.id ?? 0)",
                       "combo_id": "\(self.selectedComboId ?? 0)",
                       "unit_price": "\(self.basePrice)",
                       "quantity": "\(self.qtyValue)",
                       "is_customized": "Y",
                       "is_plain": self.isPlainSelected ? "Y" : "N",
                       "ingredients_id[]": "\(ingredientsjsonString)",
                       "combo_product_id[]": "\(combojsonString)",
                       "choice_group_id[]": "\(choicejsonString)",
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
                //let cartVC = CartVC.instantiate()
                self.navigationController?.popViewController(animated: true)
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

