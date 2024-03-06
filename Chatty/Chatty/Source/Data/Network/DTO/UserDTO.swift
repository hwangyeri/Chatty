//
//  UserDTO.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/03/06.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorCode: String
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
