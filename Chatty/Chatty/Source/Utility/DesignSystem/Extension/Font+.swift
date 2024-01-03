//
//  Font+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

extension UIFont {
    
    enum CustomFont {
        case pretendardRegularS
        case pretendardRegularM
        case pretendardBoldS
        case pretendardBoldM
        case pretendardBoldL
    }
    
    static func customFont(_ name: CustomFont) -> UIFont? {
        let pretendardBold = "Pretendard-Bold"
        let pretendardRegular = "Pretendard-Regular"
        
        switch name {
        case .pretendardRegularS:
            return UIFont(name: pretendardRegular, size: 12)
        case .pretendardRegularM:
            return UIFont(name: pretendardRegular, size: 13)
        case .pretendardBoldS:
            return UIFont(name: pretendardBold, size: 13)
        case .pretendardBoldM:
            return UIFont(name: pretendardBold, size: 14)
        case .pretendardBoldL:
            return UIFont(name: pretendardBold, size: 22)
        }
    }
    
    
}

