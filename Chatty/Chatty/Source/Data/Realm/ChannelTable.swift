//
//  ChannelTable.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/16.
//

import Foundation
import RealmSwift

class ChannelTable: Object {
    
    @Persisted(primaryKey: true) var channel_id: Int // 채널 아이디
    @Persisted var workspace_id: Int // 워크스페이스 아이디
    @Persisted var channel_name: String // 채널 이름
    
    convenience init(channel_id: Int, workspace_id: Int, channel_name: String) {
        self.init()
        
        self.channel_id = channel_id
        self.workspace_id = workspace_id
        self.channel_name = channel_name
    }
    
}
