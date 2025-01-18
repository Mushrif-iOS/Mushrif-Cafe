//
//  BannersTVCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 30/09/24.
//

import UIKit

class BannersTVCell: UITableViewCell {

    @IBOutlet var dataCollection: UICollectionView!
        
    static let identifier = "BannersTVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BannersTVCell", bundle: nil)
    }
    
    var bannerData: [String] = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dataCollection.register(BannersCVCell.nib(), forCellWithReuseIdentifier: BannersCVCell.identifier)
        dataCollection.delegate = self
        dataCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollection() {
        self.dataCollection.reloadData()
    }
}

extension BannersTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannersCVCell.identifier, for: indexPath) as! BannersCVCell
        cell.img.loadURL(urlString: self.bannerData[indexPath.item], placeholderImage: UIImage(named: "appLogo"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width), height: 191)
    }
}

