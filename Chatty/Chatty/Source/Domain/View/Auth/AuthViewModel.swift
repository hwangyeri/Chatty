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
        let appleLoginButton: ControlEvent<Void>
        let kakaoLoginButton: ControlEvent<Void>
        let emailLoginButton: ControlEvent<Void>
        let joinTextButton: ControlEvent<Void>
    }
    
    struct Output {
        let appleLoginButtonTap: Driver<Void>
//        let kakaoLoginButtonTap: Driver<Void>
        let emailLoginButtonTap: Driver<Void>
        let joinTextButtonTap: Driver<Void>
    }
    
//    private let disposeBag = DisposeBag()
    
    private let kakaoLoginViewModel = SocialLoginViewModel()
    
    func transform(input: Input) -> Output {
        
        let appleLoginButtonTap = input.appleLoginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let kakaoLoginButtonTap = input.kakaoLoginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                // 1. 카카오톡 소셜 로그인
                owner.kakaoLoginViewModel.loginWithKakaoTalk()
                
                // 2. 카카오톡 로그인 정보 서버로 보내기
            }
        
        let emailLoginButtonTap = input.emailLoginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let joinTextButtonTap = input.joinTextButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            appleLoginButtonTap: appleLoginButtonTap,
//            kakaoLoginButtonTap: kakaoLoginButtonTap,
            emailLoginButtonTap: emailLoginButtonTap,
            joinTextButtonTap: joinTextButtonTap
        )
    }
    
    
}
