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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(MyOrderTableViewCell.nib(), forCellReuseIdentifier: MyOrderTableViewCell.identifier)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
        
        if indexPath.row == 0 {
            cell.statusLabel.text = "Preparing"
            cell.topView.backgroundColor = UIColor.primaryBrown
        } else {
            cell.statusLabel.text = "Completed"
            cell.topView.backgroundColor = UIColor.borderPink
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = OrderDetailsVC.instantiate()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
