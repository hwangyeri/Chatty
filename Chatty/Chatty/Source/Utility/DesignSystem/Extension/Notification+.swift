//
//  Notification+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import Foundation

enum AppNotification: String {
    case createChannelSuccess
}

extension NSNotification.Name {
    
    // 채널 생성 성공 시, 토스트 알럿
    static let createChannelSuccessToast = NSNotification.Name(AppNotification.createChannelSuccess.rawValue)
    
}
