//
//  HomeViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    
    struct Input {
        let wsNameButton: ControlEvent<Void> // 워크스페이스 이름 버튼
        let myProfileButton: ControlEvent<Void> // 내 프로필 버튼
        let createButton: ControlEvent<Void> // 워크스페이스 생성 버튼
        let postButton: ControlEvent<Void> // 작성하기 버튼
    }
    
    struct Output {
        let wsNameButtonTap: Driver<Void>
        let myProfileButtonTap: Driver<Void>
        let createButtonTap: Driver<Void>
        let postButtonTap: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 워크스페이스 이름 탭 -> SideMenu
        let wsNameButtonTap = input.wsNameButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 내 프로필 버튼 탭
        let myProfileButtonTap = input.myProfileButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 워크스페이스 생성하기 버튼 탭
        let createButtonTap = input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 작성하기 버튼 텝
        let postButtonTap = input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            wsNameButtonTap: wsNameButtonTap, 
            myProfileButtonTap: myProfileButtonTap, 
            createButtonTap: createButtonTap, 
            postButtonTap: postButtonTap
        )
    }
    
}
