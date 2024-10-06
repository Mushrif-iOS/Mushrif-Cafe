//
//  TagsCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit

class TagsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.textLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override var isSelected: Bool {
        didSet {
            self.backView.backgroundColor = isSelected ? UIColor.selectedPink : UIColor.white
        }
    }
}
