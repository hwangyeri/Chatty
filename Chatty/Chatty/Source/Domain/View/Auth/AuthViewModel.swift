//
//  AuthViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import Foundation
import RxSwift
import RxCocoa

final class AuthViewModel: BaseViewModel {
    
    struct Input {
        let appleLoginButton: ControlEvent<Void> // 애플 로그인 버튼
        let emailLoginButton: ControlEvent<Void> // 이메일 로그인 버튼
        let joinTextButton: ControlEvent<Void> // 회원가입 버튼
    }
    
    struct Output {
        let appleLoginButtonTap: Driver<Void>
        let emailLoginButtonTap: Driver<Void>
        let joinTextButtonTap: Driver<Void>
    }
    
//    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let appleLoginButtonTap = input.appleLoginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let emailLoginButtonTap = input.emailLoginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let joinTextButtonTap = input.joinTextButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            appleLoginButtonTap: appleLoginButtonTap,
            emailLoginButtonTap: emailLoginButtonTap,
            joinTextButtonTap: joinTextButtonTap
        )
    }
    
    
}
