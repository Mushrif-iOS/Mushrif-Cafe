//
//  MealTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit
import SwiftyJSON

class MealTVCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "try_out_best".localized()
        }
    }
    
    @IBOutlet var dataCollection: UICollectionView!
    
    @IBOutlet var clcHeight: NSLayoutConstraint!
    
    var navController: UINavigationController?
    
    static let identifier = "MealTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MealTVCell", bundle: nil)
    }
    
    var didChangeItemsBlock : (() -> Void)? = nil
    var didUpdateTableInfo: ((TableInfo) -> Void)?
    
    var mealObj: [TryOurBest] = [TryOurBest]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(MealCVCell.nib(), forCellWithReuseIdentifier: MealCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
    }
    
    func reloadCollection() {
        self.clcHeight.constant = CGFloat(((self.mealObj.count)*255) + ((self.mealObj.count)*13))
        DispatchQueue.main.async {
            self.dataCollection.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MealTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ToastDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCVCell.identifier, for: indexPath) as! MealCVCell
        
        let dict = mealObj[indexPath.item]
        cell.nameLabel.text = dict.name
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "appLogo"))
        
        if dict.specialPrice != "" {
            let doubleValue = Double(dict.specialPrice) ?? 0.0
            cell.priceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 3))"
        } else {
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 3)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 3))"
        }
        
        cell.customizeLabel.text = dict.isCustomizePending == 1 ? "customizable".localized() : ""
        
        cell.descLabel.text = UserDefaultHelper.language == "ar" ? dict.descriptionAr :  dict.descriptionField
        cell.addButton.tag = indexPath.item
        cell.addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        cell.addUsual.tag = indexPath.item
        cell.addUsual.addTarget(self, action: #selector(addUsualAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 255)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = mealObj[indexPath.item]
        
        if dict.productType == 5 {
            let detailVC = SpecialProductVC.instantiate()
            self.navController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id ?? 0)"
            detailVC.delegate = self
            self.navController?.present(detailVC, animated: true)
        } else {
            let detailVC = MealDetailsViewController.instantiate()
            self.navController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id ?? 0)"
            detailVC.delegate = self
            self.navController?.present(detailVC, animated: true)
        }
    }
    
    @objc func addAction(sender: UIButton) {
        
        let dict = mealObj[sender.tag]
        
        if UserDefaultHelper.authToken != "" {
            let orderType = UserDefaultHelper.orderType ?? ""
            let hallId = UserDefaultHelper.hallId ?? ""
            let tableId = UserDefaultHelper.tableId ?? ""
            let groupId = UserDefaultHelper.groupId ?? ""
            
            if dict.productType == 5 {
                let detailVC = SpecialProductVC.instantiate()
                self.navController?.modalPresentationStyle = .formSheet
                detailVC.itemId = "\(dict.id ?? 0)"
                detailVC.delegate = self
                self.navController?.present(detailVC, animated: true)
            } else if dict.isCustomizePending == 1 {
                let detailVC = MealDetailsViewController.instantiate()
                self.navController?.modalPresentationStyle = .formSheet
                detailVC.itemId = "\(dict.id ?? 0)"
                detailVC.delegate = self
                self.navController?.present(detailVC, animated: true)
            }  else {
                if tableId != "" {
                    let aParams = ["hall_id": hallId,
                                   "table_id": tableId,
                                   "group_id": groupId,
                                   "order_type": orderType,
                                   "item_id": "\(dict.id ?? 0)",
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
                            self.navController?.showBanner(message: msg, status: .success)
                            UserDefaultHelper.totalItems = (UserDefaultHelper.totalItems ?? 0) + 1
                            self.didChangeItemsBlock?()
                            
                            guard let responseDict = responseJSON["response"].dictionary else {
                                print("Invalid response format")
                                return
                            }
                            if let tableDict = responseDict["table"]?.dictionary {
                                let tableInfo = TableInfo(fromJson: JSON(tableDict))
                                self.didUpdateTableInfo?(tableInfo)
                            }
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                } else {
                    self.navController?.showBanner(message: "please_scan".localized(), status: .warning)
                    let scanVC = ScanTableVC.instantiate()
                    scanVC.title = "LanguageSelection"
                    self.navController?.push(viewController: scanVC)
                }
            }
        } else {
            let profileVC = LoginVC.instantiate()
            self.navController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc func addUsualAction(sender: UIButton) {
        
        let dict = mealObj[sender.tag]
        
//        var diubleValue = Double()
//        if dict.specialPrice != "" {
//            diubleValue = Double(dict.specialPrice) ?? 0.0
//        } else {
//            diubleValue = Double(dict.price) ?? 0.0
//        }
//        if diubleValue <= 0.0 {
//            self.navController?.showBanner(message: "no_cost_Usual".localized(), status: .failed)
//            return
//        }
        
        if dict.productType == 4 {
            self.navController?.showBanner(message: "cant_add_usual".localized(), status: .failed)
            return
        }
        
        if UserDefaultHelper.authToken != "" {
//            if let cell = self.dataCollection.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? MealCVCell {
//                cell.saveButton.isSelected.toggle()
//            }
            let addVC = AddUsualsVC.instantiate()
//            if #available(iOS 15.0, *) {
//                if let sheet = addVC.sheetPresentationController {
//                    sheet.detents = [.large()]
//                    sheet.preferredCornerRadius = 15
//                }
//            }
            addVC.productId = "\(dict.id ?? 0)"
            addVC.itemType = "listed"
            addVC.title = "Dashboard"
            self.navController?.present(addVC, animated: true, completion: nil)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func dismissed() {
//        if UserDefaultHelper.authToken != "" {
//            let cartVC = CartVC.instantiate()
//            self.navController?.pushViewController(cartVC, animated: true)
//        } else {
//            let profileVC = LoginVC.instantiate()
//            self.navController?.pushViewController(profileVC, animated: true)
//        }
        UserDefaultHelper.totalItems = (UserDefaultHelper.totalItems ?? 0) + 1
        self.didChangeItemsBlock?()
        NotificationCenter.default.post(name: Notification.Name("RefreshTableInfo"), object: nil)
    }
}

