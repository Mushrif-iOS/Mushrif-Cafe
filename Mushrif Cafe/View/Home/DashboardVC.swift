//
//  DashboardVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit
import SwiftyJSON
import EasyNotificationBadge

class DashboardVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "dine_in".localized()
        }
    }
    
    @IBOutlet weak var selectTableLabel: UILabel! {
        didSet {
            selectTableLabel.font = UIFont.poppinsRegularFontWith(size: 14)
            selectTableLabel.text = "select_table".localized()
        }
    }
    
    @IBOutlet weak var selectTableTxt: UITextField! 
    
    @IBOutlet weak var profileButton: UIButton! {
        didSet {
            profileButton.applyGradient(isVertical: true, colorArray: [UIColor.primaryBrown, UIColor.gradiantPink])
            profileButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 20)
        }
    }

    @IBOutlet weak var searchLabel: UILabel! {
        didSet {
            searchLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            searchLabel.text = "search_product".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var scanTableButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    var categoryData: [Category] = [Category]()
    var ourBestData: [TryOurBest] = [TryOurBest]()
    
    var activeData = [MyActiveOrder]()
    var finalActiveData = [MyActiveOrder]()
    var myUsualData = [DashboardMyUsual]()
    var bannerData = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        mainTableView.register(HomeOrderTVCell.nib(), forCellReuseIdentifier: HomeOrderTVCell.identifier)
        mainTableView.register(MyUsualTVCell.nib(), forCellReuseIdentifier: MyUsualTVCell.identifier)
        mainTableView.register(CategoryTVCell.nib(), forCellReuseIdentifier: CategoryTVCell.identifier)
        mainTableView.register(BannersTVCell.nib(), forCellReuseIdentifier: BannersTVCell.identifier)
        
        mainTableView.register(MealTVCell.nib(), forCellReuseIdentifier: MealTVCell.identifier)
        
        //self.getDashboardData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ShowOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodRefreshTable(notification:)), name: Notification.Name("RefreshTableInfo"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.categoryData.removeAll()
        self.ourBestData.removeAll()
        self.finalActiveData.removeAll()
        self.activeData.removeAll()
        self.myUsualData.removeAll()
        self.bannerData.removeAll()
        self.getDashboardData()
        //self.setupBadge()
    }
    
    @objc func methodRefreshTable(notification: Notification) {
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaultHelper.authToken != "" {
            profileButton.setTitle(UserDefaultHelper.userName?.getAcronym(), for: .normal)
            self.setupBadge()
        } else {
            profileButton.setTitle("Guest User".getAcronym(), for: .normal)
        }
                
        self.categoryData.removeAll()
        self.ourBestData.removeAll()
        self.finalActiveData.removeAll()
        self.activeData.removeAll()
        self.myUsualData.removeAll()
        self.bannerData.removeAll()
        self.getDashboardData()
    }
    
    private func setupBadge() {
        var badgeAppearance = BadgeAppearance()
        badgeAppearance.backgroundColor = UIColor.primaryBrown
        badgeAppearance.textColor = UIColor.white
        badgeAppearance.textAlignment = .center
        badgeAppearance.font = UIFont.poppinsLightFontWith(size: 12)
        badgeAppearance.distanceFromCenterX = 13
        badgeAppearance.distanceFromCenterY = -13
        badgeAppearance.allowShadow = true
        badgeAppearance.borderColor = UIColor.white
        badgeAppearance.borderWidth = 0.5
        if "\(UserDefaultHelper.totalItems ?? 0)" == "0" {
            self.cartButton.badge(text: nil)
        } else {
            self.cartButton.badge(text: "\(UserDefaultHelper.totalItems ?? 0)", appearance: badgeAppearance)
        }
    }
    
    @IBAction func selectTableAction(_ sender: UIButton) {
        
        let scanVC = ScanTableVC.instantiate()
        scanVC.title = "LanguageSelection"
        self.navigationController?.push(viewController: scanVC)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        
        if UserDefaultHelper.authToken != "" {
            let profileVC = ProfileViewController.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @IBAction func showCartAction(_ sender: UIButton) {
        if UserDefaultHelper.authToken != "" {
            let cartVC = CartVC.instantiate()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let dashboardVC = SearchViewController.instantiate()
        self.navigationController?.push(viewController: dashboardVC)
        
//        let detailVC = CheckoutVC.instantiate()
//        detailVC.modalPresentationStyle = .formSheet
//        //detailVC.itemId = "\(dict.id ?? 0)"
//        //detailVC.delegate = self
//        self.navigationController?.present(detailVC, animated: true)
    }
    
    private func getDashboardData() {
        
        let aParams: [String: Any] = [:]
        
        let userLanguage = UserDefaultHelper.language
        let dUrl = APPURL.dine_dashboard + "?locale=\(userLanguage == "ar" ? "Arabic---ae" :  "English---us")"
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            UserDefaultHelper.totalItems = responseJSON["response"]["cart_quantity"].intValue
            let catDataDict = responseJSON["response"]["categories"].arrayValue
            
            for obj in catDataDict {
                self.categoryData.append(Category(fromJson: obj))
            }
            
            let bestDataDict = responseJSON["response"]["try_our_best"].arrayValue
            
            for obj in bestDataDict {
                self.ourBestData.append(TryOurBest(fromJson: obj))
            }
            
            let activeDataDict = responseJSON["response"]["my_active_orders"].arrayValue
            for obj in activeDataDict {
                self.activeData.append(MyActiveOrder(fromJson: obj))
            }
            self.finalActiveData = self.activeData
            
            if self.activeData.count > 0 {
                if "\(self.activeData.first?.tableId ?? 0)" != UserDefaultHelper.tableId {
                    UserDefaultHelper.tableName = "\(self.activeData.first?.tableNo ?? 0)"
                    self.selectTableLabel.text = UserDefaultHelper.tableName
                }
                
                UserDefaultHelper.hallId = "\(self.activeData.first?.hallId ?? 0)"
                UserDefaultHelper.tableId = "\(self.activeData.first?.tableId ?? 0)"
                UserDefaultHelper.groupId = "\(self.activeData.first?.groupId ?? 0)"
            }
            
            guard let responseDict = responseJSON["response"].dictionary else {
                print("Invalid response format")
                return
            }

            let myUsualDict = responseJSON["response"]["my_usuals"].arrayValue
            for obj in myUsualDict {
                self.myUsualData.append(DashboardMyUsual(fromJson: obj))
            }
            
            let bannerDict = responseJSON["response"]["banner"].arrayValue
            for obj in bannerDict {
                self.bannerData.append(obj.stringValue)
            }
            
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
                self.setupBadge()
                
                if UserDefaultHelper.tableId != "" {
                    //self.selectTableLabel.text = UserDefaultHelper.tableName
                    if let tableDict = responseDict["table"]?.dictionary {
                        let tableInfo = TableInfo(fromJson: JSON(tableDict))
                        if tableInfo.tableName != "" {
                            self.selectTableLabel.text = tableInfo.tableName
                        } else {
                            self.selectTableLabel.text = UserDefaultHelper.initialTableName
                        }
                    }
                    
                    if UserDefaultHelper.totalItems! != 0 {
                        self.scanTableButton.isUserInteractionEnabled = false
                    } else if self.activeData.count != 0 {
                        self.scanTableButton.isUserInteractionEnabled = false
                    } else {
                        self.scanTableButton.isUserInteractionEnabled = true
                    }
                } else {
                    self.selectTableLabel.text = "select_table".localized()
                    
                    if UserDefaultHelper.totalItems! != 0 {
                        self.scanTableButton.isUserInteractionEnabled = false
                    } else if self.activeData.count != 0 {
                        self.scanTableButton.isUserInteractionEnabled = false
                    } else {
                        self.scanTableButton.isUserInteractionEnabled = true
                    }
                }
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.activeData.count == 0 && self.myUsualData.count == 0 && self.bannerData.count == 0 {
            return 2
        } else if self.activeData.count == 0 && self.myUsualData.count == 0 {
            return 3
        } else if self.activeData.count == 0 && self.bannerData.count == 0 {
            return 3
        } else if self.myUsualData.count == 0 && self.bannerData.count == 0 {
            return 3
        } else if self.activeData.count == 0 {
            return 4
        } else if self.myUsualData.count == 0 {
            return 4
        } else if self.bannerData.count == 0 {
            return 4
        }  else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.activeData.count == 0 && self.myUsualData.count == 0 && self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        } else if self.activeData.count == 0 && self.myUsualData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                cell.bannerData = self.bannerData
                cell.reloadCollection()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        } else if self.activeData.count == 0 && self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        } else if self.myUsualData.count == 0 && self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                //let dict = self.activeData[indexPath.row]
                cell.usualObj = self.finalActiveData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        }
        else if self.activeData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                cell.bannerData = self.bannerData
                cell.reloadCollection()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        } else if self.myUsualData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                //let dict = self.activeData[indexPath.row]
                cell.usualObj = self.finalActiveData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                cell.bannerData = self.bannerData
                cell.reloadCollection()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        } else if self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                //let dict = self.activeData[indexPath.row]
                cell.usualObj = self.finalActiveData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        }    else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                //let dict = self.activeData[indexPath.row]
                cell.usualObj = self.finalActiveData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                cell.bannerData = self.bannerData
                cell.reloadCollection()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.didChangeItemsBlock = {
                    self.setupBadge()
                }
                cell.didUpdateTableInfo = { [weak self] updatedInfo in
                    guard let self = self else { return }
                    
                    if updatedInfo.tableName != "" {
                        UserDefaultHelper.hallId = "\(updatedInfo.hallId)"
                        UserDefaultHelper.tableId = "\(updatedInfo.tableId)"
                        UserDefaultHelper.groupId = "\(updatedInfo.groupId)"
                        UserDefaultHelper.tableName = "\(updatedInfo.tableName)"
                        self.selectTableLabel.text = updatedInfo.tableName
                    } else {
                        self.selectTableLabel.text = UserDefaultHelper.initialTableName
                    }
                }
                cell.navController = self.navigationController
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
