//
//  KeychainManager.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import Foundation
import SwiftKeychainWrapper

final class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() { }
    
    private struct KeychainKeys {
        static let accessTokenKey: String = "User.AccessToken.Key"
        static let refreshTokenKey: String = "User.RefreshToken.Key"
    }
    
    var accessToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainKeys.accessTokenKey) //Keychain 반환
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainKeys.accessTokenKey) //Keychain 저장
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainKeys.accessTokenKey) //Keychain 삭제
            }
        }
    }
    
    var refreshToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainKeys.refreshTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainKeys.refreshTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainKeys.refreshTokenKey)
            }
        }
    }
    
    // 모든 키 삭제
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
}
