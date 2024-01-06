//
//  KakaoLoginManager.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLoginManager {
    
    static let shared = KakaoLoginManager()
    
    private init() { }
    
    // MARK: Kakao Login
    func loginWithKakaoTalk(completion: @escaping (KakaoLoginOutput) -> Void) {
        
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            
            // 1. 카카오톡 로그인
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
                    
                    KeychainManager.shared.authToken = accessToken
                    KeychainManager.shared.deviceToken = refreshToken
                    
                    //print("키체인에 저장된 토큰 정보 accessToken: ", KeychainManager.shared.accessToken)
                    //print("키체인에 저장된 토큰 정보 refreshToken: ", KeychainManager.shared.refreshToken)
                    
                    let keyChainAccessToken = KeychainManager.shared.authToken ?? "authToken Error"
                    let keyChainRefreshToken = KeychainManager.shared.deviceToken ?? "refreshToken Error"
                    
                    // 2. 카카오톡 로그인 정보 서버로 보내기
                    NetworkManager.shared.request(
                        type: KakaoLoginOutput.self,
                        router: .usersLoginKakao(model: KakaoLoginInput(oauthToken: keyChainAccessToken, deviceToken: keyChainRefreshToken))) { result in
                            //print("서버로 보낸 어스 토큰 정보: ", keyChainAccessToken)
                            //print("서버로 보낸 디바이스 토큰 정보: ", keyChainRefreshToken)
                            
                            switch result {
                            case .success(let data):
                                print("카카오 로그인 정보 서버로 보내기 성공!", data)
                                
                                // 서버에서 발급 받은 토큰 저장
                                KeychainManager.shared.accessToken = data.token.accessToken
                                KeychainManager.shared.refreshToken = data.token.refreshToken
                                
                                completion(data)
                                
                            case .failure(let error):
                                print("카카오 로그인 정보 서버로 보내기 실패!", error.errorDescription)
                            }
                        }
                }
            }
        } else {
            // 카카오톡 미설치
            print("isKakaoTalkLoginAvailable Error")
        }
    }
    
    
}
