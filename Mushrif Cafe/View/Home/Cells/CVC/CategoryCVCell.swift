//
//  CategoryCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var foodLabel: UILabel! {
        didSet {
            foodLabel.font = UIFont.poppinsMediumFontWith(size: 15)
        }
    }
    
    static let identifier = "CategoryCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryCVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
