//
//  CImageView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/26.
//

import UIKit

final class CImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
      
        self.backgroundColor = .cGray
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



