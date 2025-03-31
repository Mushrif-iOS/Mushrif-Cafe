//
//  CategoryViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/10/24.
//

import UIKit

class CategoryViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var subCategoriesArr : [SubCategory] = [SubCategory]()
    var foodItemArr : [FoodItemData] = [FoodItemData]()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    @IBOutlet var heightBottom: NSLayoutConstraint!
    
    var categoryId = String()
    var categoryName = String()
    
    var pageNo: Int = 1
    var lastPage: Int = Int()
    var subCategoryId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = self.categoryName
        
        mainTableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 6.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.mainCollectionView.collectionViewLayout = layout
        
        self.getSubCategories()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("OrderView"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        let orderVC = MyOrderViewController.instantiate()
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.applyGradient(isVertical: true, colorArray: [UIColor.primaryBrown, UIColor.borderPink])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaultHelper.totalItems ?? 0 == 0 {
            self.heightBottom.constant = 0
            self.bottomView.isHidden = true
        } else {
            self.heightBottom.constant = 90
            self.bottomView.isHidden = false
            self.totalLabel.text = "\(UserDefaultHelper.totalItems ?? 0) \("item_added".localized()) - \(UserDefaultHelper.totalPrice ?? 0.0) KWD"
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let searchVC = SearchViewController.instantiate()
        self.navigationController?.push(viewController: searchVC)
    }
    
    @IBAction func goToNextAction(_ sender: Any) {
        if UserDefaultHelper.authToken != "" {
            let cartVC = CartVC.instantiate()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    private func getSubCategories() {
        
        var aParams: [String: Any]?
        
        if UserDefaultHelper.language == "en" {
            aParams = ["category_id": "\(self.categoryId)", "locale": "English---us"]
        } else if UserDefaultHelper.language == "ar" {
            aParams = ["category_id": "\(self.categoryId)", "locale": "Arabic---ae"]
        }
        print(aParams!)
        
        APIManager.shared.postCall(APPURL.sub_category, params: aParams, withHeader: false) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"]["sub_categories"].arrayValue
            
            for obj in dataDict {
                self.subCategoriesArr.append(SubCategory(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                if self.subCategoriesArr.count > 0 {
                    self.subTitleLabel.text = self.subCategoriesArr.first?.name
                    self.mainCollectionView.reloadData()
                    self.mainCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                    self.getProductList(subCatId: "\(self.subCategoriesArr.first?.id ?? 0)", page: self.pageNo)
                } else {
                    self.showBanner(message: "no_subcategory".localized(), status: .failed)
                }
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func getProductList(subCatId: String, page: Int) {
        
        var aParams: [String: Any]?
        
        if UserDefaultHelper.language == "en" {
            aParams = ["category_id": "\(self.categoryId)", "sub_category_id": "\(subCatId)", "locale": "English---us"]
        } else if UserDefaultHelper.language == "ar" {
            aParams = ["category_id": "\(self.categoryId)", "sub_category_id": "\(subCatId)", "locale": "Arabic---ae"]
        }
        print(aParams!)
        
        APIManager.shared.postCall(APPURL.food_item_list + "?page=\(page)", params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let lPage = responseJSON["response"]["last_page"].intValue
            self.lastPage = lPage
            
            let itemDataDict = responseJSON["response"]["data"].arrayValue
            
            for obj in itemDataDict {
                self.foodItemArr.append(FoodItemData(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subCategoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVCell", for: indexPath) as! TagsCVCell
        cell.textLabel.text = self.subCategoriesArr[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = self.subCategoriesArr[indexPath.item]
        self.subTitleLabel.text = dict.name
        
        self.subCategoryId = "\(dict.id)"
        self.foodItemArr.removeAll()
        self.getProductList(subCatId: "\(dict.id)", page: self.pageNo)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource, ToastDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.foodItemArr.count == 0 {
            tableView.setEmptyMessage("no_product".localized())
        } else {
            tableView.restore()
        }
        return self.foodItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        let dict = self.foodItemArr[indexPath.row]
        cell.nameLabel.text = dict.name
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "appLogo"))
        
        if dict.specialPrice != "" {
            let doubleValue = Double(dict.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        } else {
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        }
        
        cell.descLabel.text = dict.name
        cell.addButton.tag = indexPath.item
        cell.addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        cell.addUsual.tag = indexPath.item
        cell.addUsual.addTarget(self, action: #selector(addUsualAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if self.pageNo < self.lastPage && indexPath.item == (self.foodItemArr.count) - 1 {
            
            if(pageNo < self.lastPage) {
                
                print("Last Page: ", self.lastPage)
                
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(50))
                spinner.startAnimating()
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
                
                self.pageNo += 1
                print("Last ID: ", self.pageNo)
                
                self.getProductList(subCatId: self.subCategoryId, page: self.pageNo)
            } else {
                tableView.tableFooterView?.removeFromSuperview()
                let view = UIView()
                view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
                tableView.tableFooterView = view
                tableView.tableFooterView?.isHidden = true
            }
        } else {
            tableView.tableFooterView?.removeFromSuperview()
            let view = UIView()
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
            tableView.tableFooterView = view
            tableView.tableFooterView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.foodItemArr[indexPath.row]
        if dict.productType == 5 {
            let detailVC = SpecialProductVC.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        } else {
            let detailVC = MealDetailsViewController.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        }
    }
    
    @objc func addAction(sender: UIButton) {
        let dict = self.foodItemArr[sender.tag]
        
        if dict.productType == 5 {
            let detailVC = SpecialProductVC.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        } else {
            
            if UserDefaultHelper.authToken != "" {
                let orderType = UserDefaultHelper.orderType ?? ""
                let hallId = UserDefaultHelper.hallId ?? ""
                let tableId = UserDefaultHelper.tableId ?? ""
                let groupId = UserDefaultHelper.groupId ?? ""
                
                if tableId != "" {
                    let aParams = ["hall_id": hallId,
                                   "table_id": tableId,
                                   "group_id": groupId,
                                   "order_type": orderType,
                                   "item_id": "\(dict.id)",
                                   "combo_id": "",
                                   "unit_price": dict.specialPrice != "" ? "\(dict.specialPrice)" : "\(dict.price)",
                                   "quantity": "1",
                                   "is_customized": "N",
                                   "is_plain": "N",
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
                            UserDefaultHelper.totalPrice! += (dict.specialPrice != "" ? Double("\(dict.specialPrice)") : Double("\(dict.price)")) ?? 0.0
                            self.totalLabel.text = "\(UserDefaultHelper.totalItems ?? 0) \("item_added".localized()) - \(UserDefaultHelper.totalPrice ?? 0.0) KWD"
                            let cartVC = CartVC.instantiate()
                            self.navigationController?.pushViewController(cartVC, animated: true)
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                } else {
                    self.showBanner(message: "please_scan".localized(), status: .warning)
                    let scanVC = ScanTableVC.instantiate()
                    scanVC.title = "LanguageSelection"
                    self.navigationController?.push(viewController: scanVC)
                }
            } else {
                let profileVC = LoginVC.instantiate()
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    @objc func addUsualAction(sender: UIButton) {
        if UserDefaultHelper.authToken != "" {
//            if let cell = self.mainTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? CategoryTableViewCell {
//                //cell.saveButton.isSelected.toggle()
//            }
            let dict = self.foodItemArr[sender.tag]
            let addVC = AddUsualsVC.instantiate()
//            if #available(iOS 15.0, *) {
//                if let sheet = addVC.sheetPresentationController {
//                    sheet.detents = [.medium()]
//                    sheet.preferredCornerRadius = 15
//                }
//            }
            addVC.productId = "\(dict.id)"
            addVC.itemType = "listed"
            self.present(addVC, animated: true, completion: nil)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func dismissed() {
        if UserDefaultHelper.authToken != "" {
            let cartVC = CartVC.instantiate()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
