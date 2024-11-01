//
//  CategoryViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/10/24.
//

import UIKit

class CategoryViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var subCategoriesArr : [SubCategory] = [SubCategory]()
    var foodItemArr : [FoodItemData] = [FoodItemData]()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    var categoryId = String()
    var categoryName = String()
    
    var pageNo: Int = 1
    var lastPage: Int = Int()
    var subCategoryId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = self.categoryName
        
        mainTableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 6.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.mainCollectionView.collectionViewLayout = layout
        
        totalLabel.text = "1 Item added - \(3.400) KD"
        
        self.getSubCategories()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.mainCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
        bottomView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.applyGradient(isVertical: true, colorArray: [UIColor.primaryBrown, UIColor.borderPink])
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let dashboardVC = SearchViewController.instantiate()
        self.navigationController?.push(viewController: dashboardVC)
    }
    
    @IBAction func goToNextAction(_ sender: Any) {
        let cartVC = CartVC.instantiate()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    private func getSubCategories() {
        
        let aParams: [String: Any] = ["category_id": "\(self.categoryId)"]
        
        print(aParams)
        
        APIManager.shared.postCall(APPURL.sub_category, params: aParams, withHeader: false) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"]["sub_categories"].arrayValue
            
            for obj in dataDict {
                self.subCategoriesArr.append(SubCategory(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.subTitleLabel.text = self.subCategoriesArr.first?.name
                self.mainCollectionView.reloadData()
            }
            
            self.getProductList(subCatId: "\(self.subCategoriesArr.first?.id ?? 0)", page: self.pageNo)
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func getProductList(subCatId: String, page: Int) {
        
        let aParams: [String: Any] = ["category_id": "\(self.categoryId)", "sub_category_id": "\(subCatId)"]
        
        print(aParams)
        
        APIManager.shared.postCall(APPURL.food_item_list + "?page=\(page)", params: aParams, withHeader: false) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let lPage = responseJSON["response"]["last_page"].intValue
            self.lastPage = lPage
            
            let itemDataDict = responseJSON["response"]["data"].arrayValue
            
            for obj in itemDataDict {
                self.foodItemArr.append(FoodItemData(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subCategoriesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVCell", for: indexPath) as! TagsCVCell
        cell.textLabel.text = self.subCategoriesArr[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = self.subCategoriesArr[indexPath.item]
        self.subTitleLabel.text = dict.name
        
        self.subCategoryId = "\(dict.id)"
        self.foodItemArr.removeAll()
        self.getProductList(subCatId: "\(dict.id)", page: self.pageNo)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.foodItemArr.count == 0 {
            tableView.setEmptyMessage("no_product".localized())
        } else {
            tableView.restore()
        }
        return self.foodItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.addUsual.tag = indexPath.row
        cell.addUsual.addTarget(self, action: #selector(addUsual(sender:)), for: .touchUpInside)
        
        let dict = self.foodItemArr[indexPath.row]
        cell.nameLabel.text = dict.name
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "pizza"))
        
        if dict.specialPrice != "" {
            let doubleValue = Double(dict.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        } else {
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        }
        
        cell.descLabel.text = dict.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if self.pageNo < self.lastPage && indexPath.item == (self.foodItemArr.count) - 1 {
            
            if(pageNo < self.lastPage) {
                
                print("Last Page: ", self.lastPage)
                
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(50))
                spinner.startAnimating()
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
                
                self.pageNo += 1
                print("Last ID: ", self.pageNo)
                
                self.getProductList(subCatId: self.subCategoryId, page: self.pageNo)
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
    
    @objc func addUsual(sender: UIButton) {
        let addVC = AddUsualsVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        self.present(addVC, animated: true, completion: nil)
    }
}
