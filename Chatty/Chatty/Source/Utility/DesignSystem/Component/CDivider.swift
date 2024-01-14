//
//  CDivider.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit

final class CDivider: UIView {
    
    init() {
        super.init(frame: .zero)
       
        self.backgroundColor = .viewSeperator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
