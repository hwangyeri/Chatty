//
//  OnboardingSheetViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthViewController: BaseViewController {
    
    private let mainView = AuthView()
    
    private let viewModel = AuthViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func configureLayout() {
        view.backgroundColor = .backgroundPrimary
        mainView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc func kakaoLoginButtonTapped() {
        print("카카오 로그인 버튼 탭")
        
        // 카카오 로그인
        KakaoLoginManager.shared.loginWithKakaoTalk { data in
            // 필요한 데이터 저장하고 화면 전환 해주기
        }
    }
    
    private func bind() {
        
        let input = AuthViewModel.Input(
            appleLoginButton: mainView.appleLoginButton.rx.tap,
            emailLoginButton: mainView.emailLoginButton.rx.tap,
            joinTextButton: mainView.joinTextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 이메일 로그인 버튼
        output.emailLoginButtonTap
            .drive(with: self) { owner, _ in
                let vc = EmailLoginViewController()
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.delegate = self
                }
       
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 회원가입 버튼
        output.joinTextButtonTap
            .drive(with: self) { owner, _ in
                let vc = SignUpViewController()
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.delegate = self
                }
       
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    

}


extension AuthViewController: UISheetPresentationControllerDelegate {
    
}
