//
//  OneButtonModalViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/19.
//

import UIKit
import RxSwift
import RxCocoa

final class twoButtonModalViewController: BaseViewController {
    
    var workspaceID: Int?
    
    private let mainView = twoButtonModalView()
    
    private let viewModel = twoButtonModalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        bind()
    }
    
    override func configureLayout() {
        view.backgroundColor = .alpha
    }
    
    private func bind() {
        
        let input = twoButtonModalViewModel.Input(
            cancelButton: mainView.cancelButton.rx.tap,
            deleteButton: mainView.deleteButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 취소 버튼 탭
        output.cancelButtonTap
            .drive(with: self) { owner, _ in
                print("취소 버튼 클릭")
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 삭제 버튼 탭
        output.deleteButtonTap
            .drive(with: self) { owner, _ in
                print("삭제 버튼 클릭")
            }
            .disposed(by: disposeBag)
    }
   

}
