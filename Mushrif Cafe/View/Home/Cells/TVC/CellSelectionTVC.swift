//
//  CellSelectionTVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 08/10/24.
//

import UIKit

class CellSelectionTVC: UITableViewCell {
    
    @IBOutlet var titleImg: UIImageView! 
    
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
    
    @IBOutlet var tickButton: UIButton! {
        didSet {
//            tickButton.setImage(UIImage(named: "unchecked"), for: .normal)
//            tickButton.setImage(UIImage(named: "checkbox"), for: .selected)
            tickButton.isUserInteractionEnabled = false
        }
    }
        
    static let identifier = "CellSelectionTVC"
    
    static func nib() -> UINib {
        return UINib(nibName: "CellSelectionTVC", bundle: nil)
    }
    
    var callBackTap: (()->())?
    
    var isChecked: Bool = false {
        didSet {
            let imageName = isChecked ? "checkbox" : "unchecked"
            tickButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
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
    
}
