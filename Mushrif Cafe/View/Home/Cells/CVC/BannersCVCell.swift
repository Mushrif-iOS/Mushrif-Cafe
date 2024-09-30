//
//  BannersCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

class BannersCVCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    static let identifier = "BannersCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BannersCVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
