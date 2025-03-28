//
//  LoginVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
import Alamofire
//import ProgressHUD

class LoginVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .main
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
            titleText.text = "continue_mobile".localized()
        }
    }
    
    @IBOutlet weak var enterText: UILabel! {
        didSet {
            enterText.font = UIFont.poppinsRegularFontWith(size: 16)
            enterText.text = "enter_mobile".localized()
        }
    }
    
    @IBOutlet weak var countryCode: UITextField! {
        didSet {
            countryCode.font = UIFont.poppinsMediumFontWith(size: 18)
            countryCode.text = "+965"
        }
    }
    
    @IBOutlet weak var mobileNumberText: UITextField! {
        didSet {
            mobileNumberText.font = UIFont.poppinsMediumFontWith(size: 18)
            mobileNumberText.tintColor = UIColor.primaryBrown
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("signUp".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var pickOption = ["+965", "+91", "+92", "+86", "+1"]
    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        countryCode.inputView = pickerView
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        postLoginCall()
    }
    
    private func postLoginCall() {
        
        if mobileNumberText.text!.count < 8 {
//            ProgressHUD.fontBannerTitle = UIFont.poppinsMediumFontWith(size: 18)
//            ProgressHUD.fontBannerMessage = UIFont.poppinsLightFontWith(size: 14)
//            ProgressHUD.colorBanner = UIColor.red
//            ProgressHUD.banner("error".localized(), "mobile_error".localized())
            self.showBanner(message: "mobile_error".localized(), status: .failed)
        } else {
            
            let aParams: [String: String] = ["phone": "\(self.mobileNumberText.text!)"]
            
            print(aParams)
            
            APIManager.shared.loginWithRetry(to: APPURL.getOTP, parameters: aParams, maxRetries: 2) { result in
                switch result {
                case .success(let data):
                    print("OTP: \(data.otp)")
                    DispatchQueue.main.async {
                        let otpVC = OTPViewController.instantiate()
                        otpVC.enteredNumber = self.mobileNumberText.text!
                        otpVC.tempOTP = "\(data.otp)"
                        otpVC.remainingTime = data.otpValidityPeriodInSeconds
                        self.navigationController?.push(viewController: otpVC)
                    }
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}

extension LoginVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCode.text = pickOption[row]
        
        guard let label = pickerView.view(forRow: row, forComponent: component) as? UILabel else {
            return
        }
        label.backgroundColor = UIColor.primaryBrown.withAlphaComponent(0.5)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickOption[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryBrown])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rowSize = pickerView.rowSize(forComponent: component)
        let width = rowSize.width
        let height = rowSize.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = pickOption[row]
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        return label
    }
}

extension LoginVC {
    
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
