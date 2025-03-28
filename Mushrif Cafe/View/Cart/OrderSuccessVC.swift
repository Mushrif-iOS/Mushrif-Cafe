//
//  OrderSuccessVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 06/10/24.
//

import UIKit

class OrderSuccessVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .cart
    
    var successOrderDetails: SuccessOrderResponse?
    var successMsg: String = ""
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsMediumFontWith(size: 22)
//            titleLabel.text = "order_confirm".localized()
            self.titleLabel.text = successMsg != "" ? successMsg : "order_confirm".localized()
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
            orderIdLabel.text = "#\(successOrderDetails?.orderNumber ?? 0)"
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
            if "\(successOrderDetails?.paymentMethod ?? "")" == "apple_pay" {
                paymentLabel.text = "Apple Pay"
            } else if "\(successOrderDetails?.paymentMethod ?? "")" == "knet" {
                paymentLabel.text = "Online KNET"
            } else if "\(successOrderDetails?.paymentMethod ?? "")" == "knet_swipe" {
                paymentLabel.text = "KNET - Swipe Machine"
            } else if "\(successOrderDetails?.paymentMethod ?? "")" == "open" {
                paymentLabel.text = "Open Order"
            } else if "\(successOrderDetails?.paymentMethod ?? "")" == "wallet" {
                paymentLabel.text = "Wallet"
            } else {
                paymentLabel.text = "-"
            }
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
            dateTimeLabel.numberOfLines = 0
            dateTimeLabel.text = "\(successOrderDetails?.createdAt ?? "")"
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
            let amt = Double("\(successOrderDetails?.grandTotal ?? "")")
            amtLabel.text = "\(amt?.rounded(toPlaces: 2) ?? 0.0) KWD"
        }
    }
    
    @IBOutlet weak var addLabel: UILabel! {
        didSet {
            addLabel.font = UIFont.poppinsBoldFontWith(size: 18)
            addLabel.text = "add_usual".localized()
        }
    }
    
    @IBOutlet weak var backLabel: UILabel! {
        didSet {
            backLabel.font = UIFont.poppinsBoldFontWith(size: 18)
            backLabel.textColor = UIColor.primaryBrown
            backLabel.text = "back_home".localized()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addUsualAction(_ sender: Any) {
        let addVC = AddUsualsVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.productId = "\(successOrderDetails?.id ?? 0)"
        addVC.itemType = "ordered"
        self.present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if self.title == "Dashboard" {
            //NotificationCenter.default.post(name: Notification.Name("ShowOrders"), object: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            let dashboardVC = DashboardVC.instantiate()
            self.navigationController?.push(viewController: dashboardVC)
        }
    }
}
