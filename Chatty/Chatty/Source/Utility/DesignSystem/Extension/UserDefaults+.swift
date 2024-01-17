//
//  UserDefaults+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import Foundation

extension UserDefaults {
    
    static let userNicknameKey = "userNickname"
    static let workspaceIDKey = "workspaceID"
    static let workspaceNameKey = "workspaceName"
    
    // 유저 닉네임
    var userNickname: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaults.userNicknameKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.userNicknameKey)
        }
    }
    
    // 워크스페이스 아이디
    var workspaceID: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaults.workspaceIDKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaults.workspaceIDKey)
        }
    }
   
    
}
