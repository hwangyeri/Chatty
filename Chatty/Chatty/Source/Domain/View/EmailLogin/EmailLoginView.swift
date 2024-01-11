//
//  EmailLoginView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import UIKit
import SnapKit
import Then

final class EmailLoginView: BaseView {
    
    let titleLabel = CLabel(text: "이메일 로그인", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = CSymbolButton()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let emailLabel = CLabel(text: "이메일", custFont: .title2)
    
    let emailBackView = CBackView()
    
    let emailTextField = CTextField(placeholder: "이메일을 입력하세요")
    
    let passwordLabel = CLabel(text: "비밀번호", custFont: .title2)
    
    let passwordBackView = CBackView()
    
    let passwordTextField = CSecureTextField(placeholder: "비밀번호를 입력하세요")
    
    let loginButton = CButton(text: "로그인", font: .title2)

    override func configureHierarchy() {
        [titleLabel, xButton, backView].forEach {
            self.addSubview($0)
        }
        
        [emailLabel, emailBackView, passwordLabel, passwordBackView, loginButton].forEach {
            backView.addSubview($0)
        }
        
        emailBackView.addSubview(emailTextField)
        passwordBackView.addSubview(passwordTextField)
        
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
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailBackView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        passwordBackView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
}
