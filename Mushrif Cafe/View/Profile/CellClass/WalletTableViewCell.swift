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
        }
    }
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsBoldFontWith(size: 20)
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
