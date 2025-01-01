//
//  MyOrderTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    
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
            statusLabel.text = "Preparing"
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
    @IBOutlet var payTypeTitle: UILabel! {
        didSet {
            payTypeTitle.font = UIFont.poppinsLightFontWith(size: 16)
            payTypeTitle.text = "payment_type".localized()
        }
    }
    @IBOutlet var amtTitle: UILabel! {
        didSet {
            amtTitle.font = UIFont.poppinsLightFontWith(size: 16)
            amtTitle.text = "amount".localized()
        }
    }
    @IBOutlet var typeTitle: UILabel! {
        didSet {
            typeTitle.font = UIFont.poppinsLightFontWith(size: 16)
            typeTitle.text = "type".localized()
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
            dateTimeLabel.numberOfLines = 0
            dateTimeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var payTypeLabel: UILabel! {
        didSet {
            payTypeLabel.font = UIFont.poppinsLightFontWith(size: 16)
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsLightFontWith(size: 16)
        }
    }
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.font = UIFont.poppinsLightFontWith(size: 16)
        }
    }
    
    static let identifier = "MyOrderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyOrderTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
