//
//  EmailLoginViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailLoginViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    struct Input {
        let xButton: ControlEvent<Void>
        let emailTextField: ControlProperty<String>
        let passwordTextField: ControlProperty<String>
        let loginButton: ControlEvent<Void>
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
        let isLoginButtonValid: Driver<Bool> // 로그인 버튼 활성화
        let isValidArray: PublishRelay<[Bool]> // 이메일, 비밀번호 유효성 검증 배열
        let isLoginValid: PublishRelay<Bool> // 로그인 유효성 검증
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 이메일 유효성 검증
        let isEmailValid = input.emailTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { email in
                let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com$"
                guard let _ = email.range(of: emailRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 비밀번호 유효성 검증
        let isPasswordValid = input.passwordTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { password in
                let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
                guard let _ = password.range(of: passwordRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 로그인 버튼 활성화
        let isLoginButtonValid = Observable.combineLatest(
            input.emailTextField,
            input.passwordTextField
        ).map { email, password in
            !email.isEmpty && !password.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        // 로그인 조건(이메일, 비밀번호) 유효성 검증 결과를 담은 배열
        let isValidArray = PublishRelay<[Bool]>()
        
        // 로그인 유효성 검증
        let isLoginValid = PublishRelay<Bool>()
        
        // 로그인 버튼 탭
        input.loginButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(
                isEmailValid, isPasswordValid
            ))
            .map { emailValid, passwordValid in
                isValidArray.accept([emailValid, passwordValid])
                return [emailValid, passwordValid]
            }
            .filter { allValid in
                return allValid.allSatisfy { $0 == true }
            }
            .withLatestFrom(Observable.combineLatest(
                input.emailTextField,
                input.passwordTextField
            ))
            .flatMapLatest { email, password in
                // 로그인 API
                NetworkManager.shared.requestSingle(type: AuthOutput.self, router: .usersLogin(model: LoginInput(email: email, password: password, deviceToken: "temp")))
            }
            .filter { result in
                switch result {
                case .success(let data):
                    print("🩵 로그인 API 성공: \(data)")
                    // 토큰 저장
                    KeychainManager.shared.accessToken = data.token.accessToken
                    KeychainManager.shared.refreshToken = data.token.refreshToken
                    //FIXME: UserDefaults말고 다른 방식으로 값 넘겨주기
                    UserDefaults.standard.set(data.nickname, forKey: UserDefaults.userNicknameKey)
                    return true
                case .failure(let error):
                    print("💛 로그인 API 실패: \(error.errorDescription)")
                    isLoginValid.accept(false)
                    return false
                }
            }
            .flatMapLatest { _ in
                // 워크스페이스 조회 API
                NetworkManager.shared.requestSingle(type: WorkspaceOutput.self, router: .workspaceRead)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("🩵 워크스페이스 조회 API 성공: \(data)")
                    // 워크스페이스 정보 저장
                    owner.workspaceID = data[0].workspaceID
                    print("✅ workspaceID: \(owner.workspaceID)")
                    isLoginValid.accept(true)
                case .failure(let error):
                    print("💛 워크스페이스 조회 API 실패: \(error.errorDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            xButtonTap: xButtonTap,
            isLoginButtonValid: isLoginButtonValid,
            isValidArray: isValidArray,
            isLoginValid: isLoginValid
        )
    }
    
}
