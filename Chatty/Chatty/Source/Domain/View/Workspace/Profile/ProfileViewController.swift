//
//  ProfileViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/27.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ProfileViewController: BaseViewController {
    
    private let mainView = ProfileView()
    
    private let viewModel = ProfileViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchMyProfile()
    }
    
    override func configureLayout() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func updateProfileImage() {
        if let profileImage = viewModel.myProfileData?.profileImage {
            mainView.workspaceImageButton.setImageKF(withURL: profileImage)
        }
    }
    
    private func bind() {
        
        let input = ProfileViewModel.Input(
            backButton: mainView.backButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼 탭
        output.backButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 서버 통신 완료 트리거
        output.isCompletedFetch
            .subscribe(with: self) { owner, isValid in
                print("✅ 프로필 조회 완료")
                if isValid {
                    if let profileImage = owner.viewModel.myProfileData?.profileImage {
                        owner.mainView.workspaceImageButton.setImageKF(withURL: profileImage)
                    }
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let firstSectionCell = tableView.dequeueReusableCell(withIdentifier: Profile01TableViewCell.identifier, for: indexPath) as? Profile01TableViewCell else { return UITableViewCell() }
        guard let secondSectionCell = tableView.dequeueReusableCell(withIdentifier: Profile02TableViewCell.identifier, for: indexPath) as? Profile02TableViewCell else { return UITableViewCell() }
        
        let data = viewModel.myProfileData
        let profileCellType = viewModel.profileCellType(indexPath)
        
        switch profileCellType {
        case .coinRowCell:
            firstSectionCell.mainLabel.text = "내 새싹 코인"
            firstSectionCell.coinLabel.isHidden = false
            firstSectionCell.coinLabel.text = "\(data?.sesacCoin ?? 0)"
            firstSectionCell.subLabel.text = "충전하기"
            return firstSectionCell
        case .nicknameRowCell:
            firstSectionCell.coinLabel.isHidden = true
            firstSectionCell.mainLabel.text = "닉네임"
            firstSectionCell.subLabel.text = data?.nickname
            return firstSectionCell
        case .contactRowCell:
            firstSectionCell.coinLabel.isHidden = true
            firstSectionCell.mainLabel.text = "연락처"
            firstSectionCell.subLabel.text = data?.phone
            return firstSectionCell
        case .emailRowCell:
            secondSectionCell.imageStackView.isHidden = true
            secondSectionCell.subLabel.text = data?.email
            return secondSectionCell
        case .socialRowCell:
            secondSectionCell.subLabel.isHidden = true
            secondSectionCell.mainLabel.text = "연결된 소셜 계정"
            return secondSectionCell
        case .logoutRowCell:
            secondSectionCell.stackView.isHidden = true
            secondSectionCell.mainLabel.text = "로그아웃"
            return secondSectionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModel.profileCellType(indexPath)
        
        switch cellType {
        case .coinRowCell:
            print("코인 충전 셀 클릭")
            let vc = CoinShopViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            vc.coin = viewModel.myProfileData?.sesacCoin
            present(vc, animated: true)
        case .nicknameRowCell:
            print("닉네임 셀 클릭")
        case .contactRowCell:
            print("연락처 셀 클릭")
        case .emailRowCell:
            print("이메일 셀 클릭")
        case .socialRowCell:
            print("소셜 계정 셀 클릭")
        case .logoutRowCell:
            print("로그아웃 셀 클릭")
        }
    }
    
}
