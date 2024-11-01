//
//  MyUsualHeaderCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/10/24.
//

import UIKit

class MyUsualHeaderCell: UITableViewCell {
    
    @IBOutlet var headerTitle: UILabel! {
        didSet {
            headerTitle.textColor = UIColor.black
            headerTitle.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
        
    static let identifier = "MyUsualHeaderCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyUsualHeaderCell", bundle: nil)
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
