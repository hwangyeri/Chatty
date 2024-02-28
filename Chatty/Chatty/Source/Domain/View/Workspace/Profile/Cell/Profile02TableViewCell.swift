//
//  Profile02TableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/27.
//

import UIKit
import SnapKit
import Then

final class Profile02TableViewCell: BaseTableViewCell {

    let mainLabel = CLabel(text: "이메일", custFont: .bodyBold)

    let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let subLabel = CLabel(text: "sesac@sesac.com", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    let imageStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    let appleIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .appleIcon
    }
    
    let kakaoIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .kakaoIcon
    }
    
    override func configureHierarchy() {
        [mainLabel, stackView].forEach {
            contentView.addSubview($0)
        }
        
        [subLabel, imageStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [appleIconView, kakaoIconView].forEach {
            imageStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        mainLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(15)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.trailing.equalToSuperview().inset(12)
            make.height.lessThanOrEqualTo(20)
        }
    }

}
