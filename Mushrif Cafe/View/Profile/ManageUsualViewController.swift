//
//  ManageUsualViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit

class ManageUsualViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "manage_usual".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var addNewBtn: UIButton! {
        didSet {
            addNewBtn.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 15)
            addNewBtn.setTitle("add_new".localized(), for: .normal)
        }
    }

    var usualData: [UsualData] = [UsualData]()
    var pageNo: Int = 1
    var lastPage: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainTableView.register(ManageListTableViewCell.nib(), forCellReuseIdentifier: ManageListTableViewCell.identifier)
       // mainTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        self.getMyUsual(page: self.pageNo)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getMyUsual(page: Int) {
        
        let aParams: [String: Any] = [:]
        
        let userLanguage = UserDefaultHelper.language
        let dUrl = APPURL.my_usuals + "?locale=\(userLanguage == "ar" ? "Arabic---ae" :  "English---us")" + "&page=\(page)"
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let lPage = responseJSON["response"]["last_page"].intValue
            self.lastPage = lPage
            
            let searchDataDict = responseJSON["response"]["data"].arrayValue
            
            for obj in searchDataDict {
                self.usualData.append(UsualData(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
            }
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    @IBAction func addNewAction(_ sender: Any) {
        let addVC = CreateNewUsualVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.delegate = self
        addVC.title = ""
        self.present(addVC, animated: true, completion: nil)
    }
}

extension ManageUsualViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.usualData.count == 0 {
            tableView.setEmptyMessage("no_usuals".localized())
        } else {
            tableView.restore()
        }
        return self.usualData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageListTableViewCell") as! ManageListTableViewCell
        let dict = self.usualData[indexPath.row]
        cell.headerTitle.text = dict.title
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(updateAction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.usualData[indexPath.row]
        let manageVC = MyUsualDetailVC.instantiate()
        manageVC.usualId = dict.id
        manageVC.delegate = self
        self.navigationController?.pushViewController(manageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.pageNo < self.lastPage && indexPath.item == (self.usualData.count) - 1 {
            
            if(pageNo < self.lastPage) {
                
                print("Last Page: ", self.lastPage)
                
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(30))
                spinner.startAnimating()
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
                
                self.pageNo += 1
                print("Last ID: ", self.pageNo)
                
                self.getMyUsual(page: self.pageNo)
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

    @objc func updateAction(sender: UIButton) {
        
        let dict = self.usualData[sender.tag]
        
        let addVC = CreateNewUsualVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.title = "Update"
        addVC.myUsual = dict
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
    
    
    @objc func addAction(sender: UIButton) {
        
        let dict = self.usualData[sender.tag]
        
        let hallId = UserDefaultHelper.hallId ?? ""
        let tableId = UserDefaultHelper.tableId ?? ""
        let groupId = UserDefaultHelper.groupId ?? ""
        
        if tableId != "" {
            
            let aParams = ["usual_id": "\(dict.id)",
                           "hall_id": hallId,
                           "table_id": tableId,
                           "group_id": groupId]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.usuals_move_to_cart, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let msg = responseJSON["message"].stringValue
                self.showBanner(message: msg, status: .success)
                
                let cartVC = CartVC.instantiate()
                self.navigationController?.pushViewController(cartVC, animated: true)
                
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        } else {
            self.showBanner(message: "please_scan".localized(), status: .warning)
            let scanVC = ScanTableVC.instantiate()
            scanVC.title = "LanguageSelection"
            self.navigationController?.push(viewController: scanVC)
        }
        
    }
}

extension ManageUsualViewController: AddMoneyDelegate {
    
    func completed() {
        self.pageNo = 1
        self.usualData.removeAll()
        self.getMyUsual(page: self.pageNo)
    }
}
