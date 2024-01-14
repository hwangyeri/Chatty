//
//  XmarkButton.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class XmarkButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        // default == X Button
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        
        self.setImage(image, for: .normal)
        self.tintColor = .black
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

