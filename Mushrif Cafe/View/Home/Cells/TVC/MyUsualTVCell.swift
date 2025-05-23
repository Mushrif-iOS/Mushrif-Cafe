//
//  MyUsualTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit
import SwiftyJSON

class MyUsualTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "my_usual".localized()
        }
    }
    
    @IBOutlet var dataCollection: UICollectionView!
    
    var navController: UINavigationController?
    
    var usualObj = [DashboardMyUsual]()
    var didUpdateTableInfo: ((TableInfo) -> Void)?
    
    static let identifier = "MyUsualTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyUsualTVCell", bundle: nil)
    }
    
    var didChangeItemsBlock : (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(MyUsualCVCell.nib(), forCellWithReuseIdentifier: MyUsualCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {
            self.dataCollection.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MyUsualTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usualObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyUsualCVCell.identifier, for: indexPath) as! MyUsualCVCell
        let dict = usualObj[indexPath.item]
        cell.foodLabel.text = dict.title
        
        if (indexPath.item % 2 == 0) {
            cell.backView.backgroundColor = UIColor.appPink
        } else {
            cell.backView.backgroundColor = UIColor.usualGray
        }
        
        cell.addButton.tag = indexPath.item
        cell.addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 202, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.usualObj[indexPath.item]
        let manageVC = MyUsualDetailVC.instantiate()
        manageVC.usualId = dict.id
        self.navController?.pushViewController(manageVC, animated: true)
    }
    
    @objc func addAction(sender: UIButton) {
        
        let dict = usualObj[sender.tag]
        if UserDefaultHelper.authToken != "" {
            
            let hallId = UserDefaultHelper.hallId ?? ""
            let tableId = UserDefaultHelper.tableId ?? ""
            let groupId = UserDefaultHelper.groupId ?? ""
            
            if tableId != "" {
                
                let aParams = ["usual_id": "\(dict.id)",
                               "hall_id": hallId,
                               "table_id": tableId,
                               "group_id": groupId,
                               "order_type": "dinein",
                               "locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"
                ]
                print(aParams)
                
                APIManager.shared.postCall(APPURL.usuals_move_to_cart, params: aParams, withHeader: true) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    
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
        } else {
            let profileVC = LoginVC.instantiate()
            self.navController?.pushViewController(profileVC, animated: true)
        }
    }
}
