//
//  InitialView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/07.
//

import UIKit
import SnapKit
import Then

final class InitialView: BaseView {
    
    let titleLabel = CLabel(text: "시작하기", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = XmarkButton()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let mainLabel = CLabel(text: "출시 준비 완료!", custFont: .title1).then {
        $0.textAlignment = .center
    }
    
    let subLabel = CLabel(text: "(닉네임)님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!", custFont: .body).then {
        $0.textAlignment = .center
    }
    
    let imageView = UIImageView().then {
        $0.image = .workspaceCustom
        $0.contentMode = .scaleAspectFit
    }
    
    let createButton = CButton(text: "워크스페이스 생성", font: .title2).then {
        $0.backgroundColor = .point
        $0.isEnabled = true
    }
    
    override func configureHierarchy() {
        [titleLabel, xButton, backView].forEach {
            self.addSubview($0)
        }
        
        [mainLabel, subLabel, imageView, createButton].forEach {
            backView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalToSuperview().inset(14)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(11)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(mainLabel)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(20)
            make.size.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(45)
            make.horizontalEdges.equalTo(mainLabel)
            make.height.equalTo(44)
        }
    }

}

