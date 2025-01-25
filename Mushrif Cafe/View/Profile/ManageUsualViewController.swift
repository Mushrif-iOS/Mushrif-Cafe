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
    
    /*lazy var footerButton: UIButton! = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.primaryBrown
        button.setTitleColor(UIColor.white, for: .normal)
        button.borderColor = UIColor.borderPink
        button.borderWidth = 1
        button.cornerRadius = 30
        button.addTarget(self, action: #selector(didAddTaped), for: .touchUpInside)
        button.setTitle("add_new".localized(), for: .normal)
        button.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
        return button
    }()*/
    
    var usualData: [UsualData] = [UsualData]()
    var pageNo: Int = 1
    var lastPage: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainTableView.register(MyUsualHeaderCell.nib(), forCellReuseIdentifier: MyUsualHeaderCell.identifier)
        mainTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.usualData.count == 0 {
            tableView.setEmptyMessage("no_usuals".localized())
        } else {
            tableView.restore()
        }
        return self.usualData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usualData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        cell.isCart = "N"
        cell.didRemoveBlock = {
            self.pageNo = 1
            self.usualData.removeAll()
            self.getMyUsual(page: self.pageNo)
        }
        let dict = self.usualData[indexPath.section].items[indexPath.row]
        cell.itemId = "\(dict.id)"
        cell.qtyValue = dict.quantity
        cell.nameLabel.text = dict.product.name
        cell.editButton.isHidden = true
        if dict.product.specialPrice != "" {
            let doubleValue = Double(dict.product.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
            cell.otherPriceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        } else {
            let doubleValue = Double(dict.product.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
            cell.otherPriceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        }
        cell.descLabel.text = dict.product.descriptionField
        cell.qty.text = "\(dict.quantity)"
        
        if self.usualData[indexPath.section].items.count == 1 {
            cell.backView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 18)
        } else {
            if indexPath.row == 0 {
                cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
            } else if indexPath.row == self.usualData[indexPath.section].items.count - 1 {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
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
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let dict = self.usualData[section]
        let headerView = tableView.dequeueReusableCell(withIdentifier: MyUsualHeaderCell.identifier) as! MyUsualHeaderCell
        headerView.headerTitle.text = "\(dict.title)"
        
        headerView.editButton.tag = section
        headerView.editButton.addTarget(self, action: #selector(updateAction(sender: )), for: .touchUpInside)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
}

extension ManageUsualViewController: AddMoneyDelegate {
    
    func completed() {
        self.pageNo = 1
        self.usualData.removeAll()
        self.getMyUsual(page: self.pageNo)
    }
}
