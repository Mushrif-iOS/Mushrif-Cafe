//
//  OTPViewController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 26/09/24.
//

import UIKit
import MFSDK

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
    var tempOTP: String = ""
    
    var countdownTimer: Timer?
    var remainingTime = Int()
    
    @IBOutlet weak var otpContainerView: UIView!
    
    @IBOutlet weak var resendButton: UIButton! {
        didSet {
            resendButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            resendButton.setTitle("\("resend_otp".localized()) (\(remainingTime)s)", for: .normal)
            resendButton.isEnabled = false
        }
    }
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.titleLabel?.font = UIFont.poppinsBoldFontWith(size: 18)
            submitBtn.setTitle("verify".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otpValueText: UILabel! {
        didSet {
            otpValueText.font = UIFont.poppinsMediumFontWith(size: 18)
        }
    }
    
    var otpView: OTPFieldView = OTPFieldView()
    var enteredOtp: String = ""
    var hasEnterd: Bool = false
    
    var customerData: Customer?
    
    var paymentData: [PaymentTypeResponse] = [PaymentTypeResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterText.text = "\("please_enter_otp".localized()) \n\(enteredNumber)"
        
        self.otpValueText.text = tempOTP
        self.startTimer()
        
        setupOtpView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
    }
    
    deinit {
        // Invalidate the timer when the view controller is deallocated
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
    }
    
    @IBAction func resendAction(_ sender: Any) {
        
        let aParams: [String: String] = ["phone": "\(self.enteredNumber)"]
        
        print(aParams)

        APIManager.shared.loginWithRetry(to: APPURL.getOTP, parameters: aParams, maxRetries: 2) { result in
            switch result {
            case .success(let data):
                self.otpValueText.text = "\(data.otp)"
                
                guard self.remainingTime == 0 else {
                    self.showBanner(message: "Please wait \(self.remainingTime) seconds before retrying.", status: .failed)
                    return
                }
                
                // Reset the timer and resend OTP
                self.remainingTime = data.otpValidityPeriodInSeconds
                self.resendButton.setTitle("\("resend_otp".localized()) (\(self.remainingTime)s)", for: .normal)
                self.resendButton.isEnabled = false
                self.startTimer()
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        postOTPCall()
    }
    
    private func postOTPCall() {
        
        if !hasEnterd {
            self.showBanner(message: "otp_error".localized(), status: .failed)
        }
//        else if self.enteredOtp != self.otpValueText.text {
//            self.showBanner(message: "otp_not_valid".localized(), status: .failed)
//            return
//        }
        else {
            
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
                UserDefaultHelper.userEmail = "\(self.customerData?.email ?? "")"
                UserDefaultHelper.mobile = "\(self.customerData?.phone ?? "")"
                UserDefaultHelper.walletBalance = "\(self.customerData?.balance ?? "")"
                self.getPaymentGateway()
                DispatchQueue.main.async {
                    if "\(self.customerData?.name ?? "")" == "" || "\(self.customerData?.name ?? "")" == "Guest" || "\(self.customerData?.name ?? "")" == "Guest User" {
                        let nextVC = CompleteProfileVC.instantiate()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let scanVC = DashboardVC.instantiate()
                        self.navigationController?.pushViewController(scanVC, animated: true)
                    }
                }
            } failure: { error in
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    private func getPaymentGateway() {
        
        let aParams = ["": ""]
        
        print(aParams)
        
        APIManager.shared.getCallWithParams(APPURL.payment_gateway, params: aParams) { responseJSON in
            print("Response JSON \(responseJSON)")
            
            let dataDict = responseJSON["response"].arrayValue
            
            for obj in dataDict {
                self.paymentData.append(PaymentTypeResponse(fromJson: obj))
            }
            UserDefaultHelper.paymentKey = "\(self.paymentData.first?.parameters.apiKey ?? "")"
            UserDefaultHelper.paymentEnv = "\(self.paymentData.first?.parameters.environment ?? "")"
            
            MFSettings.shared.configure(token: UserDefaultHelper.paymentKey ?? "",
                                        country: .kuwait, environment: UserDefaultHelper.paymentEnv == "sandbox" ? .test : .live)
            
            let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.primaryBrown, navigationTitle: "payment".localized(), cancelButtonTitle: "cancel".localized())
            MFSettings.shared.setTheme(theme: them)
        } failure: { error in
            print("Error \(error.localizedDescription)")
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
    
    func startTimer() {
        self.countdownTimer?.invalidate()
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if self.remainingTime > 0 {
            self.remainingTime -= 1
            self.resendButton.setTitle("\("resend_otp".localized()) (\(remainingTime)s)", for: .normal)
            self.resendButton.isEnabled = false
        } else {
            self.countdownTimer?.invalidate()
            self.resendButton.isEnabled = true
            self.resendButton.setTitle("\("resend_otp".localized())", for: .normal)
        }
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
