//
//  OrderSuccessVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit

class OrderSuccessVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsMediumFontWith(size: 22)
            titleLabel.text = "order_confirm".localized()
        }
    }
    
    @IBOutlet var orderIdTitle: UILabel! {
        didSet {
            orderIdTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            orderIdTitle.text = "order_id".localized()
        }
    }
    
    @IBOutlet var orderIdLabel: UILabel! {
        didSet {
            orderIdLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            orderIdLabel.text = "233332"
        }
    }
    
    @IBOutlet var paymentTitle: UILabel! {
        didSet {
            paymentTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            paymentTitle.text = "payment".localized()
        }
    }
    @IBOutlet var paymentLabel: UILabel! {
        didSet {
            paymentLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            paymentLabel.text = "Wallet"
        }
    }
    
    @IBOutlet var dateTimeTitle: UILabel! {
        didSet {
            dateTimeTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            dateTimeTitle.text = "date_time".localized()
        }
    }
    @IBOutlet var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            dateTimeLabel.text = "8/8/2024, 13:02 PM"
        }
    }
    
    @IBOutlet var amtTitle: UILabel! {
        didSet {
            amtTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            amtTitle.text = "amount".localized()
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsRegularFontWith(size: 16)
            amtLabel.text = "23.00 KWD"
        }
    }
    
    @IBOutlet weak var addLabel: UILabel! {
        didSet {
            addLabel.font = UIFont.poppinsBoldFontWith(size: 18)
            addLabel.text = "add_usual".localized()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigationController?.popViewControllers(viewsToPop: 2)
            //NotificationCenter.default.post(name: Notification.Name("OrderView"), object: nil)
        }
    }
}
