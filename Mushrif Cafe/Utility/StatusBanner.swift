//
//  StatusBanner.swift
//  Lush
//
//  Created by Bhushan Kumar on 30/01/25.
//

import UIKit

enum BannerType {
    case success
    case failed
    case warning
}

class StatusBanner: UIView {
    
    private let messageLabel = UILabel()
    private let bannerHeight: CGFloat = 60.0
    private var timer: Timer?
    
    init(type: BannerType, message: String) {
        super.init(frame: .zero)
        setupView(type: type, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(type: BannerType, message: String) {
        // Set background color based on type
        switch type {
        case .success:
            backgroundColor = UIColor(red:0.22, green:0.80, blue:0.46, alpha:1.00)
        case .failed:
            backgroundColor = UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
        case .warning:
            backgroundColor = UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
        }
        
        // Configure message label
        messageLabel.text = message
        messageLabel.font = UIFont.poppinsMediumFontWith(size: 14)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping  // Wrap text by words
        addSubview(messageLabel)
        
        // Set constraints for message label
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func show(in view: UIView, duration: TimeInterval) {
        guard let window = getKeyWindow() else { return }
        
        // Add the banner to the window to ensure it's above all other views
        window.addSubview(self)
        
        // Set constraints to use safe area and dynamic height
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor),
            topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor),
            // No fixed height, allow it to adjust based on content
        ])
        
        // Animate banner sliding down quickly
        window.layoutIfNeeded()
        transform = CGAffineTransform(translationX: 0, y: -frame.height)
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = .identity
        }) { _ in
            self.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func hide() {
        // Animate banner sliding up quickly
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func getKeyWindow() -> UIWindow? {
        // Get the active window scene
        let activeScene = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
        
        // Get the windows from the active window scene
        if let windowScene = activeScene as? UIWindowScene {
            return windowScene.windows.first { $0.isKeyWindow }
        }
        
        return nil
    }
}
