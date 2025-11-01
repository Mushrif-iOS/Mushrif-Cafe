//
//  CategoryTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit

class CategoryTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "categories".localized()
        }
    }
    
    @IBOutlet var dataCollection: UICollectionView!
    
    @IBOutlet var clcHeight: NSLayoutConstraint!
    
    var navController: UINavigationController = UINavigationController()
    
    static let identifier = "CategoryTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTVCell", bundle: nil)
    }
    
    var categoryObj: [Category] = [Category]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dataCollection.register(CategoryCVCell.nib(), forCellWithReuseIdentifier: CategoryCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
    }
    
    func reloadCollection() {
        if categoryObj.count >= 3 {
            let fData = (Double(categoryObj.count)/Double(3))*146
            let lData = (Double(categoryObj.count)/Double(3))*10
            self.clcHeight.constant = CGFloat(fData + lData)
        } else {
            self.clcHeight.constant = 146
        }
        self.dataCollection.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CategoryTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVCell.identifier, for: indexPath) as! CategoryCVCell
        
        let dict = categoryObj[indexPath.item]
        
        cell.foodLabel.text = dict.name
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "mainDish"))
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = categoryObj[indexPath.item]
        getSubCategories(id: categoryObj[indexPath.item].id ?? 0, title: dict.name)
    }
    
    private func getSubCategories(id: Int,title: String) {
        var subCategoriesArr : [SubCategory] = [SubCategory]()
        var titles = [ String]()
        var param: [String: Any] = [:]
            if UserDefaultHelper.language == "en" {
                param["category_id"]  = id
                param["locale"]  = "English---us"
            } else if UserDefaultHelper.language == "ar" {
                param["category_id"]  = id
                param["locale"]  = "Arabic---ae"
            }
        print(param)
        APIManager.shared.postCall(APPURL.sub_category, params: param, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]["sub_categories"].arrayValue
            for obj in dataDict {
                let objSub = SubCategory(fromJson: obj)
                subCategoriesArr.append(objSub)
                titles.append(objSub.name)
            }
            let vc = ContentBaseViewController.instantiate()
            vc.strTitle = title
            vc.title = titles.first ?? ""
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.titleNormalFont =  UIFont.poppinsRegularFontWith(size: 14)
            dataSource.titleSelectedFont =  UIFont.poppinsRegularFontWith(size: 14)
            vc.segmentedDataSource = dataSource
            dataSource.titleSelectedColor = .black  // Selected index color
            dataSource.titleNormalColor = .black      // Unselected index color
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.subCategoriesArr = subCategoriesArr
            vc.categoryName = subCategoriesArr.first?.name ?? ""
            vc.categoryId = "\(id)"
            vc.segmentedView.indicators = [indicator]
            self.navController.push(viewController: vc)
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 12 + 12 + (10 * 2) // left + right + 2 gaps between 3 cells
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: 146)
    }
    
    
    
}
