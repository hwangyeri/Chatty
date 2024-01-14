//
//  InitialViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/07.
//

import UIKit
import RxSwift
import RxCocoa

final class InitialViewController: BaseViewController {
    
    private let mainView = InitialView()
    
    private let viewModel = InitialViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func configureLayout() {
      
        mainView.subLabel.text = "\(UserDefaults.standard.userNickname ?? "userNickname is empty")님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!"
    }

    private func bind() {
        
        let input = InitialViewModel.Input(
            xButton: mainView.xButton.rx.tap,
            createButton: mainView.createButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.xButtonTap
            .drive(with: self) { owner, _ in
                let vc = SwitchViewController()
                ChangeRootVCManager.shared.changeRootVC(vc)
            }
            .disposed(by: disposeBag)
        
        // 워크스페이스 생성 버튼
        output.createButtonTap
            .drive(with: self) { owner, _ in
                let vc = AddViewController()
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
