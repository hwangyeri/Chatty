//
//  SocketManager.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/20.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    // 서버에서 메시지를 주고받을 수 있게 해주는 Socket.IO의 기본 클래스
    var manager = SocketManager(socketURL: URL(string: APIKey.baseURL)!, config: [.log(true) , .compress])
   
    var socket: SocketIOClient!
    
    // 클라이언트 소켓 초기화
    private override init() {
        super.init()
        
        socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED : ", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED : ", data, ack)
        }
        
        print("✅ 소켓 초기화 완료")
    }
       
    // 소켓 연결
    func establishConnection(_ channelId: Int) {
        print(#function)
        self.closeConnection()  // 혹시 연결되어 있는 소켓이 있으면 끊어주기
        socket = self.manager.socket(forNamespace: "/ws-channel-\(channelId)")
        socket.connect()
        print("✅ 소켓 연결 시도")
    }
    
    // 소켓 연결 해제
    func closeConnection() {
        print(#function)
        socket.disconnect()
        socket.removeAllHandlers()
        print("✅ 소켓 연결 종료")
    }
    
    // 채팅 수신
    func receiveChat<T: Decodable>(
            type: T.Type,
            completion: @escaping (T) -> Void
        ) {
        print(#function)
        
        socket.on("channel") { dataArray, ack in
            guard let firstElement = dataArray.first as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: firstElement) else {
                print("💛 Error decoding socket response: Invalid JSON data format")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let socketResponse = try decoder.decode(T.self, from: jsonData)
                
                completion(socketResponse)
                
                print("CHANNEL RECEIVED", dataArray, ack)
            } catch {
                print("💛 Error decoding socket response: \(error)")
            }
        }
    }
    
    
}
