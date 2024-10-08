//
//  MealDetailsViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit

class MealDetailsViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet var mealImg: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.poppinsMediumFontWith(size: 22)
        }
    }
    
    @IBOutlet var descLabel: UITextView! {
        didSet {
            descLabel.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            descLabel.font = UIFont.poppinsRegularFontWith(size: 15)
            descLabel.text = "Fresh beef, tomato, cheddar cheese, lettuce, cocktail sauce, brioche bun."
            let userLanguage = UserDefaultHelper.language
            descLabel.textAlignment =  userLanguage == "ar" ? .right :  .left
        }
    }
    
    @IBOutlet var txtViewHeight: NSLayoutConstraint!
    
    @IBOutlet var typeOfMealLabel: UILabel! {
        didSet {
            typeOfMealLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            typeOfMealLabel.text = "Type of Meal"
        }
    }
    @IBOutlet var requiredLabel: UILabel! {
        didSet {
            requiredLabel.font = UIFont.poppinsMediumFontWith(size: 13)
        }
    }
    
    @IBOutlet weak var stepperView: UIView!
    
    @IBOutlet weak var qty: UILabel! {
        didSet {
            qty.font = UIFont.poppinsMediumFontWith(size: 30)
            qty.text =  userLanguage == "ar" ? "١" :  "1"
        }
    }
    @IBOutlet weak var mealTypeTblView: UITableView!
    @IBOutlet var mealTypeTblHeight: NSLayoutConstraint!
    
    @IBOutlet var stuffLabel: UILabel! {
        didSet {
            stuffLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            stuffLabel.text = "Select Stuff"
        }
    }
    
    @IBOutlet weak var stuffTblView: UITableView!
    @IBOutlet var stuffTblHeight: NSLayoutConstraint!
    
    @IBOutlet var addOnLabel: UILabel! {
        didSet {
            addOnLabel.font = UIFont.poppinsMediumFontWith(size: 17)
            addOnLabel.text = "Addons"
        }
    }
    
    @IBOutlet weak var addOnTblView: UITableView!
    @IBOutlet var addOnTblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            
            let attrString = NSMutableAttributedString(string: "\("add".localized()) - \(totalValue.toRoundedString(toPlaces: 3))",
                                                       attributes: [NSAttributedString.Key.font: UIFont.poppinsMediumFontWith(size: 22)])
            attrString.append(NSMutableAttributedString(string: " KD",
                                                        attributes: [NSAttributedString.Key.font: UIFont.poppinsBoldFontWith(size: 14)]))
            addButton.setAttributedTitle(attrString, for: .normal)
        }
    }
    
    var totalValue: Double = Double()
    var qtyValue: Int = 1
    
    let userLanguage = UserDefaultHelper.language
    
    var arrSelectedRows: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mealTypeTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.stuffTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        self.addOnTblView.register(CellSelectionTVC.nib(), forCellReuseIdentifier: CellSelectionTVC.identifier)
        
        self.mealTypeTblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if #available(iOS 15.0, *) {
            mealTypeTblView.sectionHeaderTopPadding = 0
            stuffTblView.sectionHeaderTopPadding = 0
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                DispatchQueue.main.async {
                    let newsize  = newvalue as! CGSize
                    self.mealTypeTblHeight.constant = newsize.height
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustTextViewHeight()
        self.stuffTblHeight.constant = stuffTblView.contentSize.height
        self.addOnTblHeight.constant = addOnTblView.contentSize.height
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
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
        self.dismiss(animated: true)
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = descLabel.frame.size.width
        let newSize = descLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        txtViewHeight.constant = newSize.height
    }
}

extension MealDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.mealTypeTblView {
            return 2
        } else if tableView == self.stuffTblView {
            return 10
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mealTypeTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            if arrSelectedRows.contains(indexPath){
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                cell.tickButton.isSelected = !cell.tickButton.isSelected
            }
            return cell
        } else if tableView == self.stuffTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            if arrSelectedRows.contains(indexPath){
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                if self.arrSelectedRows.contains(indexPath) {
                    self.arrSelectedRows.remove(at: self.arrSelectedRows.firstIndex(of: indexPath)!)
                } else {
                    self.arrSelectedRows.append(indexPath)
                }
                cell.tickButton.isSelected = !cell.tickButton.isSelected
                print("IndexPath: ", self.arrSelectedRows)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSelectionTVC") as! CellSelectionTVC
            if arrSelectedRows.contains(indexPath){
                cell.tickButton.isSelected = true
            } else {
                cell.tickButton.isSelected = false
            }
            cell.callBackTap = {
                cell.tickButton.isSelected = !cell.tickButton.isSelected
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
