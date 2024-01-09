//
//  SignUpViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/07.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    struct Input {
        let xButton: ControlEvent<Void>
        let isCheckedEmailStore: BehaviorRelay<String> // 중복 확인, 사용 가능한 이메일 저장소
        let emailTextField: ControlProperty<String>
        let checkEmailButton: ControlEvent<Void>
        let nicknameTextField: ControlProperty<String>
        let contactTextField: ControlProperty<String>
        let passwordTextField: ControlProperty<String>
        let checkPasswordTextField: ControlProperty<String>
        let signUpButton: ControlEvent<Void>
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
        let isNotEmpty: Driver<Bool> // 중복 확인 버튼 활성화
        let isSignUpButtonValid: Driver<Bool> // 가입하기 버튼 활성화
        let isSignUpValid: PublishRelay<[Bool]> // 가입하기 유효성 검증
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 중복 확인 버튼 활성화
        let isNotEmpty = input.emailTextField
            .map { $0.count > 0 } // 이메일 텍스트 빈값인지 확인
            .asDriver(onErrorJustReturn: false)
        
        let emailTextField = input.emailTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { "\($0)" }
        
        // 최종 이메일 유효성 검증
        let finalEmailValid = Observable.combineLatest(input.isCheckedEmailStore, emailTextField)
            .map { checkedEmail, inputEmail in
                // 최종적으로 유효성 검증, 중복 확인 둘다 통과한 이메일  == checkedEmail
                // 현재 이메일 텍스트필드 기입된 이메일 == inputEmail
                checkedEmail == inputEmail
            }
        
        // 닉네임 유효성 검증
        let nicknameValid = input.nicknameTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { nickname in
                let nicknameRegex = "^[0-9가-힣]{1,30}$"
                guard let _ = nickname.range(of: nicknameRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 전화번호 유효성 검증
        let contactValid = input.contactTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { contact in
                let regex = "^01[0-9]{8,9}$"
                let phoneRegex = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
                guard let _ = contact.range(of: phoneRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 비밀번호 유효성 검증
        let passwordValid = input.passwordTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { password in
                let passwordRegex = "^(?=.*[!_@$%^&+=])[A-Za-z0-9!_@$%^&+=]{8,20}$"
                guard let _ = password.range(of: passwordRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 비밀번호 확인 유효성 검증
        let checkPasswordValid = Observable.combineLatest(input.passwordTextField, input.checkPasswordTextField)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { password, checkPassword in
                guard !checkPassword.isEmpty else {
                    return false
                }
                
                return password == checkPassword
            }
        
        // 가입하기 버튼 활성화
        let isSignUpButtonValid = Observable.combineLatest(
            input.emailTextField,
            input.nicknameTextField,
            input.contactTextField,
            input.passwordTextField,
            input.checkPasswordTextField
        ).map { email, nickname, contact, password, checkPassword in
            !email.isEmpty && !nickname.isEmpty && !contact.isEmpty && !password.isEmpty && !checkPassword.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        // 가입하기 유효성 검증
        let isSignUpValid = PublishRelay<[Bool]>()
        
        input.signUpButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(
                finalEmailValid,
                nicknameValid,
                contactValid,
                passwordValid,
                checkPasswordValid
            ))
            .map { emailValid, nicknameValid, contactValid, passwordValid, checkPasswordValid in
                [emailValid, nicknameValid, contactValid, passwordValid, checkPasswordValid]
            }
            .bind(with: self) { owner, isValid in
                isSignUpValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.signUpButton
        
       
        return Output(
            xButtonTap: xButtonTap, 
            isNotEmpty: isNotEmpty, 
            isSignUpButtonValid: isSignUpButtonValid, 
            isSignUpValid: isSignUpValid
        )
    }
    
    
}


