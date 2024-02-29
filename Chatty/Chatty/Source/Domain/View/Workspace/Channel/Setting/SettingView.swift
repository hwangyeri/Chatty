//
//  SettingView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import SnapKit
import Then

final class SettingView: BaseView {
    
    let titleLabel = CLabel(text: "채널 설정", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let backButton = CImageButton(imageName: Constants.chevronLeft)
    
    let divider = CDivider()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let mainLabel = CLabel(text: "#참깨길 123번", custFont: .title2)
    
    let subLabel = CLabel(text: "Sunny Day Sweepin' the clouds away On my way to where the air is sweet Can you tell me how to get, How to get to Sesame Street Come and play Everything's A-OK Friendly neighbors there That's where we meet Can you tell me how to get How to get to Sesame Street", custFont: .body)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
        $0.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
        $0.register(SettingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingHeaderView.identifier)
        $0.register(SettingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SettingFooterView.identifier)
        $0.backgroundColor = .backgroundPrimary
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 6
        let spacing: CGFloat = 6
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing * 3, right: spacing)
        layout.itemSize = CGSize(width: width, height: width + 30)
        return layout
    }
    
    override func configureHierarchy() {
        [titleLabel, backButton, divider, backView].forEach {
            self.addSubview($0)
        }
        
        [mainLabel, subLabel, collectionView].forEach {
            backView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(18)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(mainLabel)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
