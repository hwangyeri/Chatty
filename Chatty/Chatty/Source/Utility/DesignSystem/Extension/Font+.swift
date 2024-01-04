//
//  Font+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

extension UIFont {
    
    enum CustomFont {
        case caption
        case body
        case bodyBold
        case title2
        case title1
    }
    
    static func customFont(_ name: CustomFont) -> UIFont? {
        switch name {
        case .caption:
            return .systemFont(ofSize: 12)
        case .body:
            return .systemFont(ofSize: 13)
        case .bodyBold:
            return .boldSystemFont(ofSize: 13)
        case .title2:
            return .boldSystemFont(ofSize: 14)
        case .title1:
            return .boldSystemFont(ofSize: 22)
        }
    }
    
    
}

