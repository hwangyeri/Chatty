//
//  CLabel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

final class CLabel: UILabel {
    
    init(text: String, custFont: UIFont.CustomFont) {
        super.init(frame: .zero)
       
        self.text = text
        self.font = .customFont(custFont)
        self.textColor = .black
        self.numberOfLines = 0
        self.setLineHeight(for: custFont)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Line Height(px)
    private func setLineHeight(for font: UIFont.CustomFont) {
        let lineHeight: CGFloat
        
        switch font {
        case .caption, .body, .bodyBold:
            lineHeight = 1.16
        case .title2:
            lineHeight = 1.2
        case .title1:
            lineHeight = 1.14
        case .navTitle:
            lineHeight = 1.08
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributeString.length)
        )
        
        attributedText = attributeString
    }
    
    
}

