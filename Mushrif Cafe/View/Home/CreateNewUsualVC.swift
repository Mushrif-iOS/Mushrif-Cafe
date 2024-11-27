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
        }
    }
    
    @IBOutlet weak var txtUsual: UITextField! {
        didSet {
            txtUsual.font = UIFont.poppinsRegularFontWith(size: 18)
            txtUsual.tintColor = UIColor.primaryBrown
            txtUsual.placeholder = "usual_name".localized()
        }
    }
    
    var myUsual: UsualData?
    
    var delegate: AddMoneyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200
        txtUsual.delegate = self
        txtUsual.becomeFirstResponder()
        
        if self.title == "Update" {
            titleLabel.text = "usuals_update".localized()
            txtUsual.text = myUsual?.title
        } else {
            titleLabel.text = "usual_name".localized()
            txtUsual.text = ""
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
}

extension CreateNewUsualVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if txtUsual.text!.isEmpty {
            self.showBanner(message: "usuals_error".localized(), status: .error)
        } else {
            
            if self.title == "Update" {
                
                if txtUsual.text == self.myUsual?.title {
                    return
                }
                
                let aParams: [String: Any] = ["title": txtUsual.text!, "group_id": "\(self.myUsual?.id ?? 0)"]
                print(aParams)
                
                APIManager.shared.postCall(APPURL.update_usuals_group, params: aParams, withHeader: true) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    
                    let msg = responseJSON["message"].stringValue
                    self.showBanner(message: msg, status: .success)
                    
                    DispatchQueue.main.async {
                        self.delegate?.completed()
                        self.dismiss(animated: true)
                    }
                    
                } failure: { error in
                    print("Error \(error.localizedDescription)")
                }
                
            } else {
                let aParams: [String: Any] = ["title": txtUsual.text!]
                print(aParams)
                
                APIManager.shared.postCall(APPURL.create_usuals_group, params: aParams, withHeader: true) { responseJSON in
                    print("Response JSON \(responseJSON)")
                    
                    let msg = responseJSON["message"].stringValue
                    self.showBanner(message: msg, status: .success)
                    
                    DispatchQueue.main.async {
                        self.delegate?.completed()
                        self.dismiss(animated: true)
                    }
                    
                } failure: { error in
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
}
