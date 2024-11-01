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
        self.clcHeight.constant = CGFloat(((self.categoryObj.count/3)*146) + ((self.categoryObj.count/3)*10))
        DispatchQueue.main.async {
            self.dataCollection.reloadData()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 54)/3, height: 146)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = categoryObj[indexPath.item]
                
        let categoryVC = CategoryViewController.instantiate()
        categoryVC.categoryId = "\(dict.id ?? 0)"
        categoryVC.categoryName = dict.name
        self.navController.push(viewController: categoryVC)
    }
}
