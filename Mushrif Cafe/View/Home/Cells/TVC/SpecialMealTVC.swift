//
//  SpecialMealTVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/03/25.
//

import UIKit

class SpecialMealTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 16)
        }
    }
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 18)
            //qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    var quantity: Int = 0 {
        didSet {
            qty.text = "\(quantity)"
        }
    }
    var onQuantityChanged: ((Int) -> Void)?
    
    static let identifier = "SpecialMealTVC"
    
    static func nib() -> UINib {
        return UINib(nibName: "SpecialMealTVC", bundle: nil)
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
        if quantity > 0 {
            onQuantityChanged?(-1)
        }
    }
    @IBAction func plusAction(_ sender: Any) {
        onQuantityChanged?(1)
    }
}
