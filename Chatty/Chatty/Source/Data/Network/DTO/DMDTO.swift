//
//  DMDTO.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/03/06.
//

import Foundation

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

// 읽지 않은 DM 채팅 개수
struct UnreadsDMChatCount: Decodable {
    let roomID, count: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}
