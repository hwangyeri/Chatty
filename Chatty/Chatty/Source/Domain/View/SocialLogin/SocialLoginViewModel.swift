//
//  SocialLoginViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

final class SocialLoginViewModel {
    
    // MARK: Kakao Login
    func loginWithKakaoTalk() {
        
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            
            // 카카오톡 로그인
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print("loginWithKakaoTalk Error: ", error)
                }
                else {
                    print("loginWithKakaoTalk 카카오톡 로그인 성공")
                    _ = oauthToken
                    
                    let accessToken = oauthToken?.accessToken
                    let refreshToken = oauthToken?.refreshToken
                    
                    //print("카톡 로그인 토큰 정보 accessToken: ", accessToken)
                    //print("카톡 로그인 토큰 정보 refreshToken: ", refreshToken)
                    
                    KeychainManager.shared.accessToken = accessToken
                    KeychainManager.shared.refreshToken = refreshToken
                    
                    //print("키체인에 저장된 토큰 정보 accessToken: ", KeychainManager.shared.accessToken)
                    //print("키체인에 저장된 토큰 정보 refreshToken: ", KeychainManager.shared.refreshToken)
                }
            }
        } else {
            // 카카오톡 미설치
            print("isKakaoTalkLoginAvailable Error")
        }
    }
    
    
}
