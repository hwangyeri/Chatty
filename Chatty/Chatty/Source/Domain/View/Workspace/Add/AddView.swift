//
//  AddView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import UIKit
import SnapKit
import Then

final class AddView: BaseView {
    
    let titleLabel = CLabel(text: "시작하기", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = XmarkButton()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let profileImageButton = CSymbolButton(size: 38, name: "message.fill")
    
    let cameraBackView = UIView().then {
        $0.backgroundColor = .point
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 13
    }
    
    let cameraImageView = UIImageView().then {
        $0.image = .camera
        $0.contentMode = .scaleAspectFit
    }
    
    let nameLabel = CLabel(text: "워크스페이스 이름", custFont: .title2)
    
    let nameBackView = CBackView()
    
    let nameTextField = CTextField(placeholder: "워크스페이스 이름을 입력하세요 (필수)")
    
    let explainLabel = CLabel(text: "워크스페이스 설명", custFont: .title2)
    
    let explainBackView = CBackView()
    
    let explainTextField = CTextField(placeholder: "워크스페이스를 설명하세요 (옵션)")
    
    let doneButton = CButton(text: "완료", font: .title2)
    
    override func configureHierarchy() {
        [titleLabel, xButton, backView].forEach {
            self.addSubview($0)
        }
        
        [profileImageButton, cameraBackView, nameLabel, nameBackView, explainLabel, explainBackView, doneButton].forEach {
            backView.addSubview($0)
        }
        
        cameraBackView.addSubview(cameraImageView)
        nameBackView.addSubview(nameTextField)
        explainBackView.addSubview(explainTextField)
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
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraBackView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageButton).offset(5)
            make.trailing.equalTo(profileImageButton).offset(5)
            make.size.equalTo(26)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(-0.5)
            make.size.equalTo(14)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nameBackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(nameBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        explainBackView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        explainTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalTo(nameLabel)
            make.height.equalTo(44)
        }
    }
    
}
