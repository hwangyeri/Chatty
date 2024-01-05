//
//  CButton.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

final class CButton: UIButton {
    
    init(text: String, font: UIFont.CustomFont) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        self.titleLabel?.font = .customFont(font)
        self.backgroundColor = .point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
