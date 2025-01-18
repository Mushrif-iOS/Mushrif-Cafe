//
//  CompleteProfileVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
//import ProgressHUD

class CompleteProfileVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .main
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
            titleText.text = "complete_profile".localized()
        }
    }
    
    @IBOutlet weak var fullName: UILabel! {
        didSet {
            fullName.font = UIFont.poppinsRegularFontWith(size: 16)
            fullName.text = "\("full_name".localized())*"
        }
    }
    
    @IBOutlet weak var txtFullName: UITextField! {
        didSet {
            txtFullName.font = UIFont.poppinsMediumFontWith(size: 16)
            txtFullName.tintColor = UIColor.primaryBrown
        }
    }
    
    @IBOutlet weak var emailTitle: UILabel! {
        didSet {
            emailTitle.font = UIFont.poppinsRegularFontWith(size: 16)
            emailTitle.text = "email".localized()
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.font = UIFont.poppinsMediumFontWith(size: 16)
            txtEmail.tintColor = UIColor.primaryBrown
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("signUp".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var customerData: Customer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().hasNotch {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.keyboardWillShow),
                                                   name: UIResponder.keyboardWillShowNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.keyboardWillHide),
                                                   name: UIResponder.keyboardWillHideNotification,
                                                   object: nil)
        }
        
        if UserDefaultHelper.userName != "" {
            txtFullName.text = UserDefaultHelper.userName
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {

        if txtFullName.text!.isEmpty {
            self.showBanner(message: "name_error".localized(), status: .error)
        } else if (txtEmail.text!.count == 0) && txtEmail.text?.isValidEmail == false {
            self.showBanner(message: "email_error".localized(), status: .error)
        } else {
            
            let aParams: [String: Any] = ["name": "\(self.txtFullName.text!)", "email": "\(self.txtEmail.text!)"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.updateProfile, params: aParams, withHeader: true) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let dataDict = responseJSON["response"].dictionaryValue
                
                let custata = dataDict["customer"]
                self.customerData = Customer(fromJson: custata)
                
                print("Customer Data", self.customerData!.name)
                UserDefaultHelper.userName = "\(self.customerData?.name ?? "")"
                UserDefaultHelper.userEmail = "\(self.customerData?.email ?? "")"
                UserDefaultHelper.mobile = "\(self.customerData?.phone ?? "")"
                
                DispatchQueue.main.async {
                    let scanVC = DashboardVC.instantiate()
                    self.navigationController?.pushViewController(scanVC, animated: true)
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

extension CompleteProfileVC {
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification,
                             keyboardWillShow: true,
                             viewBottomConstraint: bottomConstraint,
                             activeKeyboardToViewSpacing: 0,
                             hiddenKeyboardToViewSpacing: 5)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification,
                             keyboardWillShow: false,
                             viewBottomConstraint: bottomConstraint,
                             activeKeyboardToViewSpacing: 0,
                             hiddenKeyboardToViewSpacing: 20)
    }
    
    func moveViewWithKeyboard(notification: NSNotification,
                              keyboardWillShow: Bool,
                              viewBottomConstraint: NSLayoutConstraint,
                              activeKeyboardToViewSpacing: CGFloat,
                              hiddenKeyboardToViewSpacing: CGFloat) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        let keyboardAnimationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardAnimationCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            let safeAreaExists = self.view?.window?.safeAreaInsets.bottom != 0
            // Default value in case something goes wrong with bottom spacings
            let bottomConstant: CGFloat = 10
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant) + activeKeyboardToViewSpacing
        } else {
            viewBottomConstraint.constant = hiddenKeyboardToViewSpacing
        }
        
        // Animating the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: keyboardAnimationCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
}
