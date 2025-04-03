//
//  MyUsualDetailVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 31/03/25.
//

import UIKit

class MyUsualDetailVC: UIViewController, Instantiatable {
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
            addNewBtn.isHidden = true
        }
    }
    
    var usualId = Int()
    var usualData: UsualDetailsRootClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainTableView.register(MyUsualHeaderCell.nib(), forCellReuseIdentifier: MyUsualHeaderCell.identifier)
        mainTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMyUsualDetail()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getMyUsualDetail() {
        
        let aParams: [String: Any] = [:]
        
        let userLanguage = UserDefaultHelper.language
        let dUrl = APPURL.my_usuals_details + "\(self.usualId)" + "?locale=\(userLanguage == "ar" ? "Arabic---ae" :  "English---us")"
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"]
            
            self.usualData = UsualDetailsRootClass(fromJson: dataDict)
                        
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
                
                if self.usualData?.items.count ?? 0 == 0 {
                    self.showBanner(message: "no_product".localized(), status: .warning)
                }
            }
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    @IBAction func addNewAction(_ sender: Any) {
    }
}

extension MyUsualDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usualData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        cell.isCart = "N"
        cell.didRemoveBlock = {
            self.getMyUsualDetail()
        }
        let dict = self.usualData?.items[indexPath.row]
        cell.itemId = "\(dict?.id ?? 0)"
        cell.qtyValue = dict?.quantity ?? 0
        cell.nameLabel.text = dict?.product.name
        cell.editButton.isHidden = true
        if dict?.product.specialPrice != "" {
            let doubleValue = Double(dict?.product.specialPrice ?? "") ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
            cell.otherPriceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        } else {
            let doubleValue = Double(dict?.product.price ?? "") ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
            cell.otherPriceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KWD"
        }
        if dict?.ingredientsList?.count ?? 0 > 0 {
            let addedTitles = dict?.ingredientsList?.map { group in
                return group.isAdded == 1 ? "\("add".localized()) \(group.title)" : "\("remove".localized()) \(group.title)"
            }.joined(separator: "\n")
            cell.descLabel.text = addedTitles
        } else {
            cell.descLabel.text = dict?.product.productDesc
        }
        cell.qty.text = "\(dict?.quantity ?? 0)"
        
//        if self.usualData?.items.count == 1 {
//            cell.backView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 18)
//        } else {
//            if indexPath.row == 0 {
//                cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
//            } else if indexPath.row == (self.usualData?.items.count ?? 0) - 1 {
//                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
//            }
//        }
        
        DispatchQueue.main.async {
            if self.usualData?.items.count == 1 {
                cell.backView.roundCorners(corners: .allCorners, radius: 18)
            } else {
                if indexPath.row == 0 {
                    cell.backView.layer.cornerRadius = 18
                    cell.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } else if indexPath.row == (self.usualData?.items.count ?? 0) - 1 {
                    cell.backView.layer.cornerRadius = 18
                    cell.backView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                } else {
                    cell.backView.roundCorners(corners: .allCorners, radius: 0)
                }
            }
        }
        
        cell.editButton.isHidden = false
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editButtonAction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let dict = self.usualData
        let headerView = tableView.dequeueReusableCell(withIdentifier: MyUsualHeaderCell.identifier) as! MyUsualHeaderCell
        headerView.headerTitle.text = "\(dict?.title ?? "")"
        
        headerView.editButton.tag = section
        //headerView.editButton.addTarget(self, action: #selector(updateAction(sender: )), for: .touchUpInside)
        headerView.editButton.isHidden = true
        
        headerView.addButton.tag = section
        headerView.addButton.addTarget(self, action: #selector(addCartAction(sender: )), for: .touchUpInside)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func addCartAction(sender: UIButton) {
                
        let hallId = UserDefaultHelper.hallId ?? ""
        let tableId = UserDefaultHelper.tableId ?? ""
        let groupId = UserDefaultHelper.groupId ?? ""
        
        if tableId != "" {
            
            let aParams = ["usual_id": "\(self.usualData?.id ?? 0)",
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
    
    @objc func editButtonAction(sender: UIButton) {
        
        let dict = self.usualData?.items[sender.tag]
        
        if dict?.productType == 5 {
            let editVC = EditSpecialMyUsualVC.instantiate()
            editVC.usualCartDetails = dict
            self.navigationController?.pushViewController(editVC, animated: true)
        } else {
            let editVC = EditMyUsualVC.instantiate()
            editVC.cartDetails = dict
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
}
