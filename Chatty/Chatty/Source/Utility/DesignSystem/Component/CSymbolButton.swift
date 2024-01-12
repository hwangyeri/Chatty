//
//  CSymbolButton.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import UIKit

final class CSymbolButton: UIButton {
    
    init(size: CGFloat, name: String) {
        super.init(frame: .zero)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let image = UIImage(systemName: name, withConfiguration: imageConfig)
        
        self.setImage(image, for: .normal)
        self.tintColor = .white
        self.contentMode = .scaleAspectFit
        self.backgroundColor = .point
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


