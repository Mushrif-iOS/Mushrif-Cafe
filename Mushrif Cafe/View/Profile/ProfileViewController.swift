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
    
    var menuItems = ["my_orders".localized(), "manage".localized(), "wallets".localized(), "contact_us".localized(), "terms_and_conditions".localized(), "logout".localized()]
    var menuImgs = [UIImage(named: "plate-utensils"), UIImage(named: "saved"), UIImage(named: "wallet"), UIImage(named: "headset"), UIImage(named: "document"), UIImage(named: "leave")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        selectLanguageTxt.inputView = pickerView
        
        mainTableView.register(ProfileHeaderTVC.nib(), forCellReuseIdentifier: ProfileHeaderTVC.identifier)
        mainTableView.register(ProfileTVC.nib(), forCellReuseIdentifier: ProfileTVC.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func languageAction(_ sender: Any) {
        
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTVC") as! ProfileHeaderTVC
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
            self.showWebView("http://www.youtube.com")
        case 6:
            AlertView.show(message: "logout_message".localized(), preferredStyle: .alert, buttons: ["logout".localized(), "cancel".localized()]) { (button) in
                if button == "logout".localized() {
                    print("Done")
                }
            }
        default:
            return
        }
    }
    
    @objc func editAction() {
        let nextVC = EditProfileVC.instantiate()
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
