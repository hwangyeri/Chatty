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
    
    struct Input {
        let cancelButton: ControlEvent<Void> // 취소 버튼
        let deleteButton: ControlEvent<Void> // 삭제 버튼
    }
    
    struct Output {
        let cancelButtonTap: Driver<Void>
        let deleteButtonTap: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 취소 버튼 탭
        let cancelButtonTap = input.cancelButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 삭제 버튼 탭
        let deleteButtonTap = input.deleteButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            cancelButtonTap: cancelButtonTap,
            deleteButtonTap: deleteButtonTap
        )
    }
        
}
