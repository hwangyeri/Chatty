//
//  SettingViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    var channelName: String?
    
    var membersData: [User]?
    
    struct Input {
        let backButton: ControlEvent<Void>
    }
    
    struct Output {
        let backButtonTap: Driver<Void>
        let isCompletedFetch: PublishRelay<Bool> // 네트워크 통신 완료 트리거
    }
    
    let isCompletedFetch = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            backButtonTap: backButtonTap, 
            isCompletedFetch: isCompletedFetch
        )
    }
    
    // 채널 멤버 조회 API
    func fetchChannelMember() {
        NetworkManager.shared.request(
            type: [User].self,
            router: .channelsMembers(id: workspaceID ?? 0, name: channelName ?? "")) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 채널 멤버 조회 API 성공")
                    dump(data)
                    self?.membersData = data
                    self?.isCompletedFetch.accept(true)
                case .failure(let error):
                    print("💛 채널 멤버 조회 API 실패: \(error.errorDescription)")
                }
            }
    }
    
}
