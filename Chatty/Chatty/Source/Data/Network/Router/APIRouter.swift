//
//  APIRouter.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    // AUTH
    case authRefresh // 토큰 갱신
    
    // USER
    case usersJoin(model: JoinInput) // 회원가입 - 구현
    case usersValidationEmail(email: String) // 이메일 중복 확인 - 구현
    case usersLogin(model: LoginInput) // 로그인(v2) - 구현
    case usersLoginKakao(model: KakaoLoginInput) // 카카오 로그인 - 구현
    case usersLoginApple // 애플 로그인
    case usersLogout // 로그아웃
    case usersDeviceToken // FCM device Token 저장
    case usersMy // 내 프로필 정보 조회
    
    // WORK SPACE
    case workRead // 내가 속한 워크스페이스 조회 - 구현
    
    // ... 추가 필요
    
    
    private var baseURL: URL {
        guard let url = URL(string: APIKey.baseURL) else { fatalError() }
        return url
    }
    
    private var path: String {
        switch self {
        // AUTH
        case .authRefresh:
            return "/v1/auth/refresh"
            
        // USER
        case .usersJoin:
            return "/v1/users/join"
        case .usersValidationEmail:
            return "/v1/users/validation/email"
        case .usersLogin:
            return "/v2/users/login"
        case .usersLoginKakao:
            return "/v1/users/login/kakao"
        case .usersLoginApple:
            return "/v1/users/login/apple"
        case .usersLogout:
            return "/v1/users/logout"
        case .usersDeviceToken:
            return "/v1/users/deviceToken"
        case .usersMy:
            return "/v1/users/my"
            
        // WORK SPACE
        case .workRead:
            return "/v1/workspaces"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        // AUTH
        case .authRefresh: return .get
            
        // USER
        case .usersJoin: return .post
        case .usersValidationEmail: return .post
        case .usersLogin: return .post
        case .usersLoginKakao: return .post
        case .usersLoginApple: return .post
        case .usersLogout: return .get
        case .usersDeviceToken: return .post
        case .usersMy: return .get
        
        // WORK SPACE
        case .workRead: return .get
        }
    }
    
    private var header: HTTPHeaders {
        let defaultHeader: HTTPHeaders = [
            Constants.sesacKey: APIKey.sesacKey,
            Constants.contentType: Constants.applicationJSON
        ]
        
        let tokenHeader: HTTPHeaders = [
            Constants.sesacKey: APIKey.sesacKey,
            Constants.contentType: Constants.applicationJSON,
            "Authorization": KeychainManager.shared.accessToken ?? ""
        ]
        
        switch self {
        // AUTH
        case .authRefresh:
            return defaultHeader
            
        // USER
        case .usersJoin, .usersValidationEmail, .usersLoginKakao, .usersLogin:
            return defaultHeader
        case .usersLoginApple:
            return defaultHeader
        case .usersLogout:
            return defaultHeader
        case .usersDeviceToken:
            return defaultHeader
        case .usersMy:
            return defaultHeader
            
        // WORK SPACE
        case .workRead:
            return tokenHeader
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .authRefresh:
            return nil
        case .usersJoin(let model):
            return [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "phone": model.phone,
                "deviceToken": model.deviceToken
            ]
        case .usersValidationEmail(let email):
            return ["email": email]
        case .usersLogin(let model):
            return [
                "email": model.email,
                "password": model.password,
                "deviceToken": model.deviceToken
            ]
        case .usersLoginKakao(let model):
            return [
                "oauthToken": model.oauthToken,
                "deviceToken": model.deviceToken,
            ]
        case .usersLoginApple:
            return nil
        case .usersLogout:
            return nil
        case .usersDeviceToken:
            return nil
        case .usersMy:
            return nil
            
        // WORK SPACE
        case .workRead:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch {
                throw NetworkError.jsonSerializationFailed
            }
        }
                
        return request
    }
    
    
}
