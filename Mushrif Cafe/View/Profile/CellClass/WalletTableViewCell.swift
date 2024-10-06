//
//  WalletTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel! {
        didSet {
            numberLabel.font = UIFont.poppinsBoldFontWith(size: 16)
            numberLabel.text = "#122882"
        }
    }
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            dateLabel.text = "23/3/2024"
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            amtLabel.textColor = UIColor.red
            amtLabel.text = "- 1.500 K.D"
        }
    }
    
    static let identifier = "WalletTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WalletTableViewCell", bundle: nil)
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
