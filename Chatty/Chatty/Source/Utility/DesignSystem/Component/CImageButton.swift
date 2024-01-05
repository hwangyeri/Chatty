//
//  CImageButton.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

final class CImageButton: UIButton {
    
    init(imageName: String) {
        super.init(frame: .zero)
        
        self.setImage(UIImage(named: imageName), for: .normal)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


