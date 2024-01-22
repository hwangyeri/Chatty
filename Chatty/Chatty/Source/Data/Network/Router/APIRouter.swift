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
    case usersMy // 내 프로필 정보 조회 - 구현
    
    // WORK SPACE - 구현
    case workspaceCreate(model: WorkspaceCreateInput) // 워크스페이스 생성
    case workspaceRead // 내가 속한 워크스페이스 조회
    case oneWorkspaceRead(id: Int) // 내가 속한 워크스페이스 한 개 조회
    case workspaceDelete(id: Int) // 워크스페이스 삭제
    
    // CHANNEL - 구현
    case channelsRead(id: Int) // 모든 채널 조회
    case channelsMyRead(id: Int) // 내가 속한 모든 채널 조회
    case channelsUnreadsChatCount(id: Int, name: String) // 읽지 않은 채널 채팅 개수
    
    // DMS - 구현
    case dmsRead(id: Int) // DM 방 조회
    case dmsUnreadsChatCount(id: Int, roomID: Int) // 읽지 않은 DM 채팅 개수
    
    
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
        case .workspaceCreate, .workspaceRead:
            return "/v1/workspaces"
        case .oneWorkspaceRead(let id):
            return "/v1/workspaces/\(id)"
        case .workspaceDelete(let id):
            return "/v1/workspaces/\(id)"
            
        // CHANNEL
        case .channelsRead(let id):
            return "/v1/workspaces/\(id)/channels"
        case .channelsMyRead(let id):
            return "/v1/workspaces/\(id)/channels/my"
        case .channelsUnreadsChatCount(id: let id, name: let name):
            return "/v1/workspaces/\(id)/channels/\(name)/unreads"
        
        // DMS
        case .dmsRead(let id):
            return "/v1/workspaces/\(id)/dms"
        case .dmsUnreadsChatCount(let id, let roomID):
            return "/v1/workspaces/\(id)/dms/\(roomID)/unreads"
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
        case .workspaceRead, .oneWorkspaceRead: return .get
        case .workspaceCreate: return .post
        case .workspaceDelete: return .delete
            
        // CHANNEL
        case .channelsRead, .channelsMyRead, .channelsUnreadsChatCount: return .get
        
        // DMS
        case .dmsRead, .dmsUnreadsChatCount: return .get
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
            Constants.authorization: KeychainManager.shared.accessToken ?? ""
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
            return tokenHeader
            
        // WORK SPACE
        case .workspaceCreate, .workspaceRead, .oneWorkspaceRead, .workspaceDelete:
            return tokenHeader
            
        // CHANNEL
        case .channelsRead, .channelsMyRead, .channelsUnreadsChatCount:
            return tokenHeader
            
        // DMS
        case .dmsRead, .dmsUnreadsChatCount:
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
        case .workspaceCreate, .workspaceRead, .oneWorkspaceRead, .workspaceDelete:
            return nil
            
        // CHANNEL
        case .channelsRead, .channelsMyRead, .channelsUnreadsChatCount:
            return nil
            
        // DMS
        case .dmsRead, .dmsUnreadsChatCount:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        switch self {
        case .workspaceCreate:
            return try URLEncoding.default.encode(request, with: parameters)
        default:
            if let parameters = parameters {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = jsonData
                } catch {
                    throw NetworkError.jsonSerializationFailed
                }
            }
        }
                
        return request
    }
    
}

extension APIRouter {
    // Multipart : Alamofire에서 제공해주는 기능으로 이미지를 data로 전환해서 전송하는 방식
    
    var multipart: MultipartFormData {
        //let multipartFormData = MultipartFormData()
        
        switch self {
        case .workspaceCreate(let model):
            let params: [String: Any] = [
                "name": model.name,
                "description": model.description ?? "description error",
                "image": model.image
            ]
            
            return makeMultipartFormData(params: params, with: "workspace")
        default:
            return MultipartFormData()
        }
    }
    
    func makeMultipartFormData(params: [String: Any], with imageFileName: String) -> MultipartFormData {
        let multipart = MultipartFormData()
        
        switch self {
        case .workspaceCreate(let model):
            let name = model.name.data(using: .utf8) ?? Data()
            let description = model.description?.data(using: .utf8) ?? Data()
            let image = model.image
            
            multipart.append(name, withName: "name")
            multipart.append(description, withName: "description")
            multipart.append(image, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            // withName: key 값, fileName: 서버에 업로드할 파일 이름, mimeType: 파일 형식
            
            return multipart
        default:
            return MultipartFormData()
        }
    }
    
    
}
