//
//  SideMenuViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/14.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SideMenuViewController: BaseViewController {
    
    var workspaceID: Int?
    
    var workspaceData: Workspace?
    
    private let mainView = SideMenuView()
    
    private let viewModel = SideMenuViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        viewModel.fetchWorkspace()
        updateWorkspaceListUI()
        bind()
    }
    
    override func configureLayout() {
        view.layer.cornerRadius = 25
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    // 워크스페이스 여부에 따라 UI 업데이트
    private func updateWorkspaceListUI() {
        if workspaceID != nil {
            mainView.tableView.isHidden = false
            mainView.emptyView.isHidden = true
        } else {
            mainView.tableView.isHidden = true
            mainView.emptyView.isHidden = false
        }
    }
    
    private func bind() {
        
        let input = SideMenuViewModel.Input(
            wsAddButton: mainView.wsAddButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 네트워크 통신 완료 트리거
        output.isCompletedNetwork
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        // 워크스페이스 추가 버튼 탭
        output.wsAddButtonTap
            .drive(with: self) { owner, _ in
                print(" 워크스페이스 추가 버튼 클릭")
                let vc = AddViewController()
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // 메뉴 버튼 탭
    @objc func menuImageButtonTap() {
        print("메뉴 버튼 클릭")
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "워크스페이스 편집", style: .default) { [weak self] _ in
            print("워크스페이스 편집 클릭")
            let vc = AddViewController()
            vc.workspaceAction = .edit
            vc.workspaceData = self?.workspaceData
            self?.present(vc, animated: true)
        }
        
        let exitAction = UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
            print("워크스페이스 나가기 클릭")
        }
        
        let changeManagerAction = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { _ in
            print("워크스페이스 관리자 변경 클릭")
        }
        
        let deleteAction = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { [weak self] _ in
            print("워크스페이스 삭제 클릭")
            let vc = twoButtonModalViewController()
            //FIXME: 이전 화면이 배경으로 흐리게 보이게 변경하기, overCurrentContext 안됨
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(exitAction)
        actionSheet.addAction(changeManagerAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.workspaceData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else { return UITableViewCell() }
        let data = viewModel.workspaceData?[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleLabel.text = data?.name
        
        let formattedDate = data?.createdAt.toDate()?.formattedSideDate()
        cell.dateLabel.text = formattedDate
        
        if workspaceID == data?.workspaceID {
            cell.menuImageButton.isHidden = false
            cell.contentView.backgroundColor = .cGray
        } else {
            cell.menuImageButton.isHidden = true
            cell.contentView.backgroundColor = .white
        }
        
        cell.menuImageButton.addTarget(self, action: #selector(menuImageButtonTap), for: .touchUpInside)
        
        if let thumbnail = data?.thumbnail {
            cell.wsImageView.setImageKF(withURL: thumbnail) { result in
                switch result {
                case .success(_):
                    print("🩵 이미지 로드 성공")
                case .failure(let error):
                    print("💛 이미지 로드 실패: \(error)")
                }
            }
        }
        
        return cell
    }
    
}
