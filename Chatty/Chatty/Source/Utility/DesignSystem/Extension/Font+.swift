//
//  Font+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit

extension UIFont {
    
    enum CustomFont {
        case caption2
        case caption
        case body
        case bodyBold
        case title2
        case title1
        case navTitle
    }
    
    static func customFont(_ name: CustomFont) -> UIFont? {
        switch name {
        case .caption2:
            return .systemFont(ofSize: 11)
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
        case .navTitle:
            return .boldSystemFont(ofSize: 17)
        }
    }
    
    
}

