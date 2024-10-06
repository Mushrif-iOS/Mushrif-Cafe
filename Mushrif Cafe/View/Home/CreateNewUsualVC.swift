//
//  CreateNewUsualVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 07/10/24.
//

import UIKit
import IQKeyboardManagerSwift

class CreateNewUsualVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home

    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "usual_name".localized()
        }
    }
    
    @IBOutlet weak var txtUsual: UITextField! {
        didSet {
            txtUsual.font = UIFont.poppinsRegularFontWith(size: 18)
            txtUsual.tintColor = UIColor.primaryBrown
            txtUsual.placeholder = "usual_name".localized()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        txtUsual.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
}
