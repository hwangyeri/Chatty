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

struct Channel: Codable {
    let workspaceID, channelID: Int
    let name: String
    let description: String?
    let ownerID, outputPrivate: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case outputPrivate = "private"
        case createdAt
    }
}


