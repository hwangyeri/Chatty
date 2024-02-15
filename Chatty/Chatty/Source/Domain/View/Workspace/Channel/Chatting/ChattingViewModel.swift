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
    
    var workspaceID: Int?
    
    var channelName: String?
    
    var channelChatData: ChannlChatOutput?
    
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
        let isCompletedFetch: PublishRelay<Bool> // 채널 채팅 조회 API 완료 트리거
        let isCreatedChat: PublishRelay<Bool> // 채널 채팅 생성 API 완료 트리거
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompletedFetch = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 채널 설정 버튼 탭
        let listButtonTap = input.listButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let isCreatedChat = PublishRelay<Bool>()
        
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
                    isCreatedChat.accept(true)
                case .failure(let error):
                    print("💛 채널 채팅 생성 API 실패: \(error.errorDescription)")
                    isCreatedChat.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            backButtonTap: backButtonTap, 
            listButtonTap: listButtonTap, 
            isCompletedFetch: isCompletedFetch, 
            isCreatedChat: isCreatedChat
        )
    }
    
    func fetchChannelsChats() {
        print(#function, "☑️ ChattingViewModel")
        
        // 채널 채팅 조회 API
        NetworkManager.shared.request(
            type: ChannlChatOutput.self,
            router: .channelsChatsRead(id: workspaceID ?? 0, name: channelName ?? "", cursor_date: "")) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 채널 채팅 조회 API 성공")
                    dump(data)
                    self?.channelChatData = data
                    self?.isCompletedFetch.accept(true)
                case .failure(let error):
                    print("💛 채널 채팅 조회 API 실패: \(error.errorDescription)")
                    self?.isCompletedFetch.accept(false)
                }
        }
    }
    
}
