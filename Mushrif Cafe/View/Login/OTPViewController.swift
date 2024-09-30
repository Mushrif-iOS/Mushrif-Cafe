//
//  OTPViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
import ProgressHUD

class OTPViewController: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .main
    
    @IBOutlet weak var titleText: UILabel! {
        didSet {
            titleText.font = UIFont.poppinsMediumFontWith(size: 18)
            titleText.text = "ot_verification".localized()
        }
    }
    
    @IBOutlet weak var enterText: UILabel! {
        didSet {
            enterText.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    var enteredNumber: String = ""
    
    @IBOutlet weak var otpContainerView: UIView!
    
    @IBOutlet weak var resendButton: UIButton! {
        didSet {
            resendButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            resendButton.setTitle("resend_otp".localized(), for: .normal)
        }
    }
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("verify".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var otpView: OTPFieldView = OTPFieldView()
    var enteredOtp: String = ""
    var hasEnterd: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterText.text = "\("please_enter_otp".localized()) \n\(enteredNumber)"
        
        setupOtpView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendAction(_ sender: Any) {
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if !hasEnterd {
            ProgressHUD.banner("Error", "Please enter valid OTP")
            ProgressHUD.banner("error".localized(), "otp_error".localized())
        } else {
            let nextVC = CompleteProfileVC.instantiate()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func setupOtpView() {
        otpView.translatesAutoresizingMaskIntoConstraints = false
        otpContainerView.addSubview(otpView)
        
        NSLayoutConstraint.activate([
            otpView.leadingAnchor.constraint(equalTo: otpContainerView.leadingAnchor, constant: -10),
            otpView.trailingAnchor.constraint(equalTo: otpContainerView.trailingAnchor, constant: 10),
            otpView.topAnchor.constraint(equalTo: otpContainerView.topAnchor),
            otpView.bottomAnchor.constraint(equalTo: otpContainerView.bottomAnchor)
        ])
        
        self.otpView.fieldsCount = 4
        self.otpView.defaultBorderColor = UIColor.clear
        self.otpView.filledBorderColor = UIColor.primaryBrown
        self.otpView.cursorColor = UIColor.primaryBrown
        self.otpView.filledBackgroundColor = UIColor.white
        self.otpView.defaultBackgroundColor = UIColor.white
        self.otpView.textColor = UIColor.primaryBrown
        self.otpView.fieldBorderWidth = 1
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldFont = UIFont.poppinsMediumFontWith(size: 18)
        self.otpView.fieldSize = 70
        self.otpView.separatorSpace = 4
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
}

extension OTPViewController: OTPFieldViewDelegate {
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.enteredOtp = otpString
    }
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        hasEnterd = hasEntered
        return hasEntered
    }
}
