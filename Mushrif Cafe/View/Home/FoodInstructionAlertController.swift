//
//  FoodInstructionAlertController.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 01/03/25.
//

import UIKit

class FoodInstructionAlertController: UIViewController, UITextViewDelegate {
    
    var onSave: ((String) -> Void)? // Callback to capture data
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.poppinsMediumFontWith(size: 14)
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1.0
        tv.layer.cornerRadius = 8
        tv.backgroundColor = UIColor.black60.withAlphaComponent(0.03)
        tv.textColor = UIColor.black
        tv.tintColor = UIColor.primaryBrown
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "enter_instructions".localized()
        label.font = UIFont.poppinsMediumFontWith(size: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var instructionValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        textView.delegate = self
        setupDialog()
        
        if title == "Edit" {
            textView.text = instructionValue
            
            if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                placeholderLabel.isHidden = true
            }
        } else {
            textView.text = ""
        }
    }
    
    private func setupDialog() {
        let dialogView = UIView()
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 12
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogView)
        
        let titleLabel = UILabel()
        titleLabel.text = "food_instructions".localized()
        titleLabel.font = UIFont.poppinsBoldFontWith(size: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("cancel".localized(), for: .normal)
        cancelButton.setTitleColor(UIColor.primaryBrown, for: .normal)
        cancelButton.titleLabel?.font = UIFont.poppinsSemiBoldFontWith(size: 16)
        cancelButton.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("ok".localized(), for: .normal)
        saveButton.setTitleColor(UIColor.primaryBrown, for: .normal)
        saveButton.titleLabel?.font = UIFont.poppinsSemiBoldFontWith(size: 16)
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        dialogView.addSubview(titleLabel)
        dialogView.addSubview(textView)
        textView.addSubview(placeholderLabel)
        dialogView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dialogView.widthAnchor.constraint(equalToConstant: 300),
            dialogView.heightAnchor.constraint(equalToConstant: 230),
            
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 120),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 12),
            
            buttonStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func dismissDialog() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveData() {
        let inputText = textView.text ?? ""
        onSave?(inputText) // Pass the entered data back
        dismissDialog()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
