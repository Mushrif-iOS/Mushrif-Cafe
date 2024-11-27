//
//  ManageUsualTableViewCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit

class ManageUsualTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.poppinsBoldFontWith(size: 14)
        }
    }
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.font = UIFont.poppinsRegularFontWith(size: 14)
        }
    }
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 16)
            editButton.setAttributedTitle(NSAttributedString(string: "edit".localized(), attributes:
                                                                [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        }
    }
    @IBOutlet weak var otherPriceLabel: UILabel! {
        didSet {
            otherPriceLabel.font = UIFont.poppinsBoldFontWith(size: 14)
        }
    }
    
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 18)
            //qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    
    var totalValue: Double = Double()
    var qtyValue: Int = 1
    
    var itemId = String()
    
    let userLanguage = UserDefaultHelper.language
    
    static let identifier = "ManageUsualTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ManageUsualTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if qtyValue > 1 {
            qtyValue -= 1
            
            qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
                    
            let aParams: [String: Any] = ["item_id": "\(self.itemId)", "quantity": "1", "is_increment": "0"]
            print(aParams)
            
            APIManager.shared.postCall(APPURL.update_usuals_Qty, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        if qtyValue < 20 {
            qtyValue += 1
        }
        qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
        
        
        let aParams: [String: Any] = ["item_id": "\(self.itemId)", "quantity": "1", "is_increment": "1"]
        print(aParams)
        
        APIManager.shared.postCall(APPURL.update_usuals_Qty, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}
