//
//  SettingCollectionViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import SnapKit
import Then

final class SettingCollectionViewCell: BaseCollectionViewCell {
    
    let imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = .dummy
    }
    
    let nameLabel = CLabel(text: "Hue", custFont: .body).then {
        $0.textAlignment = .center
    }
    
    override func configureHierarchy() {
        [imgView, nameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
}
