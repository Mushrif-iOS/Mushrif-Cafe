//
//  AddUsualsVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 07/10/24.
//

import UIKit

class AddUsualsVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "my_usual".localized()
        }
    }
    
    @IBOutlet weak var createBtn: UIButton! {
        didSet {
            createBtn.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            createBtn.setAttributedTitle(NSAttributedString(string: "create_new".localized(), attributes:
                                                                [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
            
            createBtn.addTarget(self, action: #selector(addNewAction), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var usualData: [UsualData] = [UsualData]()
    var pageNo: Int = 1
    var lastPage: Int = Int()
    
    var productId = String()
    var itemType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(UsualListTableViewCell.nib(), forCellReuseIdentifier: UsualListTableViewCell.identifier)
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        
        self.getMyUsual(page: self.pageNo)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if title == "Dashboard" {
            NotificationCenter.default.post(name: Notification.Name("ShowOrders"), object: nil)
        }
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
    
    @objc func addNewAction() {
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
extension AddUsualsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.usualData.count == 0 {
            tableView.setEmptyMessage("no_usuals".localized())
        } else {
            tableView.restore()
        }
        return self.usualData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsualListTableViewCell") as! UsualListTableViewCell
        
        let dict = self.usualData[indexPath.row]
        cell.img.loadURL(urlString: dict.items.first != nil ? dict.items.first?.product.imageUrl : "", placeholderImage: UIImage(named: "appLogo"))
        cell.nameLabel.text = dict.title
        
        let addedTitles = dict.items?.map { group in
            return UserDefaultHelper.language == "ar" ? "\(group.product.nameAr)" :  "\(group.product.name)"
        }.joined(separator: ", ")
        cell.descLabel.text = addedTitles
        cell.txtViewHeight.constant = cell.descLabel.contentSize.height
                
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addAction(sender: )), for: .touchUpInside)
        
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
    
    @objc func addAction(sender: UIButton) {
        
        let dict = self.usualData[sender.tag]
        
        //itemType = "ordered"
        
        var aParams = [String: Any]()
        
        if self.itemType == "listed" {
            aParams = ["group_id": "\(dict.id)", "product_id": "\(self.productId)", "quantity": "1", "item_type": "listed", "order_id": ""]
            print(aParams)
        } else {
            aParams = ["group_id": "\(dict.id)", "product_id": "", "quantity": "1", "item_type": "ordered", "order_id": "\(self.productId)"]
            print(aParams)
        }

        APIManager.shared.postCall(APPURL.add_Item_To_Usual, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let msg = responseJSON["message"].stringValue
            self.showBanner(message: msg, status: .success)
            self.completed()
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension AddUsualsVC: AddMoneyDelegate {
    
    func completed() {
        self.pageNo = 1
        self.usualData.removeAll()
        self.getMyUsual(page: self.pageNo)
    }
}
