//
//  ProfileHeaderTVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 04/10/24.
//

import UIKit

class ProfileHeaderTVC: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    @IBOutlet var idLabel: UILabel! {
        didSet {
            idLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var editLabel: UILabel! {
        didSet {
            editLabel.font = UIFont.poppinsRegularFontWith(size: 14)
            editLabel.text = "edit".localized()
        }
    }
    
    static let identifier = "ProfileHeaderTVC"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileHeaderTVC", bundle: nil)
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
