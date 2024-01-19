//
//  UserDefaults+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import Foundation

extension UserDefaults {
    
    static let userNicknameKey = "userNickname"
    
    // 유저 닉네임
    var userNickname: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaults.userNicknameKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.userNicknameKey)
        }
    }
    
}
