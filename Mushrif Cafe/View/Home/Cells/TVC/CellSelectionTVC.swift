//
//  CellSelectionTVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 08/10/24.
//

import UIKit

class CellSelectionTVC: UITableViewCell {
    
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
    
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            let attrString = NSMutableAttributedString(string: " \(valuePrice.toRoundedString(toPlaces: 3))",
                                                       attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 17)])
            attrString.append(NSMutableAttributedString(string: " KD",
                                                        attributes: [NSAttributedString.Key.font: UIFont.poppinsLightFontWith(size: 11)]))
            priceLabel.attributedText =  attrString
        }
    }
    
    @IBOutlet var tickButton: UIButton!
    
    var valuePrice: Double = 0.569
    
    static let identifier = "CellSelectionTVC"
    
    static func nib() -> UINib {
        return UINib(nibName: "CellSelectionTVC", bundle: nil)
    }
    
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
