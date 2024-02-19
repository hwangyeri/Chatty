//
//  NetworkModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorCode: String
}

// 카카오 로그인
struct KakaoLoginInput: Decodable {
    let oauthToken: String
    let deviceToken: String
}

// 회원가입
struct JoinInput: Decodable {
    let email, password, nickname, phone: String
    let deviceToken: String
}

// 회원가입 + 로그인
struct AuthOutput: Codable {
    let userID: Int
    let email, nickname: String
    let profileImage, phone, vendor: String?
    let createdAt: String
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, createdAt, token
    }
}

// 토큰
struct Token: Codable {
    let accessToken, refreshToken: String
}

// 로그인
struct LoginInput: Codable {
    let email, password, deviceToken: String
}

// 워크스페이스
typealias WorkspaceOutput = [Workspace]

struct Workspace: Codable {
    let workspaceID: Int
    let name, thumbnail: String
    let description: String?
    let ownerID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt
    }
}

// Multipart
struct WorkspaceCreateInput: Codable {
    let name: String
    let description: String?
    let image: Data
}

// 채널
typealias ChannelsOutput = [Channel]

struct Channel: Decodable {
    let workspaceID, channelID: Int
    let name: String
    let description: String?
    let ownerID, channelPrivate: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case channelPrivate = "private"
        case createdAt
    }
}

// DM
typealias DMOutput = [DM]

struct DM: Decodable {
    let workspaceID, roomID: Int
    let createdAt: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt, user
    }
}

struct User: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

// 내 프로필 조회
struct MyProfileOutput: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage, phone, vendor: String?
    let sesacCoin: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, sesacCoin, createdAt
    }
}

// 읽지 않은 채널 채팅 개수
struct UnreadsChannelChatCount: Decodable {
    let channelID: Int
    let name: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, count
    }
}

// 읽지 않은 DM 채팅 개수
struct UnreadsDMChatCount: Decodable {
    let roomID, count: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}

// 내가 속한 워크스페이스 한 개 조회
struct OneWorkspace: Decodable {
    let workspaceID: Int
    let name, thumbnail: String
    let description: String?
    let ownerID: Int
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [User]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt, channels, workspaceMembers
    }
}

// 특정 채널 조회
struct ChannelInput: Codable {
    let name: String
    let description: String?
}

struct ChannelNameRead: Decodable {
    let workspaceID, channelID: Int
    let name: String
    let description: String?
    let ownerID, channelPrivate: Int
    let createdAt: String
    let channelMembers: [User]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case channelPrivate = "private"
        case createdAt, channelMembers
    }
}

// 채널 채팅 조회
typealias ChannlChatOutput = [ChannlChat]

struct ChannlChat: Decodable {
    let channelID, chatID: Int
    let channelName, content: String
    let createdAt: String
    let files: [String]?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case chatID = "chat_id"
        case channelName, content, createdAt, files, user
    }
}

// 채널 채팅 생성
struct ChannelChatCreateInput: Codable {
    let content: String
    let files: [String]?
}
