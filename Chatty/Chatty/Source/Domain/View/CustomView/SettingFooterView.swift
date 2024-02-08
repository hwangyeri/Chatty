//
//  SettingFooterView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/25.
//

import UIKit
import SnapKit
import Then

final class SettingFooterView: BaseCollectionReusableView {
    
    static let identifier = "SettingFooterView"
    
    let editButton = UIButton().then {
        $0.setTitle("채널 편집", for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let exitButton = UIButton().then {
        $0.setTitle("채널에서 나가기", for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let changeManagerButton = UIButton().then {
        $0.setTitle("채널 관리자 변경", for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
    }
    
    let deleteButton = UIButton().then {
        $0.setTitle("채널 삭제", for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
        $0.setTitleColor(.error, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.error.cgColor
        $0.layer.borderWidth = 1
    }
    
    override func configureHierarchy() {
        [editButton, exitButton, changeManagerButton, deleteButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(8)
            make.horizontalEdges.height.equalTo(editButton)
        }
        
        changeManagerButton.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(8)
            make.horizontalEdges.height.equalTo(editButton)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(changeManagerButton.snp.bottom).offset(8)
            make.horizontalEdges.height.equalTo(editButton)
            make.bottom.equalToSuperview().inset(10)
        }
    }
        
}
