//
//  WalletVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit

class WalletVC: UIViewController, Instantiatable, AddMoneyDelegate {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "wallet".localized()
        }
    }
    
    @IBOutlet weak var avlLabel: UILabel! {
        didSet {
            avlLabel.font = UIFont.poppinsBoldFontWith(size: 16)
            avlLabel.text = "avl_balance".localized()
        }
    }
    
    @IBOutlet weak var balanceLabel: UILabel! {
        didSet {
            balanceLabel.font = UIFont.poppinsBoldFontWith(size: 35)
            self.balanceLabel.text = ""
        }
    }
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.titleLabel?.font = UIFont.poppinsMediumFontWith(size: 16)
            addButton.setTitle("add_fund".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var transactionData: [Transaction] = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(WalletTableViewCell.nib(), forCellReuseIdentifier: WalletTableViewCell.identifier)
        
        self.getWalletDetails()
    }

    func completed() {
        self.transactionData.removeAll()
        self.getWalletDetails()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        let addVC = AddFundViewController.instantiate()
        
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
    
    private func getWalletDetails() {
        
        let aParams: [String: Any] = [:]
        
        APIManager.shared.getCallWithParams(APPURL.wallet_details, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
                                    
            let dataDict = responseJSON["response"]["transactions"].arrayValue
            
            for obj in dataDict {
                self.transactionData.append(Transaction(fromJson: obj))
            }
                                    
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
                
                let balance = responseJSON["response"]["balance"].stringValue
                let doubleValue = Double(balance) ?? 0.0
                self.balanceLabel.text = UserDefaultHelper.language == "en" ? "\(doubleValue.rounded(toPlaces: 2)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 2))"
                UserDefaultHelper.walletBalance = "\(doubleValue)"
            }
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell") as! WalletTableViewCell
        
        let dict = self.transactionData[indexPath.row]
        cell.numberLabel.text = "#\(dict.id)"
        cell.dateLabel.text = dict.transactionDate
        
        if dict.txnType == "Cr" {
            cell.amtLabel.textColor = UIColor.primaryBrown
            
            let doubleValue = Double(dict.amount) ?? 0.0
            cell.amtLabel.text = UserDefaultHelper.language == "en" ? "+ \(doubleValue.rounded(toPlaces: 2)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 2)) +"
        } else {
            cell.amtLabel.textColor = UIColor.red
            
            let doubleValue = Double(dict.amount) ?? 0.0
            cell.amtLabel.text = UserDefaultHelper.language == "en" ? "- \(doubleValue.rounded(toPlaces: 2)) \("kwd".localized())" : "\("kwd".localized()) \(doubleValue.rounded(toPlaces: 2)) -"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.transactionData[indexPath.row]
        if "\(dict.recordId)" != "0"  {
            let detailVC = OrderDetailsVC.instantiate()
            detailVC.orderId = "\(dict.recordId)"
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            self.showBanner(message: "orderId_not_valid".localized(), status: .failed)
        }
    }
}
