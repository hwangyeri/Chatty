//
//  ChattingViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingViewController: BaseViewController {
    
    var workspaceID: Int?
    
    var channelName: String?
    
    private let mainView = ChattingView()
    
    private let viewModel = ChattingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        viewModel.channelName = channelName
        viewModel.fetchChannelsChats()
        bind()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.messageTextView.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    private func bind() {
        
        let input = ChattingViewModel.Input(
            backButton: mainView.backButton.rx.tap,
            listButton: mainView.listButton.rx.tap,
            plusImageButton: mainView.plusImageButton.rx.tap,
            messageTextField: mainView.messageTextView.rx.text.orEmpty,
            sendImageButton: mainView.sendImageButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼 탭
        output.backButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 리스트 버튼 탭
        output.listButtonTap
            .drive(with: self) { owner, _ in
                let vc = SettingViewController()
                vc.workspaceID = owner.viewModel.workspaceID
                vc.channelName = owner.viewModel.channelName
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 채널 채팅 조회 API 완료
        output.isCompletedFetch
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.mainView.tableView.reloadData()
                } else {
                    owner.showOkAlert(title: "Error", message: "에러가 발생했어요. 😥\n다시 시도해 주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 채팅 생성 API 완료
        output.isCreatedChat
            .subscribe(with: self) { owner, isValid in
                owner.mainView.messageTextView.text = nil
                if isValid {
                    owner.viewModel.fetchChannelsChats()
                } else {
                    owner.showOkAlert(title: "Error", message: "에러가 발생했어요. 😥\n다시 시도해 주세요.")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.channelChatData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell else { return UITableViewCell() }
        let data = viewModel.channelChatData?[indexPath.row]
        
        cell.selectionStyle = .none
        cell.messageLabel.text = data?.content
        cell.nameLabel.text = data?.user.nickname
        cell.dateLabel.text = Date.DTFormatter(data?.createdAt ?? "")
        
        return cell
    }
    
}

extension ChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageImageCollectionViewCell.identifier, for: indexPath) as? MessageImageCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}

extension ChattingViewController: UITextViewDelegate {
    
    // placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .textSecondary else { return }
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = .textSecondary
        }
    }
    
}
