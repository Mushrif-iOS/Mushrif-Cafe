//
//  MyOrderViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

class MyOrderViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "my_order".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var orderData: [OrderData] = [OrderData]()
    var pageNo: Int = 1
    var lastPage: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(MyOrderTableViewCell.nib(), forCellReuseIdentifier: MyOrderTableViewCell.identifier)
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        
        self.getOrders(page: self.pageNo)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getOrders(page: Int) {
        
        let aParams: [String: Any] = [:]
        
        let userLanguage = UserDefaultHelper.language
        let dUrl = APPURL.get_order + "?locale=\(userLanguage == "ar" ? "Arabic---ae" :  "English---us")" + "&page=\(page)"
        
        APIManager.shared.getCallWithParams(dUrl, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            let lPage = responseJSON["response"]["last_page"].intValue
            self.lastPage = lPage
            
            let orderDataDict = responseJSON["response"]["data"].arrayValue
            
            for obj in orderDataDict {
                self.orderData.append(OrderData(fromJson: obj))
            }
            
            DispatchQueue.main.async {
                self.mainTableView.delegate = self
                self.mainTableView.dataSource = self
                self.mainTableView.reloadData()
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

extension MyOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.orderData.count == 0 {
            tableView.setEmptyMessage("no_orders".localized())
        } else {
            tableView.restore()
        }
        return self.orderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
        
        let dict = self.orderData[indexPath.row]
        
        if dict.status == 0 || dict.status == 1 || dict.status == 2 || dict.status == 3 || dict.status == 4 {
            cell.statusLabel.text = "open_order".localized()
            cell.topView.backgroundColor = UIColor.primaryBrown
        } else if dict.status == 5 {
            cell.statusLabel.text = "completed".localized()
            cell.topView.backgroundColor = UIColor.borderPink
        }        
        
        cell.orderLabel.text = "\("order_id".localized()) #\(dict.orderNumber)"
        cell.noOfItemLabel.text = "\(dict.itemCount)"
        cell.dateTimeLabel.text = "\(dict.createdAt)"
        if "\(dict.paymentMethod)" == "apple_pay" {
            cell.payTypeLabel.text = "Apple Pay"
        } else if "\(dict.paymentMethod)" == "knet" {
            cell.payTypeLabel.text = "Online KNET"
        } else if "\(dict.paymentMethod)" == "knet_swipe" {
            cell.payTypeLabel.text = "KNET - Swipe Machine"
        } else if "\(dict.paymentMethod)" == "open" {
            cell.payTypeLabel.text = "Open Order"
        } else if "\(dict.paymentMethod)" == "wallet" {
            cell.payTypeLabel.text = "Wallet"
        } else {
            cell.payTypeLabel.text = "-"
        }
        let amt = Double("\(dict.grandTotal)")
        cell.amtLabel.text = "\(amt?.rounded(toPlaces: 2) ?? 0.0) KWD"
        cell.typeLabel.text = "\(dict.orderType)".capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if self.pageNo < self.lastPage && indexPath.item == (self.orderData.count) - 1 {
            
            if(pageNo < self.lastPage) {
                
                print("Last Page: ", self.lastPage)
                
                let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(30))
                spinner.startAnimating()
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
                
                self.pageNo += 1
                print("Last ID: ", self.pageNo)
                
                self.getOrders(page: self.pageNo)
            } else {
                tableView.tableFooterView?.removeFromSuperview()
                let view = UIView()
                view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
                tableView.tableFooterView = view
                tableView.tableFooterView?.isHidden = true
            }
        } else {
            tableView.tableFooterView?.removeFromSuperview()
            let view = UIView()
            view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(5))
            tableView.tableFooterView = view
            tableView.tableFooterView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.orderData[indexPath.row]
        let detailVC = OrderDetailsVC.instantiate()
        detailVC.orderId = "\(dict.id)"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
