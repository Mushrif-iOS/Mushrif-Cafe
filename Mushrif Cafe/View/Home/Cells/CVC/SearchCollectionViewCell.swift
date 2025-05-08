//
//  SearchCollectionViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 31/10/24.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 12)
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.poppinsBoldFontWith(size: 14)
        }
    }
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var addUsual: UIButton!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 14)
            addButton.setTitle("add".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var addUsualLabel: UILabel! {
        didSet {
            addUsualLabel.font = UIFont.poppinsRegularFontWith(size: 10)
            addUsualLabel.text = "add_usual".localized()
        }
    }
    
    @IBOutlet weak var customizeLabel: UILabel! {
        didSet {
            customizeLabel.font = UIFont.poppinsRegularFontWith(size: 8)
            //customizeLabel.text = "customizable".localized()
        }
    }
    
    static let identifier = "SearchCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
