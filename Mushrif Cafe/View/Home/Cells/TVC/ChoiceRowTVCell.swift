//
//  ChoiceRowTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 27/11/24.
//

import UIKit

class ChoiceRowTVCell: UITableViewCell {
    
    @IBOutlet var backView: UIView!

    @IBOutlet var titleImg: UIImageView! {
        didSet {
            titleImg.image = UIImage(named: "mainDish")
        }
    }
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var tickButton: UIButton!
    
    var callBackTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func postTap(_ sender: UIGestureRecognizer) {
        self.callBackTap?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
