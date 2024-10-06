//
//  CategoryViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/10/24.
//

import UIKit

class CategoryViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsRegularFontWith(size: 16)
        }
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
        }
    }
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var arr = ["Pizza", "Seasonal Fruits", "Platters & Sandwiches", "Pizza", "Seasonal Fruits", "Platters & Sandwiches"]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    var category = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = category
        subTitleLabel.text = "Pizza"
        
        mainTableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 6.0, left: 16.0, bottom: 0.0, right: 16.0)
        self.mainCollectionView.collectionViewLayout = layout
        
        totalLabel.text = "1 Item added - \(3.400) KD"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.applyGradient(isVertical: true, colorArray: [UIColor.primaryBrown, UIColor.borderPink])
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let dashboardVC = CompleteProfileVC.instantiate()
        self.navigationController?.push(viewController: dashboardVC)
    }
    
    @IBAction func goToNextAction(_ sender: Any) {
//        let detailVC = MealDetailsViewController.instantiate()
//        self.navigationController?.modalPresentationStyle = .formSheet
//        self.navigationController?.present(detailVC, animated: true)
        let cartVC = CartVC.instantiate()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVCell", for: indexPath) as! TagsCVCell
        cell.textLabel.text = arr[indexPath.item]
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.addUsual.tag = indexPath.row
        cell.addUsual.addTarget(self, action: #selector(addUsual(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func addUsual(sender: UIButton) {
        let addVC = AddUsualsVC.instantiate()
        if #available(iOS 15.0, *) {
            if let sheet = addVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
            }
        }
        self.present(addVC, animated: true, completion: nil)
    }
}
