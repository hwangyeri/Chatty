//
//  CBackView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class CBackView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

