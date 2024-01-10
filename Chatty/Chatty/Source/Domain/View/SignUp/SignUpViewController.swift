//
//  SignUpViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    
    private let viewModel = SignUpViewModel()
    
    private let disposeBag = DisposeBag()
    
    // 중복 확인, 사용 가능한 이메일 저장소
    private let isCheckedEmailStore = BehaviorRelay<String>(value: "")
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func configureLayout() {
        self.view.keyboardLayoutGuide.followsUndockedKeyboard = true
        mainView.checkEmailButton.addTarget(self, action: #selector(checkEmailButtonTap), for: .touchUpInside)
    }
    
    // 이메일 중복 확인 버튼
    @objc private func checkEmailButtonTap() {
        guard let email = mainView.emailTextField.text else {
            print("emailTextField.text Error")
            return
        }
        
        let signUpButtonTopY = mainView.signUpButton.frame.origin.y
        
        let isValid = isEmailValid(email)
        
        if isValid {
            NetworkManager.shared.requestCheckEmail(router: .usersValidationEmail(email: email)) { [weak self] result in
                switch result {
                case .success(let data):
                    print("****", data)
                    self?.showToast(message: "사용 가능한 이메일입니다.", y: signUpButtonTopY)
                    self?.isCheckedEmailStore.accept(email)
                case .failure(let error):
                    print("****", error.errorDescription)
                    self?.showToast(message: "이미 사용 중인 이메일입니다.", y: signUpButtonTopY)
                }
            }
        } else {
            showToast(message: "이메일 형식이 올바르지 않습니다.", y: signUpButtonTopY)
        }
    }
    
    // 이메일 유효성 검증
    private func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func bind() {
        
        let input = SignUpViewModel.Input(
            xButton: mainView.xButton.rx.tap,
            isCheckedEmailStore: isCheckedEmailStore,
            emailTextField: mainView.emailTextField.rx.text.orEmpty,
            checkEmailButton: mainView.checkEmailButton.rx.tap,
            nicknameTextField: mainView.nicknameTextField.rx.text.orEmpty,
            contactTextField: mainView.contactTextField.rx.text.orEmpty,
            passwordTextField: mainView.passwordTextField.rx.text.orEmpty,
            checkPasswordTextField: mainView.checkPasswordTextField.rx.text.orEmpty,
            signUpButton: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 나가기 버튼
        output.xButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 중복 확인 버튼 활성화
        output.isNotEmpty
            .drive(with: self) { owner, isValid in
                owner.mainView.checkEmailButton.backgroundColor = isValid ? .point : .inactive
                owner.mainView.checkEmailButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // 가입하기 버튼 활성화
        output.isSignUpButtonValid
            .drive(with: self) { owner, isValid in
                owner.mainView.signUpButton.backgroundColor = isValid ? .point : .inactive
                owner.mainView.signUpButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // 가입하기 유효성 검증 결과 UI 반영
        output.isSignUpValid
            .bind(with: self) { owner, isValid in
                print("가입하기 버튼 클릭")
                
                let labels = [
                    owner.mainView.emailLabel,
                    owner.mainView.nicknameLabel,
                    owner.mainView.contactLabel,
                    owner.mainView.passwordLabel,
                    owner.mainView.checkPasswordLabel
                ]
                
                zip(labels, isValid).forEach { label, isValid in
                    label.textColor = isValid ? .textPrimary : .error
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}

