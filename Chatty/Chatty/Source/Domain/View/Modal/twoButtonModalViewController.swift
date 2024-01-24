//
//  OneButtonModalViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/19.
//

import UIKit
import RxSwift
import RxCocoa

enum ModalAction {
    case channelJoin // 채널 참여
}

final class twoButtonModalViewController: BaseViewController {
    
    var modalAction: ModalAction?
    
    var workspaceID: Int?
    
    var channelName: String?
    
    private let mainView = twoButtonModalView()
    
    private let viewModel = twoButtonModalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        setLabelText()
        bind()
    }
    
    override func configureLayout() {
        view.backgroundColor = .alpha
    }
    
    private func setLabelText() {
        switch modalAction {
        case .channelJoin:
            mainView.mainLabel.text = "채널 참여"
            mainView.subLabel.text = "[\(channelName)] 채널에 참여하시겠습니까?"
            mainView.deleteButton.setTitle("확인", for: .normal)
        default:
            mainView.mainLabel.text = "워크스페이스 삭제"
            mainView.subLabel.text = "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다."
            mainView.deleteButton.setTitle("취소", for: .normal)
        }
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
