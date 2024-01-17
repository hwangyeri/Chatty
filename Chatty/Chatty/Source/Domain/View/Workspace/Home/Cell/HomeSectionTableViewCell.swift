//
//  HomeSectionTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeSectionTableViewCell: BaseTableViewCell {

    let titleLabel = CLabel(text: "채널", custFont: .title2)
    
    let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: Constants.chevronRight)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        [titleLabel, chevronImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(13)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(22)
        }
    }

}
