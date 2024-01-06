//
//  CTextField.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class CTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.font = .customFont(.body)
        self.placeholder = placeholder
        self.tintColor = .point
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.clearButtonMode = .whileEditing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


