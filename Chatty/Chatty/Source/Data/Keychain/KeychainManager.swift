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
        static let authTokenKey: String = "User.AuthToken.Key"
        static let deviceTokenKey: String = "User.DeviceToken.Key"
        static let accessTokenKey: String = "User.AccessToken.Key"
        static let refreshTokenKey: String = "User.RefreshToken.Key"
    }
    
    var authToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainKeys.authTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainKeys.authTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainKeys.authTokenKey)
            }
        }
    }
    
    var deviceToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainKeys.deviceTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainKeys.deviceTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainKeys.deviceTokenKey)
            }
        }
    }
    
    var accessToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: KeychainKeys.accessTokenKey)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: KeychainKeys.accessTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: KeychainKeys.accessTokenKey)
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
