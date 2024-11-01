//
//  OrderDetailsVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/10/24.
//

import UIKit

class OrderDetailsVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text =  "ID # 134"
        }
    }
    
    @IBOutlet var itemDetailsTitle: UILabel! {
        didSet {
            itemDetailsTitle.font = UIFont.poppinsMediumFontWith(size: 18)
            itemDetailsTitle.text = "item_details".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addLabel: UILabel! {
        didSet {
            addLabel.font = UIFont.poppinsBoldFontWith(size: 18)
            addLabel.text = "add_usual".localized()
        }
    }
    
    @IBOutlet var summaryTitle: UILabel! {
        didSet {
            summaryTitle.font = UIFont.poppinsMediumFontWith(size: 18)
            summaryTitle.text = "summary".localized()
        }
    }
    @IBOutlet var amtTitle: UILabel! {
        didSet {
            amtTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            amtTitle.text = "amount".localized()
        }
    }
    @IBOutlet var amtLabel: UILabel! {
        didSet {
            amtLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            amtLabel.text = "23.000 KD"
        }
    }
    
    @IBOutlet var discountTitle: UILabel! {
        didSet {
            discountTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            discountTitle.text = "discount_apl".localized()
        }
    }
    @IBOutlet var discountLabel: UILabel! {
        didSet {
            discountLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            discountLabel.textColor = UIColor.red
            discountLabel.text = "-9.000 KD"
        }
    }
    
    @IBOutlet var totalTitle: UILabel! {
        didSet {
            totalTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            totalTitle.text = "total".localized()
        }
    }
    @IBOutlet var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            totalLabel.text = "3.000 KD"
        }
    }
    
    @IBOutlet var orderIdTitle: UILabel! {
        didSet {
            orderIdTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            orderIdTitle.text = "order_id".localized()
        }
    }
    @IBOutlet var orderIdLabel: UILabel! {
        didSet {
            orderIdLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            orderIdLabel.text = "233332"
        }
    }
    
    @IBOutlet var paidByTitle: UILabel! {
        didSet {
            paidByTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            paidByTitle.text = "paid_by".localized()
        }
    }
    @IBOutlet var paidByLabel: UILabel! {
        didSet {
            paidByLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            paidByLabel.text = "Bhushan"
        }
    }
    
    @IBOutlet var dateTimeTitle: UILabel! {
        didSet {
            dateTimeTitle.font = UIFont.poppinsMediumFontWith(size: 16)
            dateTimeTitle.text = "order_on".localized()
        }
    }
    @IBOutlet var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            dateTimeLabel.text = "2/2/22 - 23:13"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(OrderDetailsTableViewCell.nib(), forCellReuseIdentifier: OrderDetailsTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        self.mainTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.tblHeight.constant = newsize.height
                }
            }
        }
    }
    
    @IBAction func addUsualAction(_ sender: Any) {
        
    }
}

extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailsTableViewCell.identifier) as! OrderDetailsTableViewCell
        
        if indexPath.row == 0 {
            cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
        } else if indexPath.row == 1 {
            cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
