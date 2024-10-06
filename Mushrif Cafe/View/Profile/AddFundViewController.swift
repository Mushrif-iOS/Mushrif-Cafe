//
//  AddFundViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/10/24.
//

import UIKit
import IQKeyboardManagerSwift

class AddFundViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .profile
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    @IBOutlet weak var txtAmt: UITextField! {
        didSet {
            txtAmt.font = UIFont.poppinsMediumFontWith(size: 16)
            txtAmt.tintColor = UIColor.primaryBrown
            txtAmt.placeholder = "enter_amt".localized()
        }
    }
    
    @IBOutlet weak var appleLabel: UILabel! {
        didSet {
            appleLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            appleLabel.text = "Apple Pay"
            appleLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var knetLabel: UILabel! {
        didSet {
            knetLabel.font = UIFont.poppinsMediumFontWith(size: 16)
            knetLabel.text = "KNET"
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 215
        txtAmt.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
    
    @IBAction func appleAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func knetAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
