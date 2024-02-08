//
//  SettingViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SettingViewController: BaseViewController {
    
    var workspaceID: Int?
    
    var channelName: String?
    
    private var isMemberHidden = false
    
    private let mainView = SettingView()
    
    private let viewModel = SettingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.workspaceID = workspaceID
        viewModel.channelName = channelName
        viewModel.fetchChannelMember()
        bind()
    }
    
    override func configureLayout() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        // header 고정
        if let flowLayout = mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    private func bind() {
        
        let input = SettingViewModel.Input(
            backButton: mainView.backButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 뒤로가기 버튼 탭
        output.backButtonTap
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 네트워크 통신 완료 트리거
        output.isCompletedFetch
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.mainView.collectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func headerTapped() {
        print("header 클릭")
        
        isMemberHidden.toggle()
        mainView.collectionView.reloadSections(IndexSet(integer: 0))
    }

}

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier, for: indexPath) as? SettingHeaderView else { return SettingHeaderView() }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(headerTapped))
            header.addGestureRecognizer(tapGestureRecognizer)
            header.isUserInteractionEnabled = true
            
            return header
        } else {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SettingFooterView.identifier, for: indexPath) as? SettingFooterView else { return SettingFooterView() }
            
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && isMemberHidden {
            return 0
        } else {
            return viewModel.membersData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.identifier, for: indexPath) as? SettingCollectionViewCell else { return UICollectionViewCell() }
        let data = viewModel.membersData?[indexPath.item]
        
        if data?.profileImage != nil, let profileImage = data?.profileImage {
            cell.imgView.setImageKF(withURL: profileImage) { result in
                switch result {
                case .success(_):
                    print("🩵 이미지 로드 성공")
                case .failure(let error):
                    print("💛 이미지 로드 실패: \(error)")
                }
            }
        } else {
            let noPhotoImages: [UIImage] = [.noPhotoA, .noPhotoB, .noPhotoC]
            cell.imgView.image = noPhotoImages.randomElement()
        }
        
        cell.nameLabel.text = data?.nickname
        
        return cell
    }
    
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
    
}
