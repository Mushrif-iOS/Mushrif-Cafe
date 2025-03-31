//
//  UsualListTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 07/10/24.
//

import UIKit

class UsualListTableViewCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
    
    @IBOutlet var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    @IBOutlet var txtViewHeight: NSLayoutConstraint!
    
    @IBOutlet var addButton: UIButton!
    
    static let identifier = "UsualListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "UsualListTableViewCell", bundle: nil)
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
