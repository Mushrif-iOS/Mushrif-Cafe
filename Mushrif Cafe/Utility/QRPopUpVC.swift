//
//  QRPopUpVC.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 05/02/25.
//

import UIKit

class QRPopUpVC: UIViewController {
    
    private let imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Setup imageView
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Layout imageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
        
        // Add tap gesture to dismiss the popup
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
}
