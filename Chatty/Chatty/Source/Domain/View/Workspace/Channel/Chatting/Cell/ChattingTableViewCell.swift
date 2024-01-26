//
//  ChattingTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/25.
//

import UIKit
import SnapKit
import Then

final class ChattingTableViewCell: BaseTableViewCell {
    
    let imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = .dummy
    }
    
    let nameLabel = CLabel(text: "옹골찬 고래밥", custFont: .body)
    
    let messageBackView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.inactive.cgColor
        $0.layer.borderWidth = 1
    }
    
    let messageLabel = CLabel(
        text: "문래역 근처 맛집 추천 받습니다~\n창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠..\n맛잘알 계신가요?",
        custFont: .body
    )
    
    let dateLabel = CLabel(text: "08:16 오전", custFont: .caption2)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionLayout()).then {
        $0.register(ChattingImageCollectionViewCell.self, forCellWithReuseIdentifier: ChattingImageCollectionViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    private func configureCollectionLayout() -> UICollectionViewLayout {
        //FIXME: 채팅 이미지 레이아웃
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 25
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        
        return layout
    }
    
    override func configureHierarchy() {
        [imgView, nameLabel, messageBackView, dateLabel, collectionView].forEach {
            contentView.addSubview($0)
        }
        
        messageBackView.addSubview(messageLabel)
    }
   
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview()
            make.size.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imgView)
            make.leading.equalTo(imgView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        messageBackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
            make.width.lessThanOrEqualTo(self).multipliedBy(0.63)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(messageBackView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(messageBackView.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(dateLabel.snp.leading).offset(8)
            make.bottom.equalToSuperview().inset(6)
        }
    }

}

extension ChattingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingImageCollectionViewCell.identifier, for: indexPath) as? ChattingImageCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}
