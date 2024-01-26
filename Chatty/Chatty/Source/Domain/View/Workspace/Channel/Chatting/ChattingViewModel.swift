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
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 채널 설정 버튼 탭
        let listButtonTap = input.listButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            backButtonTap: backButtonTap, 
            listButtonTap: listButtonTap
        )
    }
    
}
