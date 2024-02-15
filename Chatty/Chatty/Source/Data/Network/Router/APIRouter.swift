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
    case authRefresh // 토큰 갱신 - 미구현
    
    // USER
    case usersJoin(model: JoinInput) // 회원가입
    case usersValidationEmail(email: String) // 이메일 중복 확인
    case usersLogin(model: LoginInput) // 로그인(v2)
    case usersLoginKakao(model: KakaoLoginInput) // 카카오 로그인
    case usersMy // 내 프로필 정보 조회
    
    // WORK SPACE
    case workspaceCreate(model: WorkspaceCreateInput) // 워크스페이스 생성
    case workspaceRead // 내가 속한 워크스페이스 조회
    case oneWorkspaceRead(id: Int) // 내가 속한 워크스페이스 한 개 조회
    case workspaceDelete(id: Int) // 워크스페이스 삭제 - 미구현
    
    // CHANNEL
    case channelCreate(id: Int, model: ChannelInput) // 채널 생성
    case channelsRead(id: Int) // 모든 채널 조회
    case channelsMyRead(id: Int) // 내가 속한 모든 채널 조회
    case channelsNameRead(id: Int, name: String) // 특정 채널 조회
    case channelsUnreadsChatCount(id: Int, name: String) // 읽지 않은 채널 채팅 개수
    case channelsMembers(id: Int, name: String) // 채널 멤버 조회
    case channelsChatsRead(id: Int, name: String, cursor_date: String?) // 채널 채팅 조회
    case channelsChatsCreate(id: Int, name: String, model: ChannelChatCreateInput) // 채널 채팅 생성
    
    // DMS
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
        case .channelCreate(let id, _):
            return "/v1/workspaces/\(id)/channels"
        case .channelsRead(let id):
            return "/v1/workspaces/\(id)/channels"
        case .channelsMyRead(let id):
            return "/v1/workspaces/\(id)/channels/my"
        case .channelsNameRead(let id, let name):
            return "/v1/workspaces/\(id)/channels/\(name)"
        case .channelsUnreadsChatCount(id: let id, name: let name):
            return "/v1/workspaces/\(id)/channels/\(name)/unreads"
        case .channelsMembers(let id, let name):
            return "/v1/workspaces/\(id)/channels/\(name)/members"
        case .channelsChatsRead(let id, let name, _), .channelsChatsCreate(let id, let name, _):
            return "/v1/workspaces/\(id)/channels/\(name)/chats"
        
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
        case .usersMy: return .get
        
        // WORK SPACE
        case .workspaceRead, .oneWorkspaceRead: return .get
        case .workspaceCreate: return .post
        case .workspaceDelete: return .delete
            
        // CHANNEL
        case .channelCreate, .channelsChatsCreate: return .post
        case .channelsRead, .channelsMyRead, .channelsNameRead: return .get
        case .channelsUnreadsChatCount, .channelsMembers, .channelsChatsRead: return .get
        
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
        
        default:
            return tokenHeader
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        // USER
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
            
        // CHANNEL
        case .channelCreate(_, let model):
            return [
                "name": model.name,
                "description": model.description ?? ""
            ]
        case .channelsChatsRead(_, _, let cursor?):
            return [
                "cursor_date": cursor
            ]
            
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = header
        
        switch self {
        case .workspaceCreate, .channelsChatsRead, .channelsChatsCreate:
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
        switch self {
        case .workspaceCreate(let model):
            let params: [String: Any] = [
                "name": model.name,
                "description": model.description ?? "description error",
                "image": model.image
            ]
            return makeMultipartFormData(params: params)
        case .channelsChatsCreate(_, _, let model):
            let params: [String: Any] = [
                "content": model.content,
                "files": model.files ?? []
            ]
            return makeMultipartFormData(params: params)
        default:
            return MultipartFormData()
        }
    }
    
    func makeMultipartFormData(params: [String: Any]) -> MultipartFormData {
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
        case .channelsChatsCreate(_, _, let model):
            let content = model.content.data(using: .utf8) ?? Data()
            if let files = model.files {
                for (index, file) in files.enumerated() {
                    let fileName = "chatty_channel_chat_file_\(index).jpeg"
                    let fileData = file.data(using: .utf8) ?? Data()
                    multipart.append(fileData, withName: "files", fileName: fileName, mimeType: "image/jpeg")
                }
            }
            multipart.append(content, withName: "content")
            return multipart
        default:
            return MultipartFormData()
        }
    }
    
    
}
