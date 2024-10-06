//
//  MealDetailsHeaderCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 03/10/24.
//

import UIKit

class MealDetailsHeaderCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 22)
        }
    }
    
    @IBOutlet var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            descLabel.text = "Fresh beef, tomato, cheddar cheese, lettuce, cocktail sauce, brioche bun."
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    
    static let identifier = "MealDetailsHeaderCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MealDetailsHeaderCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
