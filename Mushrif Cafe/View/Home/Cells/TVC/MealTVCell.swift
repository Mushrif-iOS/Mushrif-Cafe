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
    
    static let identifier = "MealTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MealTVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(MealCVCell.nib(), forCellWithReuseIdentifier: MealCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
        
        clcHeight.constant = (3 * 255) + (3*13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MealTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCVCell.identifier, for: indexPath) as! MealCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 255)
    }
}

