//
//  ScanTableVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 28/09/24.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ScanTableVC: UIViewController, Instantiatable {
    static var storyboard: AppStoryboard = .home
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsBoldFontWith(size: 20)
            titleLabel.text = "scan_table".localized()
        }
    }
    
    @IBOutlet var skipButton: UIButton! {
        didSet {
            skipButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            skipButton.setTitle("skip".localized(), for: .normal)
        }
    }
    
    @IBOutlet var continueButton: UIButton! {
        didSet {
            continueButton.titleLabel?.font = UIFont.poppinsRegularFontWith(size: 18)
            continueButton.setTitle("continue_takeaway".localized(), for: .normal)
        }
    }
    
    @IBOutlet var scanView: UIView!
    
    @IBOutlet var qrImgeView: UIImageView!
    
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*requestCameraAccess { granted in
            if granted {
                // Start the QR code scanner
                self.setupCamera()
            } else {
                // Handle the case where permission is denied
                print("Camera access denied")
                let alert = UIAlertController(title: "camera_access".localized(),
                                              message: "enable_camera".localized(),
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "go_settings".localized(), style: .default) { _ in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                })
                
                alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }*/
        let jsonStr = SingleTon.sharedSingleTon.stringify(json: ["user_id": UserDefaultHelper.userloginId ?? "", "loylity_points": 10.548], prettyPrinted: true)
        print(jsonStr)
        let qrImage = SingleTon.sharedSingleTon.generateQRCode(from: jsonStr)
        self.qrImgeView.image = qrImage
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let dashboardVC = DashboardVC.instantiate()
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
    // MARK: - set up camera
    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [.qr,
                                          .ean13,
                                          .ean8,
                                          .upce,
                                          .code39,
                                          .code128,
                                          .pdf417]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            scanView.layer.addSublayer(previewLayer)
            
            session.startRunning()
            
        } catch {
            showAlert()
            print(error)
        }
    }
    
    // MARK: - Alert
    
    func showAlert() {
        let alert = UIAlertController(title: ScanConstants.alertTitle,
                                      message: ScanConstants.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ScanConstants.alertButtonTitle,
                                      style: .default))
        present(alert, animated: true)
    }
    
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            // Request permission if not determined yet
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .restricted, .denied:
            // If permission is restricted or denied, inform the user
            completion(false)
        case .authorized:
            // Permission granted
            completion(true)
        @unknown default:
            // Handle future cases
            completion(false)
        }
    }
    
}

extension ScanTableVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let stringValue = metadataObject.stringValue else { return }
        
        print(stringValue)
        if stringValue != "" {
            session.stopRunning()
        }
    }
    
    func createOverlay() -> UIView {
        let overlayView = UIView(frame: scanView.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let path = CGMutablePath()
        
        path.addRoundedRect(in: CGRect(x: 50, y: 100, width: overlayView.frame.width-100, height: overlayView.frame.height - 300), cornerWidth: 5, cornerHeight: 5)
        
        
        path.closeSubpath()
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 5.0
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.white.cgColor
        
        overlayView.layer.addSublayer(shape)
        
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
}
