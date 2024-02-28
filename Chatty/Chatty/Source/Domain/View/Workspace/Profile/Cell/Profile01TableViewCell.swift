//
//  ProfileTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/27.
//

import UIKit
import SnapKit
import Then

final class Profile01TableViewCell: BaseTableViewCell {
    
    let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 2
        $0.axis = .horizontal
    }

    let mainLabel = CLabel(text: "닉네임", custFont: .bodyBold)
    
    let coinLabel = CLabel(text: "130", custFont: .bodyBold).then {
        $0.textColor = .point
    }
    
    let subLabel = CLabel(text: "옹골찬 고래밥", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: Constants.chevronRight)
        $0.tintColor = .textSecondary
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        [stackView, subLabel, chevronImageView].forEach {
            contentView.addSubview($0)
        }
        
        [mainLabel, coinLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(15)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(18)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
            make.top.equalTo(mainLabel)
        }
    }

}

