//
//  CoiceHeaderTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 27/11/24.
//

import UIKit

class ChoiceHeaderTVCell: UITableViewCell {
    
    @IBOutlet var backView: UIView! {
        didSet {
            backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
        }
    }
    @IBOutlet var typeOfMealLabel: UILabel! {
        didSet {
            typeOfMealLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    @IBOutlet var requiredLabel: UILabel! {
        didSet {
            requiredLabel.font = UIFont.poppinsMediumFontWith(size: 13)
        }
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
