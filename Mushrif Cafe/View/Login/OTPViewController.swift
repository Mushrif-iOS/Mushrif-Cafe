//
//  OTPViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
//import ProgressHUD

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
    
    var customerData: Customer?
    
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
        
        postOTPCall()
    }
    
    private func postOTPCall() {
        
        if !hasEnterd {
//            ProgressHUD.fontBannerTitle = UIFont.poppinsMediumFontWith(size: 18)
//            ProgressHUD.fontBannerMessage = UIFont.poppinsLightFontWith(size: 14)
//            ProgressHUD.colorBanner = UIColor.red
//            ProgressHUD.banner("error".localized(), "otp_error".localized())
            self.showBanner(message: "otp_error".localized(), status: .error)
        } else {
            
            let aParams: [String: Any] = ["phone": "\(self.enteredNumber)", "otp": "\(self.enteredOtp)"]
            
            print(aParams)
            
            APIManager.shared.postCall(APPURL.validateOTP, params: aParams, withHeader: false) { responseJSON in
                print("Response JSON \(responseJSON)")
                
                let dataDict = responseJSON["response"].dictionaryValue
                let tokenValue = dataDict["token"]?.stringValue
                UserDefaultHelper.authToken = tokenValue
                
                let customerData = dataDict["customer"]
                self.customerData = Customer(fromJson: customerData)
                
                print("Customer Data", self.customerData!.phone)
                UserDefaultHelper.userloginId = "\(self.customerData?.id ?? 0)"
                UserDefaultHelper.userName = "\(self.customerData?.name ?? "")"
                
                DispatchQueue.main.async {
                    if "\(self.customerData?.name ?? "")" == "" {
                        let nextVC = CompleteProfileVC.instantiate()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let scanVC = ScanTableVC.instantiate()
                        self.navigationController?.pushViewController(scanVC, animated: true)
                    }
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
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
        
        self.otpView.fieldsCount = 6
        self.otpView.defaultBorderColor = UIColor.clear
        self.otpView.filledBorderColor = UIColor.primaryBrown
        self.otpView.cursorColor = UIColor.primaryBrown
        self.otpView.filledBackgroundColor = UIColor.white
        self.otpView.defaultBackgroundColor = UIColor.white
        self.otpView.textColor = UIColor.primaryBrown
        self.otpView.fieldBorderWidth = 1
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldFont = UIFont.poppinsMediumFontWith(size: 18)
        self.otpView.fieldSize = 55
        self.otpView.separatorSpace = 1
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
