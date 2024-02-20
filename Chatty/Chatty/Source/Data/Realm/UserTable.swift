//
//  UserTable.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/16.
//

import Foundation
import RealmSwift

class UserTable: Object {
    
    @Persisted(primaryKey: true) var user_id: Int
    @Persisted var user_nickname: String // 유저 닉네임
    @Persisted var user_email: String // 유저 이메일
    @Persisted var user_image: String? // 유저 프로필 이미지
    
    convenience init(user_id: Int, user_nickname: String, user_email: String, user_image: String? = nil) {
        self.init()
        
        self.user_id = user_id
        self.user_nickname = user_nickname
        self.user_email = user_email
        self.user_image = user_image
    }
    
}
