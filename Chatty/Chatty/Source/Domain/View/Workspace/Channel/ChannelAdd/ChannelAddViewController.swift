//
//  ChannelAddViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChannelAddViewController: BaseViewController {
    
    var workspaceID: Int?

    private let mainView = ChannelAddView()
    
    private let viewModel = ChannelAddViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        bind()
    }
    
    private func bind() {
        
        let input = ChannelAddViewModel.Input(
            xButton: mainView.xButton.rx.tap,
            nameTextField: mainView.nameTextField.rx.text.orEmpty,
            descriptionTextField: mainView.descriptionTextField.rx.text.orEmpty,
            createButton: mainView.createButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.xButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 생성 버튼 활성화
        output.isCreateButtonValid
            .drive(with: self) { owner, isValid in
                owner.mainView.createButton.backgroundColor = isValid ? .point : .inactive
                owner.mainView.createButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // 채널 이름 유효성 검증
        output.isNameValid
            .bind(with: self) { owner, isValid in
                if isValid {
                    owner.showOkAlert(title: "채널 이름 중복", message: "워크스페이스에 이미 있는 채널 이름입니다.\n다른 이름을 입력해주세요. ")
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 생성
        output.isCreated
            .bind(with: self) { owner, isValid in
                if isValid {
                    owner.dismiss(animated: true)
                } else {
                    owner.showOkAlert(title: "Error", message: "채널 생성에 실패하였습니다.\n다시 시도해 주세요. 😢")
                }
            }
            .disposed(by: disposeBag)
    }
    

}
