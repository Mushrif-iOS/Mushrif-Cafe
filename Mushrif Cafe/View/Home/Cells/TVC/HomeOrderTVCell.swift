//
//  HomeOrderTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/10/24.
//

import UIKit

class HomeOrderTVCell: UITableViewCell {
    
    @IBOutlet var dataCollection: UICollectionView!
    
    var navController: UINavigationController?
    var usualObj = [MyActiveOrder]()
    
    var cartId: String = ""
    
    static let identifier = "HomeOrderTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeOrderTVCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(HomeOrderCVCell.nib(), forCellWithReuseIdentifier: HomeOrderCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
        dataCollection.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadCollection() {
        self.dataCollection.reloadData()
    }
}

extension HomeOrderTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PayNowDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usualObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeOrderCVCell.identifier, for: indexPath) as! HomeOrderCVCell
        let dict = usualObj[indexPath.item]
        cell.orderLabel.text = "\("order_id".localized()) #\(dict.orderNumber)"
        
        cell.noOfItemLabel.text = dict.cart != nil ? "\(dict.cart.items)" : ""
        
        cell.dateTimeLabel.text = "\(dict.createdAt)"
        let amt = Double("\(dict.grandTotal)")
        cell.amtLabel.text = "\(amt?.rounded(toPlaces: 2) ?? 0.0) KWD"
        
        if dict.paymentStatus == "Paid" {
            cell.payNowButton.isHidden = true
            cell.statusLabel.text = "paid_order".localized()
        } else {
            cell.payNowButton.isHidden = false
            cell.statusLabel.text = "open_order".localized()
        }
        
        cell.payNowButton.tag = indexPath.item
        cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 236)
    }
    
    @objc func payNowAction(sender: UIButton) {
        
        let dict = usualObj[sender.tag]
        if dict.cart != nil {
            self.cartId = "\(dict.cart.id)"
            let addVC = HomePaymentMethodVC.instantiate()
            if #available(iOS 15.0, *) {
                if let sheet = addVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.preferredCornerRadius = 15
                }
            }
            addVC.delegate = self
            addVC.cardID = "\(dict.cart.id)"
            addVC.totalCost = dict.grandTotal
            self.navController?.present(addVC, animated: true, completion: nil)
        } else {
            self.navController?.showBanner(message: "no_cart_item".localized(), status: .error)
        }
    }
    
    func onSelect(type: String, paymentId: String, orderId: String, amount: String) {
        print(type)
        print(paymentId)
        
        if type == "knet_swipe" || type == "open" {
            let aParams = ["cart_id": self.cartId, "payment_type": type]
            print(aParams)
            
            var successOrderDetails: SuccessOrderResponse?
            
            APIManager.shared.postCall(APPURL.place_order, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                let dataDict = responseJSON["response"]
                successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
                
                let msg = responseJSON["message"].stringValue
                print(msg)
                DispatchQueue.main.async {
                    let orderVC = OrderSuccessVC.instantiate()
                    orderVC.successOrderDetails = successOrderDetails
                    orderVC.successMsg = msg
                    orderVC.title = "Dashboard"
                    self.navController?.pushViewController(orderVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        } else if type == "apple_pay" {
            self.paymentOrder(orderId: orderId, type: type, payId: paymentId, paymentStatus: "Paid", amt: amount)
        } else if type == "knet" {
            self.paymentOrder(orderId: orderId, type: type, payId: paymentId, paymentStatus: "Paid", amt: amount)
        }
    }
    
    private func paymentOrder(orderId: String, type: String, payId: String, paymentStatus: String, amt: String) {
        
        let aParams = ["order_id": orderId, "payment_type": type, "payment_id": payId, "payment_status": paymentStatus, "amount": amt]
        print(aParams)
        
        var successOrderDetails: SuccessOrderResponse?
        
        APIManager.shared.postCall(APPURL.payment_order, params: aParams, withHeader: true) { responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]
            successOrderDetails = SuccessOrderResponse(fromJson: dataDict)
            
            let msg = responseJSON["message"].stringValue
            print(msg)
            DispatchQueue.main.async {
                let orderVC = OrderSuccessVC.instantiate()
                orderVC.successOrderDetails = successOrderDetails
                orderVC.successMsg = msg
                orderVC.title = "Dashboard"
                self.navController?.pushViewController(orderVC, animated: true)
            }
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
}

