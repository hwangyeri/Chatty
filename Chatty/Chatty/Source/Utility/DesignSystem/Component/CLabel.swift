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
        self.textColor = .textPrimary
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
        case .pretendardRegularS, .pretendardRegularM, .pretendardBoldS:
            lineHeight = 18
        case .pretendardBoldM:
            lineHeight = 20
        case .pretendardBoldL:
            lineHeight = 30
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        let attributeString = NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributeString.length)
        )
        
        attributedText = attributeString
    }
    
    
}

