//
//  ProfileViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 04/10/24.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var pickOption = ["English", "العربية"]
    var pickerView: UIPickerView!
    
    @IBOutlet weak var selectLanguageTxt: UITextField!
    
    @IBOutlet weak var languageButton: UIButton!
    
    var menuItems = ["my_orders".localized(), "manage".localized(), "wallet".localized(), "contact_us".localized(), "terms_and_conditions".localized(), "logout".localized()]
    var menuImgs = [UIImage(named: "plate-utensils"), UIImage(named: "saved"), UIImage(named: "wallet"), UIImage(named: "headset"), UIImage(named: "document"), UIImage(named: "leave")]
    
    var profileData: Customer?
    
    var languageMenu: UIMenu {
        return UIMenu(title: "select_language".localized(), image: nil, identifier: .none, options: .singleSelection, children: langMenuItems)
    }
    
    var langMenuItems: [UIAction] {
        return [
            UIAction(title: "English", image: nil, state: UserDefaultHelper.language == "en" ? .on : .off, handler: { (_) in
                print("English")
                UserDefaultHelper.language = "en"
                DispatchQueue.main.async {
                    let userLanguage = UserDefaultHelper.language
                    UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
                    UserDefaultHelper.isLanguageSelected = "yes"
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.restartApp()
                }
            }),
            UIAction(title: "العربية", image: nil, state: UserDefaultHelper.language == "ar" ? .on : .off, handler: { (_) in
                print("Arabic")
                UserDefaultHelper.language = "ar"
                DispatchQueue.main.async {
                    let userLanguage = UserDefaultHelper.language
                    UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
                    UserDefaultHelper.isLanguageSelected = "yes"
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.restartApp()
                }
            }),
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        selectLanguageTxt.inputView = pickerView
        
        mainTableView.register(ProfileHeaderTVC.nib(), forCellReuseIdentifier: ProfileHeaderTVC.identifier)
        mainTableView.register(ProfileTVC.nib(), forCellReuseIdentifier: ProfileTVC.identifier)
        
        print("UserDefaultHelper.userloginId", UserDefaultHelper.userloginId!)
        
        languageButton.menu = languageMenu
        languageButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProfile()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func languageAction(_ sender: UIButton) {
    }
    
    @IBAction func qrAction(_ sender: UIButton) {
        let popupVC = QRPopUpVC()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.image = SingleTon.sharedSingleTon.generateQRCode(from: "\(UserDefaultHelper.userloginId!)")
        self.present(popupVC, animated: true, completion: nil)
    }
    
    private func getProfile() {
        
        let aParams: [String: Any] = [:]
        
        APIManager.shared.getCallWithParams(APPURL.getProfileDetails, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"].dictionaryValue
            
            let customerData = dataDict["customer"]
            self.profileData = Customer(fromJson: customerData)
            
            print("Customer Data", self.profileData!.phone)
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTVC") as! ProfileHeaderTVC
            
            cell.nameLabel.text = self.profileData?.name ?? ""
            cell.idLabel.text = "\(UserDefaultHelper.mobile ?? "")"
            
            cell.editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC") as! ProfileTVC
            cell.imgBtn.setImage(menuImgs[indexPath.row-1], for: .normal)
            cell.nameLabel.text = menuItems[indexPath.row-1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let orderVC = MyOrderViewController.instantiate()
            self.navigationController?.pushViewController(orderVC, animated: true)
        case 2:
            let manageVC = ManageUsualViewController.instantiate()
            self.navigationController?.pushViewController(manageVC, animated: true)
        case 3:
            let walletVC = WalletVC.instantiate()
            self.navigationController?.pushViewController(walletVC, animated: true)
        case 4:
            let contactVC = ContacUsVC.instantiate()
            self.navigationController?.pushViewController(contactVC, animated: true)
        case 5:
            var aParams: [String: Any]?
            
            if UserDefaultHelper.language == "en" {
                aParams = ["locale": "English---us"]
            } else if UserDefaultHelper.language == "ar" {
                aParams = ["locale": "Arabic---ae"]
            }
            
            APIManager.shared.postCall(APPURL.terms_condition, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let dataDict = responseJSON["response"].dictionaryValue
                
                let detailVC = CommonWebViewController.instantiate()
                detailVC.titleString = dataDict["title"]?.stringValue ?? ""
                detailVC.bodyText = dataDict["body"]?.stringValue ?? ""
                self.navigationController?.modalPresentationStyle = .fullScreen
                self.navigationController?.present(detailVC, animated: true)
                
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
            
        case 6:
            AlertView.show(message: "logout_message".localized(), preferredStyle: .alert, buttons: ["cancel".localized(), "logout".localized(), ]) { (button) in
                if button == "logout".localized() {
                    
                    let aParams: [String: Any] = [:]
                    
                    APIManager.shared.postCall(APPURL.logout, params: aParams, withHeader: true) { responseJSON in
                        print("Response JSON \(responseJSON)")
                        
                        let msg = responseJSON["message"].stringValue
                        print(msg)
                        
                        UserDefaultHelper.deleteCountryCode()
                        UserDefaultHelper.deleteUserLoginId()
                        UserDefaultHelper.deleteUserName()
                        UserDefaultHelper.deleteUserEmail()
                        UserDefaultHelper.deleteMobile()
                        UserDefaultHelper.deleteAuthToken()
                        UserDefaultHelper.deleteTotalItems()
                        UserDefaultHelper.deleteTotalPrice()
                        UserDefaultHelper.deletePaymentKey()
                        UserDefaultHelper.deletePaymentEnv()
                        
                        UserDefaultHelper.deleteHallId()
                        UserDefaultHelper.deleteTableId()
                        UserDefaultHelper.deleteGroupId()
                        UserDefaultHelper.deleteTableName()
                        
                        AlertView.show(message: msg, preferredStyle: .alert, buttons: ["ok".localized()]) { (button) in
                            if button == "ok".localized() {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.afterLogout()
                            }
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
        default:
            return
        }
    }
    
    @objc func editAction() {
        let nextVC = EditProfileVC.instantiate()
        nextVC.nameValue = self.profileData?.name ?? ""
        nextVC.email = self.profileData?.email ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        if row == 0 {
            UserDefaultHelper.language = "en"
            DispatchQueue.main.async {
                let userLanguage = UserDefaultHelper.language
                UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
                UserDefaultHelper.isLanguageSelected = "yes"
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.restartApp()
            }
        } else {
            UserDefaultHelper.language = "ar"
            DispatchQueue.main.async {
                let userLanguage = UserDefaultHelper.language
                UIView.appearance().semanticContentAttribute =  userLanguage == "ar" ? .forceRightToLeft :  .forceLeftToRight
                UserDefaultHelper.isLanguageSelected = "yes"
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.restartApp()
            }
        }
        
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
