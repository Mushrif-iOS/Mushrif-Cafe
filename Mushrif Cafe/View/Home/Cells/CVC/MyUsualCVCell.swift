//
//  MyUsualCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit

class MyUsualCVCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var foodLabel: UILabel! {
        didSet {
            foodLabel.font = UIFont.poppinsRegularFontWith(size: 18)
            foodLabel.text = "Chicken Shawarma, Pepsi, Fries"
        }
    }
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 16)
            addButton.setTitle("add_cart".localized(), for: .normal)
        }
    }
    
    static let identifier = "MyUsualCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyUsualCVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
