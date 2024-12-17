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
        }
    }
    
    var orderDetails: OrderData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mainTableView.register(OrderDetailsTableViewCell.nib(), forCellReuseIdentifier: OrderDetailsTableViewCell.identifier)
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        self.mainTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.setupUI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.tblHeight.constant = 0//newsize.height
                }
            }
        }
    }
    
    @IBAction func addUsualAction(_ sender: Any) {
        
        let dict = self.orderDetails
        
        let aParams: [String: Any] = ["group_id": "", "product_id": "", "quantity": "1", "item_type": "ordered", "order_id": "\(dict?.id ?? 0)"]
        print(aParams)
        
        APIManager.shared.postCall(APPURL.add_Item_To_Usual, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let msg = responseJSON["message"].stringValue
            self.showBanner(message: msg, status: .success)
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            self.titleLabel.text = "ID #\(self.orderDetails?.orderNumber ?? 0)"
            let amt = Double("\(self.orderDetails?.subTotal ?? "")")
            self.amtLabel.text = "\(amt?.rounded(toPlaces: 2) ?? 0.0) KWD"
            
            let disc = Double("\(self.orderDetails?.discount ?? "")")
            self.discountLabel.text = "-\(disc?.rounded(toPlaces: 2) ?? 0.0) KWD"
            
            let total = Double("\(self.orderDetails?.grandTotal ?? "")")
            self.totalLabel.text = "\(total?.rounded(toPlaces: 2) ?? 0.0) KWD"
            
            self.orderIdLabel.text = "#\(self.orderDetails?.orderNumber ?? 0)"
            self.paidByLabel.text = "-"
            self.dateTimeLabel.text = "\(self.orderDetails?.createdAt ?? "")"
        }
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
