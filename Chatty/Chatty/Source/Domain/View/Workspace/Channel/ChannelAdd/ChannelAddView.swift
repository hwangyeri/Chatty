//
//  ChannelAddView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import SnapKit
import Then

final class ChannelAddView: BaseView {
    
    let titleLabel = CLabel(text: "채널 생성", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = XmarkButton()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let nameLabel = CLabel(text: "채널 이름", custFont: .title2)
    
    let nameBackView = CBackView()
    
    let nameTextField = CTextField(placeholder: "채널 이름을 입력하세요 (필수)")
    
    let descriptionLabel = CLabel(text: "채널 설명", custFont: .title2)
    
    let descriptionBackView = CBackView()
    
    let descriptionTextField = CTextField(placeholder: "채널을 설명하세요 (옵션)")
    
    let createButton = CButton(text: "생성", font: .title2)
    
    override func configureHierarchy() {
        [titleLabel, xButton, backView].forEach {
            self.addSubview($0)
        }
        
        [nameLabel, nameBackView, descriptionLabel, descriptionBackView, createButton].forEach {
            backView.addSubview($0)
        }
        
        nameBackView.addSubview(nameTextField)
        descriptionBackView.addSubview(descriptionTextField)
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
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nameBackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        descriptionBackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }

}
