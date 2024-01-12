//
//  InitialViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import Foundation
import RxSwift
import RxCocoa

final class InitialViewModel: BaseViewModel {
    
    struct Input {
        let xButton: ControlEvent<Void>
        let createButton: ControlEvent<Void> // 워크스페이스 생성 버튼
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
        let createButtonTap: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 워크스페이스 생성 버튼
        let createButtonTap = input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            xButtonTap: xButtonTap, 
            createButtonTap: createButtonTap
        )
    }
        
}
