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

struct KakaoLoginOutput: Codable {
    let userID: Int
    let email, nickname: String
    let profileImage, phone: String?
    let vendor, createdAt: String
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, createdAt, token
    }
}

struct Token: Codable {
    let accessToken, refreshToken: String
}
