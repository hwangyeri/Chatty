//
//  HomeAddTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeAddTableViewCell: BaseTableViewCell {
    
    let imgView = UIImageView().then {
        $0.image = UIImage(systemName: Constants.plus)
        $0.tintColor = .textSecondary
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = CLabel(text: "팀원 추가", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    override func configureHierarchy() {
        [imgView, titleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imgView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
        }
    }

}
