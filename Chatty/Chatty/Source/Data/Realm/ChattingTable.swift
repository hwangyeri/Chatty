//
//  ChattingTable.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/16.
//

import Foundation
import RealmSwift

class ChattingTable: Object {
    
    @Persisted(primaryKey: true) var chat_id: Int // 채널 아이디
    @Persisted var channel: ChannelTable?
    @Persisted var user: UserTable?
    @Persisted var content: String // 채팅 내용
    @Persisted var createdAt: Date // 생성 날짜
    @Persisted var files: List<String> // 이미지
    
    convenience init(chat_id: Int, channel: ChannelTable? = nil, user: UserTable? = nil, content: String, createdAt: Date, files: List<String>) {
        self.init()
        
        self.chat_id = chat_id
        self.channel = channel
        self.user = user
        self.content = content
        self.createdAt = createdAt
        self.files = files
    }
    
}
