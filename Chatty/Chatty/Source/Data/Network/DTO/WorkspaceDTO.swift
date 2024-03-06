//
//  WorkspaceDTO.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/03/06.
//

import Foundation

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
