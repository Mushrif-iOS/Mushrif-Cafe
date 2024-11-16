//
//  MealTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

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

extension MealTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCVCell.identifier, for: indexPath) as! MealCVCell
        
        let dict = mealObj[indexPath.item]
        cell.nameLabel.text = dict.name
        cell.img.loadURL(urlString: dict.image, placeholderImage: UIImage(named: "pizza"))
        
        if dict.specialPrice != "" {
            let doubleValue = Double(dict.specialPrice) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        } else {
            let doubleValue = Double(dict.price) ?? 0.0
            cell.priceLabel.text = "\(doubleValue.rounded(toPlaces: 2)) KD"
        }
        
        cell.descLabel.text = dict.descriptionField
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 255)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = mealObj[indexPath.item]
        let detailVC = MealDetailsViewController.instantiate()
        self.navController?.modalPresentationStyle = .formSheet
        detailVC.itemId = "\(dict.id ?? 0)"
        detailVC.descString = dict.descriptionField
        self.navController?.present(detailVC, animated: true)
    }
}

