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
    
    private func bind() {
        
        let input = AuthViewModel.Input(
            appleLoginButton: mainView.appleLoginButton.rx.tap,
            kakaoLoginButton: mainView.kakaoLoginButton.rx.tap,
            emailLoginButton: mainView.emailLoginButton.rx.tap,
            joinTextButton: mainView.joinTextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        
    }
    
    

}
