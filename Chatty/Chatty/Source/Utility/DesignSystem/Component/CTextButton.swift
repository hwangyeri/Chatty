//
//  CTextButton.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/14.
//

import UIKit

final class CTextButton: UIButton {
    
    init(name: String, font: UIFont.CustomFont) {
        super.init(frame: .zero)
        
        self.setTitle(name, for: .normal)
        self.titleLabel?.font = .customFont(font)
        self.setTitleColor(.textSecondary, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

