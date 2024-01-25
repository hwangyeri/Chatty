//
//  ChannelSearchViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChannelSearchViewController: BaseViewController {
    
    var workspaceID: Int?
    
    private let mainView = ChannelSearchView()
    
    private let viewModel = ChannelSearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        viewModel.fetchAllChannels()
        bind()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func bind() {
        
        let input = ChannelSearchViewModel.Input(
            xButton: mainView.xButton.rx.tap,
            itemSelected: mainView.tableView.rx.itemSelected
        )
        
        let output = viewModel.transform(input: input)
        
        output.xButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 네트워크 통신 완료 트리거
        output.isCompletedFetch
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        // 셀 클릭 시, 내가 속한 채널인지 확인
        output.isMyChannelValid
            .bind(with: self) { owner, isValid in
                if isValid {
                    print("✅ 내가 속한 채널입니다.")
                    let vc = ChattingViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    owner.present(vc, animated: true)
                } else {
                    let vc = twoButtonModalViewController()
                    vc.modalAction = .channelJoin
                    owner.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

extension ChannelSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allChannelsData?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.identifier, for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
        let data = viewModel.allChannelsData
        
        cell.backView.isHidden = true
        cell.countLabel.isHidden = true
        cell.selectionStyle = .none
        
        cell.titleLabel.textColor = .textPrimary
        cell.titleLabel.font = .customFont(.bodyBold)
        cell.imgView.tintColor = .textPrimary
        
        cell.titleLabel.text = data?[indexPath.row].name
        
        return cell
    }
    
}
