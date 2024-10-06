//
//  MealDetailsViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit

class MealDetailsViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet var selectionList: SelectionList!
    
    @IBOutlet weak var stepperView: UIView!
    
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 30)
            qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            
            let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(totalValue.toRoundedString(toPlaces: 2))",
                                                       attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)]);
            attrString.append(NSMutableAttributedString(string: " KD",
                                                        attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]));
            addButton.setAttributedTitle(attrString, for: .normal)
        }
    }
    
    var totalValue: Double = Double()
    var qtyValue: Int = 1
    
    let userLanguage = UserDefaultHelper.language
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        selectionList.items = ["One", "Two", "Three", "Four", "Five"]
//        // selectionList.selectedIndexes = [0, 1, 4]
//        selectionList.isSelectionMarkTrailing = true
//        selectionList.tableView.separatorStyle = .none
//        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        mainTableView.register(MealDetailsHeaderCell.nib(), forCellReuseIdentifier: MealDetailsHeaderCell.identifier)
        mainTableView.register(SelectionListCell.self, forCellReuseIdentifier: "SelectionListCell")
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func selectionChanged() {
        print(selectionList.selectedIndexes)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if qtyValue > 1 {
            qtyValue -= 1
        }
        qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
    }
    
    @IBAction func plusAction(_ sender: Any) {
        if qtyValue < 10 {
            qtyValue += 1
        }
        qty.text =  userLanguage == "ar" ? "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "AR")) :  "\(qtyValue)".convertedDigitsToLocale(Locale(identifier: "EN"))
    }
    
    @IBAction func nextAscreenAction(_ sender: Any) {
    }
}

extension MealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionListCell") as! SelectionListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "MealDetailsHeaderCell") as! MealDetailsHeaderCell
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 425
    }
}
