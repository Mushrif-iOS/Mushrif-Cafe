//
//  ManageListTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/04/25.
//

import UIKit

class ManageListTableViewCell: UITableViewCell {
    
    @IBOutlet var headerTitle: UILabel! {
        didSet {
            headerTitle.textColor = UIColor.black
            headerTitle.font = UIFont.poppinsMediumFontWith(size: 20)
            headerTitle.numberOfLines = 0
        }
    }
    
    @IBOutlet var editButton: UIButton! {
        didSet {
            editButton.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 14)
            editButton.setTitle("edit".localized(), for: .normal)
        }
    }
    @IBOutlet var arrowButton: UIButton! {
        didSet {
            arrowButton.setImage(UserDefaultHelper.language == "ar" ? UIImage(systemName: "chevron.left") :  UIImage(systemName: "chevron.right"), for: .normal)
        }
    }
        
    static let identifier = "ManageListTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ManageListTableViewCell", bundle: nil)
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
