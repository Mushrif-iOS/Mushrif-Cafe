//
//  MyUsualTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 29/09/24.
//

import UIKit

class MyUsualTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "my_usual".localized()
        }
    }
    
    @IBOutlet var dataCollection: UICollectionView!
    
    var navController: UINavigationController?
    
    var usualObj = [DashboardMyUsual]()
    
    static let identifier = "MyUsualTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyUsualTVCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataCollection.register(MyUsualCVCell.nib(), forCellWithReuseIdentifier: MyUsualCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
        dataCollection.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MyUsualTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usualObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyUsualCVCell.identifier, for: indexPath) as! MyUsualCVCell
        let dict = usualObj[indexPath.item]
        cell.foodLabel.text = dict.title
        
        if (indexPath.item % 2 == 0) {
            cell.backView.backgroundColor = UIColor.appPink
        } else {
            cell.backView.backgroundColor = UIColor.usualGray
        }
        
        cell.addButton.tag = indexPath.item
        cell.addButton.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 202, height: 145)
    }
    
    @objc func addAction(sender: UIButton) {
        
        let dict = usualObj[sender.tag]
        let cartVC = CartVC.instantiate()
        self.navController?.pushViewController(cartVC, animated: true)
    }    
}
