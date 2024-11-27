//
//  DashboardVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit
import SwiftyJSON

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
    
    var pickOption = ["Table 1", "Table 2", "Table 3", "Table 4", "Table 5"]
    var pickerView: UIPickerView!
    
    @IBOutlet weak var searchLabel: UILabel! {
        didSet {
            searchLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            searchLabel.text = "search_product".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var categoryData: [Category] = [Category]()
    var ourBestData: [TryOurBest] = [TryOurBest]()
    
    var activeData = [JSON]()
    var myUsualData = [DashboardMyUsual]()
    var bannerData = [JSON]()
    
    var selectedTable: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.selectedTable != "" {
            selectTableLabel.text = self.selectedTable
        }
                
        mainTableView.register(HomeOrderTVCell.nib(), forCellReuseIdentifier: HomeOrderTVCell.identifier)
        mainTableView.register(MyUsualTVCell.nib(), forCellReuseIdentifier: MyUsualTVCell.identifier)
        mainTableView.register(CategoryTVCell.nib(), forCellReuseIdentifier: CategoryTVCell.identifier)
        mainTableView.register(BannersTVCell.nib(), forCellReuseIdentifier: BannersTVCell.identifier)
        
        mainTableView.register(MealTVCell.nib(), forCellReuseIdentifier: MealTVCell.identifier)
        
        self.getDashboardData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileButton.setTitle(UserDefaultHelper.userName?.getAcronym(), for: .normal)
    }
    @IBAction func selectTableAction(_ sender: UIButton) {
        
        let scanVC = ScanTableVC.instantiate()
        self.navigationController?.push(viewController: scanVC)
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        let profileVC = ProfileViewController.instantiate()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let dashboardVC = SearchViewController.instantiate()
        self.navigationController?.push(viewController: dashboardVC)
    }
    
    private func getDashboardData() {
        
        let aParams: [String: Any] = [:]
        
        let userLanguage = UserDefaultHelper.language
        let dUrl = APPURL.dine_dashboard + "?locale=\(userLanguage == "ar" ? "Arabic---ae" :  "English---us")"
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
                                    
            let catDataDict = responseJSON["response"]["categories"].arrayValue
            
            for obj in catDataDict {
                self.categoryData.append(Category(fromJson: obj))
            }
            
            let bestDataDict = responseJSON["response"]["try_our_best"].arrayValue
            
            for obj in bestDataDict {
                self.ourBestData.append(TryOurBest(fromJson: obj))
            }
            
            let activeDataDict = responseJSON["response"]["my_active_orders"].arrayValue
            self.activeData = activeDataDict
            print(self.activeData.count)
            
            let myUsualDict = responseJSON["response"]["my_usuals"].arrayValue
            for obj in myUsualDict {
                self.myUsualData.append(DashboardMyUsual(fromJson: obj))
            }
            
            let bannerDict = responseJSON["response"]["banner"].arrayValue
            self.bannerData = bannerDict
            
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
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            }
        } else if self.activeData.count == 0 && self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
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
                cell.navController = self.navigationController
                return cell
            }
        } else if self.myUsualData.count == 0 && self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                cell.payNowButton.tag = indexPath.row
                cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
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
                cell.navController = self.navigationController
                return cell
            }
        }
        else if self.activeData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            }
        } else if self.myUsualData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                cell.payNowButton.tag = indexPath.row
                cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            }
        } else if self.bannerData.count == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                cell.payNowButton.tag = indexPath.row
                cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
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
                cell.navController = self.navigationController
                return cell
            }
        }    else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrderTVCell") as! HomeOrderTVCell
                cell.payNowButton.tag = indexPath.row
                cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyUsualTVCell") as! MyUsualTVCell
                cell.usualObj = self.myUsualData
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
                cell.categoryObj = self.categoryData
                cell.reloadCollection()
                cell.navController = self.navigationController ?? UINavigationController()
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BannersTVCell") as! BannersTVCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MealTVCell") as! MealTVCell
                cell.mealObj = self.ourBestData
                cell.reloadCollection()
                cell.navController = self.navigationController
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func payNowAction(sender: UIButton) {
        
        let addVC = PaymentMethodVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        self.present(addVC, animated: true, completion: nil)
    }
}


extension DashboardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectTableLabel.text = pickOption[row]
        
        guard let label = pickerView.view(forRow: row, forComponent: component) as? UILabel else {
            return
        }
        label.backgroundColor = UIColor.primaryBrown.withAlphaComponent(0.5)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickOption[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryBrown])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rowSize = pickerView.rowSize(forComponent: component)
        let width = rowSize.width
        let height = rowSize.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = pickOption[row]
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        return label
    }
}
