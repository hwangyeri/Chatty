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
        let createButton: ControlEvent<Void>
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            xButtonTap: xButtonTap
        )
    }
        
}
