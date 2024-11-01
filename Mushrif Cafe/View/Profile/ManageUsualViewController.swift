//
//  ManageUsualViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit

class ManageUsualViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "manage_usual".localized()
        }
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    
    lazy var footerButton: UIButton! = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.primaryBrown
        button.setTitleColor(UIColor.white, for: .normal)
        button.borderColor = UIColor.borderPink
        button.borderWidth = 1
        button.cornerRadius = 30
        button.addTarget(self, action: #selector(didAddTaped), for: .touchUpInside)
        button.setTitle("add_new".localized(), for: .normal)
        button.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainTableView.register(MyUsualHeaderCell.nib(), forCellReuseIdentifier: MyUsualHeaderCell.identifier)
        mainTableView.register(ManageUsualTableViewCell.nib(), forCellReuseIdentifier: ManageUsualTableViewCell.identifier)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100))
        footerView.backgroundColor = .clear
        footerView.addSubview(footerButton)
        footerButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 17).isActive = true
        footerButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -17).isActive = true
        footerButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10).isActive = true
        //footerButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        footerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        mainTableView.tableFooterView = footerView
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        mainTableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ManageUsualViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageUsualTableViewCell") as! ManageUsualTableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
            } else if indexPath.row == 1 {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            } else {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
            }
        } else {
            if indexPath.row == 0 {
                cell.backView.roundCorners(corners: [.topLeft, .topRight], radius: 18)
            } else if indexPath.row == 1 {
                cell.backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: MyUsualHeaderCell.identifier) as! MyUsualHeaderCell
        headerView.headerTitle.text = "Usual - \(section)"
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func didAddTaped() {
        print("hifvbigbigbij")
    }
}
