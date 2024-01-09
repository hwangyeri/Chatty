//
//  CSecureTextField.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/09.
//

import UIKit

final class CSecureTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.font = .customFont(.body)
        self.placeholder = placeholder
        self.tintColor = .point
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.clearButtonMode = .whileEditing
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .lightGray
        rightView = button
        rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}



