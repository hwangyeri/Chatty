//
//  OnboardingViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    
    private let mainView = OnboardingView()
    
    private let viewModel = OnboardingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        
        let input = OnboardingViewModel.Input(
            startButton: mainView.startButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.startButtonTap
            .drive(with: self) { owner, _ in
                print("시작 버튼 탭")
                let authVC = AuthViewController()
                
                if let sheet = authVC.sheetPresentationController {
                    sheet.detents = [.custom(resolver: { context in
                        return 270
                    })]
                    sheet.prefersGrabberVisible = true
                    sheet.delegate = self
                }
                
                owner.present(authVC, animated: true)
            }
            .disposed(by: disposeBag)
    }


}


extension OnboardingViewController: UISheetPresentationControllerDelegate {
    
}
