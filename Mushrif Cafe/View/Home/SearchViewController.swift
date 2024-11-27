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
        sbSearchBar.textField?.textColor = UIColor.black
        sbSearchBar.setLeftImage(UIImage(systemName: "magnifyingglass")!, tintColor: UIColor.primaryBrown)
        sbSearchBar.delegate = self
        
        self.mainClcView.isHidden = true
        self.mainClcView.register(SearchCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        self.mainClcView.isScrollEnabled = true
        self.mainClcView.isUserInteractionEnabled = true
        self.mainClcView.alwaysBounceVertical = true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
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
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "pizza"))
        
        if dict.specialPrice != "" {
            let doubleValue = Double(dict.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        } else {
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 15, height: 120)
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
//        let detailVC = MealDetailsViewController.instantiate()
//        self.navigationController?.modalPresentationStyle = .formSheet
//        self.navigationController?.present(detailVC, animated: true)
        
        let dict = self.searchData[indexPath.item]
        let detailVC = MealDetailsViewController.instantiate()
        self.navigationController?.modalPresentationStyle = .formSheet
        detailVC.itemId = "\(dict.id)"
        detailVC.descString = dict.name
        self.navigationController?.present(detailVC, animated: true)
    }
}
