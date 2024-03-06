//
//  ChannelDTO.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/03/06.
//

import Foundation

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
    let content: String?
    let files: [Data]?
}
