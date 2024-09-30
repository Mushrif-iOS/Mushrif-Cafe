//
//  MyUsualTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit

class MyUsualTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "my_usual".localized()
        }
    }
    
    @IBOutlet var dataCollection: UICollectionView!
    
    var colorData: [UIColor] = [UIColor.appPink, UIColor.usualGray, UIColor.appPink, UIColor.usualGray, UIColor.appPink, UIColor.usualGray]
    
    static let identifier = "MyUsualTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyUsualTVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(MyUsualCVCell.nib(), forCellWithReuseIdentifier: MyUsualCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MyUsualTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyUsualCVCell.identifier, for: indexPath) as! MyUsualCVCell
        cell.backView.backgroundColor = colorData[indexPath.item]
        cell.foodLabel.text = "Chicken Shawarma, Pepsi, Fries"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 202, height: 145)
    }
}
