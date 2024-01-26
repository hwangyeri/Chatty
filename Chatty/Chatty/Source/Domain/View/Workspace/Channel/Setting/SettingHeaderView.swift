//
//  SettingHeaderView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/25.
//

import UIKit
import SnapKit
import Then

final class SettingHeaderView: BaseCollectionReusableView {
    
    static let identifier = "SettingHeaderView"
    
    let memberLabel = CLabel(text: "멤버 ", custFont: .title2)
    
    let memberCountLabel = CLabel(text: "(14)", custFont: .title2)
    
    let imgView = UIImageView().then {
        $0.image = .chevronDown
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        [memberLabel, memberCountLabel, imgView].forEach {
            self.addSubview($0)
        }
        
        self.backgroundColor = .backgroundPrimary
    }

    override func configureLayout() {
        memberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(13)
        }
        
        memberCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(memberLabel.snp.trailing)
        }
        
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(15)
        }
    }
        
}
