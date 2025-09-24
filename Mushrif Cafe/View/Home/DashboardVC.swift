//
//  DashboardVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit
import SwiftyJSON
import EasyNotificationBadge
import CoreLocation

class DashboardVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 13)
            titleLabel.text = "table".localized()
        }
    }
    
    @IBOutlet weak var selectTableLabel: UILabel! {
        didSet {
            selectTableLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            selectTableLabel.text = "select_table".localized()
        }
    }
    
    
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
    var profileData: Customer?
    private let locationManager = LocationManager()
    var objTables: HallAssignment?

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.register(HomeOrderTVCell.nib(), forCellReuseIdentifier: HomeOrderTVCell.identifier)
        mainTableView.register(MyUsualTVCell.nib(), forCellReuseIdentifier: MyUsualTVCell.identifier)
        mainTableView.register(CategoryTVCell.nib(), forCellReuseIdentifier: CategoryTVCell.identifier)
        mainTableView.register(BannersTVCell.nib(), forCellReuseIdentifier: BannersTVCell.identifier)
        
        mainTableView.register(MealTVCell.nib(), forCellReuseIdentifier: MealTVCell.identifier)
     

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ShowOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodRefreshTable(notification:)), name: Notification.Name("RefreshTableInfo"), object: nil)
        
        // Add observer for app becoming active to re-check version
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        versioncheckAPI()

    }
    func setupLocation()  { /// first  we will check location acces that user  is near by cafe or not
        // Set up closures
        locationManager.onLocationReceived = { [weak self] loc in
            if let location = loc {
                print("✅ One-time Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                   // Update UI here if needed
                
                if Utility.isNearByCafe(userLocation: location) { /// user is near by cafe  set old flow but we need to call profile api for set auto table if csutmer is prime then table auto selected

                    self!.checkLoginOrNot(isNearByCafe: true)
                    
                } else { /// show table selection alert before we need to check login or not
                    self!.checkLoginOrNot(isNearByCafe: false)

                }
            }
        }

           locationManager.onLocationDenied = { [weak self] in
               self?.showLocationDeniedAlert()
               self!.checkLoginOrNot(isNearByCafe: false)

           }

           locationManager.onError = { error in
               print("❌ Location error: \(error.localizedDescription)")
           }

           locationManager.requestSingleLocation()
    }
    func checkLoginOrNot(isNearByCafe: Bool)  {
        if !(UserDefaultHelper.authToken ?? "").isBlank{ /// first step we we will call priofle api and check primer cumter or not
            self.getProfile(isNearByCafe: isNearByCafe)
        } else {
            setTableData()
        }
    }
  
    private func versioncheckAPI() {
        var aParams: [String: Any] = [:]
        aParams["version"]  = Utility.getAppVersionAndBuild().version
        APIManager.shared.postCall(APPURL.versioncheck, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let objectVersion = VersionCheckResponse(json: responseJSON)
            // Check if there's a version update available
            if objectVersion.response?.forceLogin == 1 {
                self.showVersionAlert(version: Utility.getAppVersionAndBuild().version)
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    private func showVersionAlert(version: String) {
        // Check if alert is already being presented
        if presentedViewController is UIAlertController {
            return
        }
        
        let alert = UIAlertController(
           title: "update_available".localized(),
           message: String(format: "update_message".localized(), version),
           preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "update".localized(), style: .default, handler: { _ in
            self.redirectToAppStore()
        }))
        present(alert, animated: true)
    }
    
    @objc private func appDidBecomeActive() {
        // Re-show alert if update is still required when app becomes active
        versioncheckAPI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func showTableDelete()  {
          let alert = UIAlertController(
              title: "",
              message: "tbl_delete_msg".localized(),
              preferredStyle: .alert
          )
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .default))
        alert.addAction(UIAlertAction(title: "btn_Yes".localized(), style: .default, handler: { [self] _ in
            UserDefaultHelper.totalItems = 0
            scanTableVC()
          }))
          present(alert, animated: true)

      }
    
    func showLoginAlert()  {
        let alert = UIAlertController(
            title: "",
            message: "lbl_select_cafe".localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default))
        alert.addAction(UIAlertAction(title: "lbl_Login".localized(), style: .default, handler: { _ in

            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)

        }))
        present(alert, animated: true)

    }
    func showLocationAlrt() {
        let popupVC = LocationAlertVC.instantiate()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.comletionBlock = { data  in
            self.objTables = data
            self.setTableData()
        }
        self.present(popupVC, animated: true, completion: nil)

    }
    
    private func showLocationDeniedAlert() {
         let alert = UIAlertController(
            title: "lbl_access_deni".localized(),
            message: "msg_enable_location".localized(),
             preferredStyle: .alert
         )
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default))
        alert.addAction(UIAlertAction(title: "lbl_setting".localized(), style: .default, handler: { _ in
             self.openSettings()
         }))
         present(alert, animated: true)
     }
    
    @objc private func openSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc private func redirectToAppStore() {
        // Try to open with the specific App Store URL first, fallback to search if needed
        let appStoreURL = "https://apps.apple.com/app/mushrif-cafe/id1467496776"
        
        if let url = URL(string: appStoreURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
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
        if let location =  locationManager.currentLocation ,  Utility.isNearByCafe(userLocation: location) {
            self.checkLoginOrNot(isNearByCafe: true)
        } else {
            self.checkLoginOrNot(isNearByCafe: false)

        }
        setUididload()
    }
    func setUididload( ){
        if UserDefaultHelper.authToken != "" {
            profileButton.setTitle((UserDefaultHelper.userName ?? " ").getAcronym(), for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUididload()

      
    }
    
    private func setupBadge() {
        var badgeAppearance = BadgeAppearance()
        badgeAppearance.backgroundColor = UIColor.appRed
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
        if (UserDefaultHelper.tableId ?? "").isBlank == false  , (UserDefaultHelper.totalItems ??  0 ) <= 0 {
            showTableDelete()
        } else {
            if (UserDefaultHelper.tableId ?? "").isBlank  {
                scanTableVC()
            }
        }
   }
    func scanTableVC() {
            if let location =  locationManager.currentLocation ,  Utility.isNearByCafe(userLocation: location) {
                let scanVC = ScanTableVC.instantiate()
                scanVC.title = "LanguageSelection"
                self.navigationController?.push(viewController: scanVC)
            } else {
                if !(UserDefaultHelper.authToken ?? "").isBlank{ /// show location  picker 
                    showLocationAlrt()
                } else {
                    showLoginAlert()
                }
                
            }
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
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { [self] responseJSON in
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

            DispatchQueue.main.async { [self] in
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
                self.setupBadge()
                setupLocation()

             
                /* this is old  flow for set table
                 
                 if self.activeData.count > 0 {
                     if "\(self.activeData.first?.tableId ?? 0)" != UserDefaultHelper.tableId {
                         UserDefaultHelper.tableName = "\(self.activeData.first?.tableNo ?? 0)"
                         self.selectTableLabel.text = UserDefaultHelper.tableName
                     }
                     
                     UserDefaultHelper.hallId = "\(self.activeData.first?.hallId ?? 0)"
                     UserDefaultHelper.tableId = "\(self.activeData.first?.tableId ?? 0)"
                     UserDefaultHelper.groupId = "\(self.activeData.first?.groupId ?? 0)"
                 }
                 
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
                */
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    

    private func getProfile(isNearByCafe: Bool) {
        let aParams: [String: Any] = [:]
        
        APIManager.shared.getCallWithParams(APPURL.getProfileDetails, params: aParams) { [self] responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"].dictionaryValue
            
            let customerData = dataDict["customer"]
            self.profileData = Customer(fromJson: customerData)
            
            if  self.profileData?.specialcustomer == 1 { ///  2 step we will check here custmer is special or if custmer is special then hallId tableId groupId was automatic assign
                UserDefaultHelper.hallId = "\(self.profileData?.hallid ?? 0)"
                UserDefaultHelper.tableId = "\(self.profileData?.tableid ?? 0)"
                UserDefaultHelper.groupId = "\(self.profileData?.groupid ?? 0)"
                UserDefaultHelper.tableName = "\(self.profileData?.tablename ?? 0)"
                
            }
          
            setTableData()
            print("Customer Data", self.profileData!.phone)
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    func setTableData() {
        if let objTbl = objTables {
            if let tblID =  objTbl.tableId {
                UserDefaultHelper.tableId = "\(tblID)"
            } else {
                UserDefaultHelper.tableId = ""
            }
            
            UserDefaultHelper.hallId = "\(objTbl.hallId ?? 0)"
            UserDefaultHelper.groupId = "\(objTbl.groupId ?? 0)"
            UserDefaultHelper.tableName = "\(objTbl.tableName ?? "")"

        }
        if (UserDefaultHelper.tableId ?? "").isBlank  == false {
            //self.selectTableLabel.text = UserDefaultHelper.tableName
            self.selectTableLabel.text = UserDefaultHelper.tableName
            
        } else {
            self.selectTableLabel.text = "select_table".localized()
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
                cell.comletionBlock =  { data in
                    self.objTables = data
                    self.setTableData()
                }
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
            if indexPath.row == 1 {
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
            } else if indexPath.row == 0 {
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
                cell.btnExtraHeadTapped = { [self] catID , title in
                    getSubCategories(id: catID, title: title)
                }
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
            if indexPath.row == 1 {
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
            } else if indexPath.row == 0 {
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
                cell.btnExtraHeadTapped = { [self] catID , title in
                    getSubCategories(id: catID, title: title)
                }
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
                cell.btnExtraHeadTapped = { [self] catID , title in
                    getSubCategories(id: catID, title: title)
                }
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 2 {
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
        }    else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                //let dict = self.activeData[indexPath.row]
                cell.usualObj = self.finalActiveData
                cell.btnExtraHeadTapped = { [self] catID , title in
                    getSubCategories(id: catID, title: title)
                }
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            } else if indexPath.row == 2 {
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
    
    
    private func getSubCategories(id: Int, title : String) {
        var subCategoriesArr : [SubCategory] = [SubCategory]()
        var titles = [ String]()
        var param: [String: Any] = [:]
            if UserDefaultHelper.language == "en" {
                param["category_id"]  = id
                param["locale"]  = "English---us"
            } else if UserDefaultHelper.language == "ar" {
                param["category_id"]  = id
                param["locale"]  = "Arabic---ae"
            }
        print(param)
        APIManager.shared.postCall(APPURL.sub_category, params: param, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]["sub_categories"].arrayValue
            for obj in dataDict {
                let objSub = SubCategory(fromJson: obj)
                subCategoriesArr.append(objSub)
                titles.append(objSub.name)
            }
            let vc = ContentBaseViewController.instantiate()
            vc.strTitle = title
            vc.title = titles.first ?? ""
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.titleNormalFont =  UIFont.poppinsRegularFontWith(size: 14)
            dataSource.titleSelectedFont =  UIFont.poppinsRegularFontWith(size: 14)
            vc.segmentedDataSource = dataSource
            dataSource.titleSelectedColor = .black  // Selected index color
            dataSource.titleNormalColor = .black      // Unselected index color
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.subCategoriesArr = subCategoriesArr
            vc.categoryName = subCategoriesArr.first?.name ?? ""
            vc.categoryId = "\(id)"
            vc.segmentedView.indicators = [indicator]
            self.navigationController?.push(viewController: vc)
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}
