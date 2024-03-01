//
//  OnboardingSheetViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

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
            // FIXME: 필요한 데이터 저장하고 화면 전환 해주기
        }
    }
    
    private func bind() {
        
        let input = AuthViewModel.Input(
            appleLoginButton: mainView.appleLoginButton.rx.tap,
            emailLoginButton: mainView.emailLoginButton.rx.tap,
            joinTextButton: mainView.joinTextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 애플 로그인 버튼 탭
        output.appleLoginButtonTap
            .drive(with: self) { owner, _ in
                // Apple ID 승인 요청
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email, .fullName]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            }
            .disposed(by: disposeBag)
        
        // 이메일 로그인 버튼 탭
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
        
        // 회원가입 버튼 탭
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

// MARK: Apple Login
extension AuthViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 사용자 인증 실패 시
        print("💛 APPLE Login Failed \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 사용자 인증 성공 시
        let vc = SwitchViewController()
        self.present(vc, animated: true)
    }
    
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

extension AuthViewController: UISheetPresentationControllerDelegate {
    
}
