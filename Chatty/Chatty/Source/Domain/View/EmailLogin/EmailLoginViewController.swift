//
//  EmailLoginViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import UIKit
import RxSwift
import RxCocoa

final class EmailLoginViewController: BaseViewController {
    
    private let mainView = EmailLoginView()
    
    private let viewModel = EmailLoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    private func bind() {
        
        let input = EmailLoginViewModel.Input(
            xButton: mainView.xButton.rx.tap,
            emailTextField: mainView.emailTextField.rx.text.orEmpty,
            passwordTextField: mainView.passwordTextField.rx.text.orEmpty,
            loginButton: mainView.loginButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 나가기 버튼
        output.xButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 로그인 버튼 활성화
        output.isLoginButtonValid
            .drive(with: self) { owner, isValid in
                owner.mainView.loginButton.backgroundColor = isValid ? .point : .inactive
                owner.mainView.loginButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // 유효성 검증 결과 UI 업데이트
        output.isValidArray
            .bind(with: self) { owner, isValid in
                print("로그인 버튼 클릭")
                
                let labels = [
                    owner.mainView.emailLabel,
                    owner.mainView.passwordLabel
                ]
                
                zip(labels, isValid).forEach { label, isValid in
                    label.textColor = isValid ? .textPrimary : .error
                }
            }
            .disposed(by: disposeBag)
        
        // 로그인 결과
        output.isLoginValid
            .bind(with: self) { owner, isValid in
                if isValid {
                    print("🩵 로그인 성공!")
                    let vc = SwitchViewController()
                    vc.workspaceID = owner.viewModel.workspaceID
                    ChangeRootVCManager.shared.changeRootVC(vc)
                } else {
                    print("💛 로그인 실패...")
                    let signUpButtonTopY = owner.mainView.loginButton.frame.origin.y
                    owner.showToast(message: "이메일 또는 비밀번호가 올바르지 않습니다.", y: signUpButtonTopY)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
