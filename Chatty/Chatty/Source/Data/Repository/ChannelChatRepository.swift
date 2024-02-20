//
//  ChannelChatRepository.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/16.
//

import Foundation
import RealmSwift

protocol ChannelChatRepositoryType: AnyObject {
    func createChatData(channlChat: ChannlChat, workspaceID: Int)
    func fetchChatData(channelID: Int) -> [ChannlChat] 
    func getLastChatDate(channelID: Int) -> Date?
    func updateChatData(channlChat: ChannlChat, workspaceID: Int, lastChatDate: Date)
}

class ChannelChatRepository: ChannelChatRepositoryType {
    
    private let realm = try! Realm()
    
    // MARK: - DB에 새로운 채팅 데이터를 저장하는 메서드
    func createChatData(channlChat: ChannlChat, workspaceID: Int) {
        print(#function)
        
        /// * DB에 저장하려는 채팅이 이미 존재하는지 확인하는 작업
        /// 1. DB 채널 존재 여부 확인 -> 없는 채널인 경우 추가
        /// 2. DB 유저 존재 여부 확인 -> 없는 유저인 경우 추가
        /// 3. DB 채팅 정보 저장
        
        // chat_id 기준으로 필터링
        let existingChat = realm.objects(ChattingTable.self).filter("chat_id == %@", channlChat.chatID).first
         
        // DB에 이미 존재하는 채널 채팅인지 확인
        if existingChat != nil {
            print("✅ 이미 존재하는 채널 채팅입니다.")
            return
        }
        
        do {
            try realm.write {
                
                // 1. DB에 이미 존재하는 채널인지 확인 작업
                let channelID = channlChat.channelID
                let existingChannel = realm.object(ofType: ChannelTable.self, forPrimaryKey: channelID)
                
                if existingChannel == nil {
                    // 새로운 채널인 경우, 저장
                    let newChannel = ChannelTable(
                        channel_id: channlChat.channelID,
                        workspace_id: workspaceID,
                        channel_name: channlChat.channelName
                    )
                    
                    realm.add(newChannel)
                }
                
                // 2. DB에 이미 존재하는 유저인지 확인 작업
                let userID = channlChat.user.userID
                let existingUser = realm.object(ofType: UserTable.self, forPrimaryKey: userID)
                
                if existingUser == nil {
                    // 새로운 유저인 경우, 저장
                    let newUser = UserTable(
                        user_id: channlChat.user.userID,
                        user_nickname: channlChat.user.nickname,
                        user_email: channlChat.user.email,
                        user_image: channlChat.user.profileImage
                    )
                    
                    realm.add(newUser)
                }
                
                // 3. 새로운 채널 채팅 정보 저장하기
                let fileList = List<String>()
                fileList.append(objectsIn: channlChat.files ?? [])
                
                let newChatting = ChattingTable(
                    chat_id: channlChat.chatID,
                    channel: realm.object(ofType: ChannelTable.self, forPrimaryKey: channelID),
                    user: realm.object(ofType: UserTable.self, forPrimaryKey: userID),
                    content: channlChat.content,
                    createdAt: channlChat.createdAt.toDate() ?? Date(),
                    files: fileList
                )
                
                realm.add(newChatting)
                
                print("🩵 새로운 채팅 채널 데이터가 성공적으로 저장되었습니다.")
            }
        } catch {
            print("Realm Create Error")
            print(error)
        }
    }
    
    // MARK: - DB에 저장된 채팅 데이터를 불러오는 메서드
    func fetchChatData(channelID: Int) -> [ChannlChat] {
        print(#function, "채널 ID: ", channelID)
        let chatData = realm.objects(ChattingTable.self)
            .filter("channel.channel_id == %@", channelID)
            .sorted(byKeyPath: "createdAt", ascending: true)
        
        // ChattingTable -> ChannlChat으로 변환
        let convertedData = chatData.map { chatTable in
            return ChannlChat(
                channelID: chatTable.channel?.channel_id ?? 0,
                chatID: chatTable.chat_id,
                channelName: chatTable.channel?.channel_name ?? "",
                content: chatTable.content,
                createdAt: chatTable.createdAt.toStringMy(),
                files: [],
                user: User(
                    userID: chatTable.user?.user_id ?? 0,
                    email: chatTable.user?.user_email ?? "",
                    nickname: chatTable.user?.user_nickname ?? "",
                    profileImage: chatTable.user?.user_image
                )
            )
        }
        
        return Array(convertedData)
    }
    
    // MARK: - DB에 저장된 채팅의 마지막 날짜를 확인하는 메서드
    func getLastChatDate(channelID: Int) -> Date? {
        print(#function, "채널 ID: ", channelID)
        guard let lastChat = realm.objects(ChattingTable.self)
            .filter("channel.channel_id == %@", channelID)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .first else {
            print("💛 마지막 날짜 확인 실패: nil 값 리턴함.")
            return nil
        }
        
        print("🩵 마지막 날짜 확인 성공: \(lastChat.createdAt)")
        return lastChat.createdAt
    }
    
    // MARK: - 새로운 채팅 데이터 업데이트 해주는 메서드
    func updateChatData(channlChat: ChannlChat, workspaceID: Int, lastChatDate: Date) {
        print(#function, "마지막 날짜: ", lastChatDate)
        if lastChatDate >= channlChat.createdAt.toDate() ?? Date() {
            let fileList = List<String>()
            fileList.append(objectsIn: channlChat.files ?? [])
            
            let newChatting = ChattingTable(
                chat_id: channlChat.chatID,
                channel: ChannelTable(
                    channel_id: channlChat.channelID,
                    workspace_id: workspaceID,
                    channel_name: channlChat.channelName
                ),
                user: UserTable(
                    user_id: channlChat.user.userID,
                    user_nickname: channlChat.user.nickname,
                    user_email: channlChat.user.email,
                    user_image: channlChat.user.profileImage
                ),
                content: channlChat.content,
                createdAt: channlChat.createdAt.toDate() ?? Date(),
                files: fileList
            )
            
            do {
                try realm.write {
                    realm.add(newChatting, update: .modified)
                    print("🩵 새로운 채팅 데이터 업데이트 성공")
                }
            } catch {
                print("💛 Realm Update Error")
                print(error)
            }
        }
    }
    
    
}

