//
//  HomeOrderCVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 20/12/24.
//

import UIKit

class HomeOrderCVCell: UICollectionViewCell {
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var orderLabel: UILabel! {
        didSet {
            orderLabel.font = UIFont.poppinsMediumFontWith(size: 18)
            orderLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var statusLabel: UILabel! {
        didSet {
            statusLabel.font = UIFont.poppinsMediumFontWith(size: 18)
            //statusLabel.text = "OPEN ORDER"
        }
    }
    
    @IBOutlet var noOfItemTitle: UILabel! {
        didSet {
            noOfItemTitle.font = UIFont.poppinsLightFontWith(size: 16)
            noOfItemTitle.text = "no_of_items".localized()
        }
    }
    @IBOutlet var dateTimeTitle: UILabel! {
        didSet {
            dateTimeTitle.font = UIFont.poppinsLightFontWith(size: 16)
            dateTimeTitle.text = "date_time".localized()
        }
    }
    @IBOutlet var amtTitle: UILabel! {
        didSet {
            amtTitle.font = UIFont.poppinsLightFontWith(size: 16)
            amtTitle.text = "amount".localized()
        }
    }
    
    @IBOutlet var noOfItemLabel: UILabel! {
        didSet {
            noOfItemLabel.font = UIFont.poppinsLightFontWith(size: 16)
        }
    }
    @IBOutlet var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont.poppinsLightFontWith(size: 16)
            dateTimeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsLightFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var payNowButton: UIButton! {
        didSet {
            payNowButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 16)
            payNowButton.setTitle("pay_now".localized(), for: .normal)
        }
    }
    
    static let identifier = "HomeOrderCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeOrderCVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
    }
}
