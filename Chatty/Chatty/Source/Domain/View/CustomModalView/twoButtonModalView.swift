//
//  OneButtonModalView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/19.
//

import UIKit
import SnapKit
import Then

final class twoButtonModalView: BaseView {
    
    let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    let mainLabel = CLabel(text: "워크스페이스 삭제", custFont: .title2).then {
        $0.textAlignment = .center
    }
    
    let subLabel = CLabel(text: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", custFont: .body).then {
        $0.textAlignment = .center
    }
    
    let cancelButton = CButton(text: "취소", font: .title2).then {
        $0.isEnabled = true
    }
    
    let rightButton = CButton(text: "삭제", font: .title2).then {
        $0.backgroundColor = .point
        $0.isEnabled = true
    }
    
    override func configureHierarchy() {
        addSubview(backView)
        
        [mainLabel, subLabel, cancelButton, rightButton].forEach {
            backView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(mainLabel)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(16)
            make.leading.equalTo(mainLabel)
            make.height.equalTo(44)
            make.width.equalTo(rightButton).multipliedBy(1)
            make.bottom.equalToSuperview().inset(16)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.size.equalTo(cancelButton)
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            make.trailing.equalTo(mainLabel)
        }
    }
    
    
}
