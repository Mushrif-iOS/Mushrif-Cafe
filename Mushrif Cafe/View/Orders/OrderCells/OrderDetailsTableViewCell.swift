//
//  OrderDetailsTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/10/24.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.poppinsBoldFontWith(size: 14)
        }
    }
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.font = UIFont.poppinsRegularFontWith(size: 14)
        }
    }
    @IBOutlet weak var instructionLabel: UILabel! {
        didSet {
            instructionLabel.font = UIFont.poppinsMediumFontWith(size: 12)
            instructionLabel.textColor = UIColor.black
            instructionLabel.numberOfLines = 3
            instructionLabel.lineBreakMode = .byTruncatingTail
        }
    }
    
    @IBOutlet weak var qtyLabel: UILabel! {
        didSet {
            qtyLabel.font = UIFont.poppinsMediumFontWith(size: 18)
            qtyLabel.textAlignment = UserDefaultHelper.language == "en" ? .right : .left
            //qtyLabel.text = "x1"
        }
    }
    
    @IBOutlet weak var otherPriceLabel: UILabel! {
        didSet {
            otherPriceLabel.font = UIFont.poppinsBoldFontWith(size: 16)
        }
    }
    
    static let identifier = "OrderDetailsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "OrderDetailsTableViewCell", bundle: nil)
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
