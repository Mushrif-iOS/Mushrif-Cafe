//
//  HomeOrderTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/10/24.
//

import UIKit

class HomeOrderTVCell: UITableViewCell {
    
//    @IBOutlet var topView: UIView!
//    
//    @IBOutlet var orderLabel: UILabel! {
//        didSet {
//            orderLabel.font = UIFont.poppinsMediumFontWith(size: 18)
//        }
//    }
//    @IBOutlet var statusLabel: UILabel! {
//        didSet {
//            statusLabel.font = UIFont.poppinsMediumFontWith(size: 18)
//            //statusLabel.text = "OPEN ORDER"
//        }
//    }
//    
//    @IBOutlet var noOfItemTitle: UILabel! {
//        didSet {
//            noOfItemTitle.font = UIFont.poppinsLightFontWith(size: 16)
//            noOfItemTitle.text = "no_of_items".localized()
//        }
//    }
//    @IBOutlet var dateTimeTitle: UILabel! {
//        didSet {
//            dateTimeTitle.font = UIFont.poppinsLightFontWith(size: 16)
//            dateTimeTitle.text = "date_time".localized()
//        }
//    }
//    @IBOutlet var amtTitle: UILabel! {
//        didSet {
//            amtTitle.font = UIFont.poppinsLightFontWith(size: 16)
//            amtTitle.text = "amount".localized()
//        }
//    }
//    
//    @IBOutlet var noOfItemLabel: UILabel! {
//        didSet {
//            noOfItemLabel.font = UIFont.poppinsLightFontWith(size: 16)
//        }
//    }
//    @IBOutlet var dateTimeLabel: UILabel! {
//        didSet {
//            dateTimeLabel.font = UIFont.poppinsLightFontWith(size: 16)
//        }
//    }
//    @IBOutlet var amtLabel: UILabel! {
//        didSet {
//            amtLabel.font = UIFont.poppinsLightFontWith(size: 16)
//        }
//    }
//    
//    @IBOutlet weak var payNowButton: UIButton! {
//        didSet {
//            payNowButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 16)
//            payNowButton.setTitle("pay_now".localized(), for: .normal)
//        }
//    }
    
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
}

extension HomeOrderTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PayNowDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usualObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeOrderCVCell.identifier, for: indexPath) as! HomeOrderCVCell
        let dict = usualObj[indexPath.item]
        cell.orderLabel.text = "\("order_id".localized()) #\(dict.orderNumber)"
        cell.statusLabel.text = "open_order".localized()
        cell.noOfItemLabel.text = "\(dict.cart.items)"
        cell.dateTimeLabel.text = "\(dict.createdAt)"
        let amt = Double("\(dict.grandTotal)")
        cell.amtLabel.text = "\(amt?.rounded(toPlaces: 2) ?? 0.0) KWD"
        cell.payNowButton.tag = indexPath.item
        cell.payNowButton.addTarget(self, action: #selector(payNowAction(sender: )), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 236)
    }
    
    @objc func payNowAction(sender: UIButton) {
        
        let dict = usualObj[sender.tag]
        self.cartId = "\(dict.cart.id)"
        let addVC = PaymentMethodVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        addVC.delegate = self
        addVC.totalCost = dict.grandTotal
        self.navController?.present(addVC, animated: true, completion: nil)
    }
    
    func onSelect(type: String, paymentId: String) {
        print(type)
        print(paymentId)
        
        let aParams = ["cart_id": self.cartId, "payment_type": type, "payment_id": paymentId]
        
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
    }
}

