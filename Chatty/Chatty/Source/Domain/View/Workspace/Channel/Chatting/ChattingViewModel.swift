//
//  ChattingViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel: BaseViewModel {
    
    private let channelChatRepository = ChannelChatRepository()
    
    private let socketIOManager = SocketIOManager.shared
    
    var workspaceID: Int?
    
    var channelID: Int?
    
    var channelName: String?
    
    var channelChatData = [ChannlChat]()
    
    var lastChatDate: Date?
    
    struct Input {
        let backButton: ControlEvent<Void>
        let listButton: ControlEvent<Void>
        let plusImageButton: ControlEvent<Void> 
        let messageTextField: ControlProperty<String>
        let sendImageButton: ControlEvent<Void>
    }
    
    struct Output {
        let backButtonTap: Driver<Void>
        let listButtonTap: Driver<Void>
        let plusImageButtonTap: Driver<Void>
        let isCompletedFetch: PublishRelay<Bool> // 채널 채팅 조회 API 완료 트리거
        let isCreatedChat: PublishRelay<Bool> // 채널 채팅 생성 API 완료 트리거
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompletedFetch = PublishRelay<Bool>()
    
    let isCreatedChat = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 채널 설정 버튼 탭
        let listButtonTap = input.listButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 이미지 추가하기 버튼 탭
        let plusImageButtonTap = input.plusImageButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 보내기 버튼 탭
        input.sendImageButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.messageTextField)
            .filter { $0.count > 0 }
            .flatMapLatest { [weak self] text in
                // 채널 채팅 생성 API
                NetworkManager.shared.requestMultipart(
                    type: ChannlChat.self,
                    router: .channelsChatsCreate(id: self?.workspaceID ?? 0, name: self?.channelName ?? "", model: ChannelChatCreateInput(content: text, files: [])))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("🩵 채널 채팅 생성 API 성공")
                    dump(data)
                    
                    // 화면에 보여줄 리스트에 저장
                    owner.channelChatData.append(data)
                    
                    // Realm에 새로운 채팅 데이터 저장
                    owner.channelChatRepository.createChatData(channlChat: data, workspaceID: owner.workspaceID ?? 0)
                    
                    owner.isCreatedChat.accept(true)
                case .failure(let error):
                    print("💛 채널 채팅 생성 API 실패: \(error.errorDescription)")
                    owner.isCreatedChat.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            backButtonTap: backButtonTap,
            listButtonTap: listButtonTap, 
            plusImageButtonTap: plusImageButtonTap,
            isCompletedFetch: isCompletedFetch,
            isCreatedChat: isCreatedChat
        )
    }
    
    func fetchChannelChatData() {
        // 마지막 채팅 날짜 저장
        lastChatDate = channelChatRepository.getLastChatDate(channelID: channelID ?? 0)
        print("✅ 마지막 채팅 날짜: ", lastChatDate)
        print("✅ 마지막 채팅 날짜 toStringMy: ", lastChatDate?.toStringMy())
        
        // Realm DB에서 저장된 채팅 데이터 불러오기
        let existingChatData = channelChatRepository.fetchChatData(channelID: channelID ?? 0)
        
        // 화면에 보여줄 리스트에 저장
        existingChatData.forEach { chatData in
            self.channelChatData.append(chatData)
            print("✅ DB에서 불러온 채팅 데이터 - 리스트에 저장 : ", chatData)
        }
        
        print("✅ existingChatData.isEmpty 여부: ", existingChatData.isEmpty)
        
        // DB에 저장된 채팅 데이터 여부에 따라서
        if existingChatData.isEmpty {
            // Realm에 새로운 채팅 데이터 저장
            channelsChatsRead(cursor: "")
        } else {
            // 마지막 날짜를 기준으로 새로운 채팅 데이터 업데이트
            channelsChatsRead(cursor: lastChatDate?.toStringMy() ?? "")
        }
        
        // 소켓 열기
        openSocket()
        receiveChat()
    }
    
    // 채널 채팅 조회 API
    func channelsChatsRead(cursor: String) {
        NetworkManager.shared.request(
            type: [ChannlChat].self,
            router: .channelsChatsRead(
                id: workspaceID ?? 0,
                name: channelName ?? "",
                cursor_date: cursor
            )
        ) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 채널 채팅 조회 API 성공")
                dump(data)
                
                data.forEach { channlChat in
                    // 새로운 채팅 데이터 리스트에 추가
                    self?.channelChatData.append(channlChat)
                    print("✅ 리스트에 추가하는 새로운 채팅 데이터: ", channlChat)
                    
                    // Realm DB에 저장
                    self?.channelChatRepository.createChatData(
                        channlChat: channlChat,
                        workspaceID: self?.workspaceID ?? 0
                    )
                }
                
                self?.isCompletedFetch.accept(true)
            case .failure(let error):
                print("💛 채널 채팅 조회 API 실패: \(error.errorDescription)")
                self?.isCompletedFetch.accept(false)
            }
        }
    }
   
    
}

// MARK: Socket
extension ChattingViewModel {
    
    // 소켓 연결
    private func openSocket() {
        print(#function)
        socketIOManager.establishConnection(channelID ?? 0)
    }
    
    // 소켓 연결 해제
    func closeSocket() {
        print(#function)
        socketIOManager.closeConnection()
    }
    
    // 채팅 수신
    private func receiveChat() {
        print(#function)
        socketIOManager.receiveChat(type: ChannlChat.self) { [weak self] data in
            dump(data)
            self?.channelChatData.append(data)
            self?.isCreatedChat.accept(true)
            print("✅ 소켓 응답 - 채팅 수신")
        }
    }
    
}
