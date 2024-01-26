//
//  ChannelAddViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelAddViewModel: BaseViewModel {
    
    var workspaceID: Int?
    var channelsData: ChannelsOutput?
    
    struct Input {
        let xButton: ControlEvent<Void>
        let nameTextField: ControlProperty<String>
        let descriptionTextField: ControlProperty<String>
        let createButton: ControlEvent<Void>
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
        let isCreateButtonValid: Driver<Bool> // 생성 버튼 활성화
        let isNameValid: PublishRelay<Bool> // 채널 이름 유효성 검증 결과
        let isCreated: PublishRelay<Bool> // 채널 생성 결과
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 생성 버튼 활성화
        let isCreateButtonValid = input.nameTextField
            .map { email in
                !email.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
        
        // 채널 이름 유효성 검증 결과
        let isNameValid = PublishRelay<Bool>()
        
        // 채널 생성 결과
        let isCreated = PublishRelay<Bool>()
        
        input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.nameTextField)
            .flatMapLatest { name in
                // 특정 채널 조회 API
                NetworkManager.shared.requestSingle(
                    type: ChannelNameRead.self,
                    router: .channelsNameRead(id: self.workspaceID ?? 0, name: name)
                )
            }
            .filter { result in
                switch result {
                case .success(let data):
                    print("🩵 특정 채널 조회 API 성공")
                    dump(data)
                    // 이미 존재하는 채널 이름인 경우
                    isNameValid.accept(true)
                    return false
                case .failure(let error):
                    print("💛 특정 채널 조회 API 실패: \(error.errorDescription)")
                    return true
                }
            }
            .withLatestFrom(Observable.combineLatest(
                input.nameTextField,
                input.descriptionTextField
            ))
            .flatMapLatest { name, description in
                // 채널 생성 API
                NetworkManager.shared.requestSingle(
                    type: Channel.self,
                    router: .channelCreate(
                        id: self.workspaceID ?? 0,
                        model: ChannelInput(name: name, description: description)
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("🩵 채널 생성 API 성공")
                    dump(data)
                    NotificationCenter.default.post(name: .createChannelSuccessToast, object: nil)
                    isCreated.accept(true)
                case .failure(let error):
                    print("💛 채널 생성 API 실패: \(error.errorDescription)")
                    isCreated.accept(false)
                }
            }
            .disposed(by: disposeBag)

        
        return Output(
            xButtonTap: xButtonTap, 
            isCreateButtonValid: isCreateButtonValid,
            isNameValid: isNameValid,
            isCreated: isCreated
        )
    }
    
    
}
