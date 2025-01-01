//
//  SingleSelectionCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 19/11/24.
//

import UIKit

class SingleSelectionCell: UITableViewCell {

    @IBOutlet var titleImg: UIImageView! {
        didSet {
            titleImg.image = UIImage(named: "mainDish")
        }
    }
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            nameLabel.text = ""
        }
    }
    
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            priceLabel.text = ""
        }
    }
    
    @IBOutlet var tickButton: UIButton!
        
    static let identifier = "SingleSelectionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SingleSelectionCell", bundle: nil)
    }
    
//    override var isSelected: Bool {
//        didSet {
//            self.tickButton.isSelected = isSelected ? true : false
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
//        if selected {
//            self.tickButton.isSelected = true
//        } else {
//            self.tickButton.isSelected = false
//        }
    }
}
