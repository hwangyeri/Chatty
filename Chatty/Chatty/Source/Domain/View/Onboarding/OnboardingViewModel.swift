//
//  OnboardingViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingViewModel: BaseViewModel {
    
    struct Input {
        let startButton: ControlEvent<Void> // 시작 버튼
    }
    
    struct Output {
        let startButtonTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let startButtonTap = input.startButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
      
        return Output(
            startButtonTap: startButtonTap
        )
    }
    
}
