//
//  SearchViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/10/24.
//

import UIKit

class SearchViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet weak var sbSearchBar: UISearchBar!
    @IBOutlet weak var mainClcView: UICollectionView!
    
    var searchString: String = ""
    
    var searchData: [SearchData] = [SearchData]()
    
    var pageNo: Int = 1
    var lastPage: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        sbSearchBar.placeholder = "search_product".localized()
        sbSearchBar.textField?.font = UIFont.poppinsRegularFontWith(size: 14)
        sbSearchBar.textField?.attributedPlaceholder = NSAttributedString(
            string: "search_product".localized(),
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.6),
                .font: UIFont.poppinsRegularFontWith(size: 14)
            ]
        )
        sbSearchBar.textField?.textColor = UIColor.black
        sbSearchBar.textField?.clearButtonMode = .never
        sbSearchBar.setLeftImage(UIImage(systemName: "magnifyingglass")!, tintColor: UIColor.primaryBrown)
        sbSearchBar.delegate = self
        
        self.mainClcView.isHidden = true
        self.mainClcView.register(SearchCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        self.mainClcView.isScrollEnabled = true
        self.mainClcView.isUserInteractionEnabled = true
        self.mainClcView.alwaysBounceVertical = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("OrderView"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        let orderVC = MyOrderViewController.instantiate()
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate, ToastDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.searchTextField.text ?? ""
        self.searchData.removeAll()
        self.pageNo = 1
        self.searchApi(searchText: searchString, page: self.pageNo)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count) > 2 {
            searchString = searchText
            self.searchData.removeAll()
            self.pageNo = 1
            self.searchApi(searchText: searchString, page: self.pageNo)
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if searchBar.searchTextField.isFirstResponder {
            let validString = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?=\\¥'£•¢€")
            if (searchBar.textField?.textInputMode?.primaryLanguage == "emoji") || searchBar.textField?.textInputMode?.primaryLanguage == nil {
                return false
            }
            if let range = text.rangeOfCharacter(from: validString) {
                print(range)
                return false
            }
        }
        return true
    }
    
    func searchApi(searchText: String, page: Int) {
        
        var aParams: [String: Any]?
        
        if UserDefaultHelper.language == "en" {
            aParams = ["search_term": searchText, "locale": "English---us"]
        } else if UserDefaultHelper.language == "ar" {
            aParams = ["search_term": searchText, "locale": "Arabic---ae"]
        }
        print(aParams!)
        
        APIManager.shared.postCall(APPURL.search_product + "?page=\(page)", params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let lPage = responseJSON["response"]["last_page"].intValue
            self.lastPage = lPage
            
            let searchDataDict = responseJSON["response"]["data"].arrayValue
            
            for obj in searchDataDict {
                self.searchData.append(SearchData(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.mainClcView.isHidden = false
                self.mainClcView.delegate = self
                self.mainClcView.dataSource = self
                self.mainClcView.reloadData()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchData.count == 0 {
            collectionView.setEmptyMessage("no_product".localized())
        } else {
            collectionView.restore()
        }
        return self.searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        let dict = self.searchData[indexPath.item]
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
        
        cell.addButton.tag = indexPath.item
        cell.addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        cell.addUsual.tag = indexPath.item
        cell.addUsual.addTarget(self, action: #selector(addUsualAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 15, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.pageNo < self.lastPage && indexPath.item == (self.searchData.count) - 1 {
            
            self.pageNo += 1
            print("Current Page = \(self.pageNo)")
            print("Last = \(self.lastPage)")
            
            self.searchApi(searchText: self.searchString, page: self.pageNo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.searchData[indexPath.item]
        if dict.productType == 5 {
            let detailVC = SpecialProductVC.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        } else {
            let detailVC = MealDetailsViewController.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        }
    }
    
    @objc func addUsualAction(sender: UIButton) {
        
        let dict = self.searchData[sender.tag]
//        var diubleValue = Double()
//        if dict.specialPrice != "" {
//            diubleValue = Double(dict.specialPrice) ?? 0.0
//        } else {
//            diubleValue = Double(dict.price) ?? 0.0
//        }
//        if diubleValue <= 0.0 {
//            self.showBanner(message: "no_cost_Usual".localized(), status: .failed)
//            return
//        }
        
        if dict.productType == 4 {
            self.showBanner(message: "cant_add_usual".localized(), status: .failed)
            return
        }
        
        if UserDefaultHelper.authToken != "" {
            let addVC = AddUsualsVC.instantiate()
//            if #available(iOS 15.0, *) {
//                if let sheet = addVC.sheetPresentationController {
//                    sheet.detents = [.medium()]
//                    sheet.preferredCornerRadius = 15
//                }
//            }
            addVC.productId = "\(dict.id)"
            addVC.itemType = "listed"
            self.navigationController?.present(addVC, animated: true, completion: nil)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc func addAction(sender: UIButton) {
        
        let dict = self.searchData[sender.tag]
        
        if dict.productType == 5 {
            let detailVC = SpecialProductVC.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        } else if dict.isCustomizePending == 1 {
            let detailVC = MealDetailsViewController.instantiate()
            self.navigationController?.modalPresentationStyle = .formSheet
            detailVC.itemId = "\(dict.id)"
            detailVC.delegate = self
            self.navigationController?.present(detailVC, animated: true)
        } else {
            
            if UserDefaultHelper.authToken != "" {
                let orderType = UserDefaultHelper.orderType ?? ""
                let hallId = UserDefaultHelper.hallId ?? ""
                let tableId = UserDefaultHelper.tableId ?? ""
                let groupId = UserDefaultHelper.groupId ?? ""
                
                if tableId != "" {
                    let aParams = ["hall_id": hallId,
                                   "table_id": tableId,
                                   "group_id": groupId,
                                   "order_type": orderType,
                                   "item_id": "\(dict.id)",
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
                            self.showBanner(message: msg, status: .success)
                        }
                    } failure: { error in
                        print("Error \(error.localizedDescription)")
                    }
                } else {
                    self.showBanner(message: "please_scan".localized(), status: .warning)
                    let scanVC = ScanTableVC.instantiate()
                    scanVC.title = "LanguageSelection"
                    self.navigationController?.push(viewController: scanVC)
                }
            } else {
                let profileVC = LoginVC.instantiate()
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    func dismissed() {
//        if UserDefaultHelper.authToken != "" {
//            let cartVC = CartVC.instantiate()
//            self.navigationController?.pushViewController(cartVC, animated: true)
//        } else {
//            let profileVC = LoginVC.instantiate()
//            self.navigationController?.pushViewController(profileVC, animated: true)
//        }
    }
}
