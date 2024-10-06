//
//  PaymentMethodVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit

class PaymentMethodVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart

    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }

    @IBOutlet weak var appleLabel: UILabel! {
        didSet {
            appleLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            appleLabel.text = "Apple Pay"
            appleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var onlineKnetLabel: UILabel! {
        didSet {
            onlineKnetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            onlineKnetLabel.text = "Online KNET"
        }
    }
    
    @IBOutlet weak var swipeKnetLabel: UILabel! {
        didSet {
            swipeKnetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            swipeKnetLabel.text = "KNET - Swipe Mschine"
        }
    }
    
    @IBOutlet weak var keepLabel: UILabel! {
        didSet {
            keepLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            keepLabel.text = "keep_order_open".localized()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func appleAction(_ sender: Any) {
        let confirmVC = OrderSuccessVC.instantiate()
        self.navigationController?.push(viewController: confirmVC)
    }
    
    @IBAction func onlineKnetAction(_ sender: Any) {
        let confirmVC = OrderSuccessVC.instantiate()
        self.navigationController?.push(viewController: confirmVC)
    }
    
    @IBAction func swipeKnetAction(_ sender: Any) {
        let confirmVC = OrderSuccessVC.instantiate()
        self.navigationController?.push(viewController: confirmVC)
    }
    
    @IBAction func keepAction(_ sender: Any) {
        let confirmVC = OrderSuccessVC.instantiate()
        self.navigationController?.push(viewController: confirmVC)
    }
}
