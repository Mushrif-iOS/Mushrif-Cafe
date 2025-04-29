//
//  ChoiceRowTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 27/11/24.
//

import UIKit

class ChoiceRowTVCell: UITableViewCell {
    
    @IBOutlet var backView: UIView!

    @IBOutlet var titleImg: UIImageView!
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var tickButton: UIButton! {
        didSet {
            tickButton.setImage(UIImage(named: "unchecked"), for: .normal)
            tickButton.setImage(UIImage(named: "checkbox"), for: .selected)
            tickButton.isUserInteractionEnabled = false
        }
    }
    
    var callBackTap: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postTap(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.delegate = self
//        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func postTap(_ sender: UIGestureRecognizer) {
        self.callBackTap?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with choice: Choice, isSelected: Bool) {
        nameLabel.text = UserDefaultHelper.language == "ar" ? "\(choice.choiceAr)" : "\(choice.choice)"
        let doubleValue = Double(choice.choicePrice) ?? 0.0
        if doubleValue == 0.0 {
            self.priceLabel.isHidden = true
            self.priceLabel.text = ""
        } else {
            self.priceLabel.isHidden = false
            self.priceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 2)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 2))"
        }
        tickButton.isSelected = isSelected
    }
}
