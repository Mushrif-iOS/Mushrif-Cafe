//
//  MealCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

class MealCVCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
    
    @IBOutlet weak var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 20)
            addButton.setTitle("add".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var addUsualLabel: UILabel! {
        didSet {
            addUsualLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            addUsualLabel.text = "add_usual".localized()
        }
    }
    
    @IBOutlet weak var customizeLabel: UILabel! {
        didSet {
            customizeLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            customizeLabel.text = " "//"Customizable"
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var addUsual: UIButton!
    
    static let identifier = "MealCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MealCVCell", bundle: nil)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
