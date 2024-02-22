//
//  twoButtonModalViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/19.
//

import Foundation
import RxSwift
import RxCocoa

final class twoButtonModalViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    var channelID: Int?
    
    var channelName: String?
    
    struct Input {
        let cancelButton: ControlEvent<Void> // 취소 버튼
        let rightButton: ControlEvent<Void> // 오른쪽 버튼
    }
    
    struct Output {
        let cancelButtonTap: Driver<Void>
        let isCompleted: PublishRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompleted = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 취소 버튼 탭
        let cancelButtonTap = input.cancelButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        // 오른쪽 버튼 탭
        input.rightButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ in
                // 채널 채팅 조회 API
                NetworkManager.shared.requestSingle(
                    type: ChannlChatOutput.self,
                    router: .channelsChatsRead(
                        id: self?.workspaceID ?? 0,
                        name: self?.channelName ?? "",
                        cursor_date: ""
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("🩵 채널 채팅 조회 API 성공")
                    dump(data)
                    owner.isCompleted.accept(true)
                case .failure(let error):
                    print("💛 채널 채팅 조회 API 실패: \(error.errorDescription)")
                    owner.isCompleted.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            cancelButtonTap: cancelButtonTap,
            isCompleted: isCompleted
        )
    }
        
}
