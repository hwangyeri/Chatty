//
//  SignUpView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit
import SnapKit
import Then

final class SignUpView: BaseView {
    
    let titleLabel = CLabel(text: "회원가입", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = XmarkButton()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let emailLabel = CLabel(text: "이메일", custFont: .title2)
    
    let emailBackView = CBackView()
    
    let emailTextField = CTextField(placeholder: "이메일을 입력하세요")
    
    let checkEmailButton = CButton(text: "중복 확인", font: .title2)
    
    let nicknameLabel = CLabel(text: "닉네임", custFont: .title2)
    
    let nicknameBackView = CBackView()
    
    let nicknameTextField = CTextField(placeholder: "닉네임을 입력하세요")
    
    let contactLabel = CLabel(text: "연락처", custFont: .title2)
    
    let contactBackView = CBackView()
    
    let contactTextField = CTextField(placeholder: "전화번호를 입력하세요").then {
        $0.keyboardType = .numberPad
    }
    
    let passwordLabel = CLabel(text: "비밀번호", custFont: .title2)
    
    let passwordBackView = CBackView()
    
    let passwordTextField = CSecureTextField(placeholder: "비밀번호를 입력하세요")
    
    let checkPasswordLabel = CLabel(text: "비밀번호 확인", custFont: .title2)
    
    let checkPasswordBackView = CBackView()
    
    let checkPasswordTextField = CSecureTextField(placeholder: "비밀번호를 한 번 더 입력하세요")
    
    let signUpButton = CButton(text: "가입하기", font: .title2)
    
    override func configureHierarchy() {
        [titleLabel, xButton, backView].forEach {
            self.addSubview($0)
        }
        
        [emailLabel, emailBackView, checkEmailButton, nicknameLabel, nicknameBackView, contactLabel, contactBackView, passwordLabel, passwordBackView, checkPasswordLabel, checkPasswordBackView, signUpButton].forEach {
            backView.addSubview($0)
        }
        
        emailBackView.addSubview(emailTextField)
        nicknameBackView.addSubview(nicknameTextField)
        contactBackView.addSubview(contactTextField)
        passwordBackView.addSubview(passwordTextField)
        checkPasswordBackView.addSubview(checkPasswordTextField)
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
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailBackView.snp.makeConstraints { make in
            make.leading.equalTo(emailLabel)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        checkEmailButton.snp.makeConstraints { make in
            make.top.equalTo(emailBackView)
            make.leading.equalTo(emailBackView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(24)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        nicknameBackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        contactLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        contactBackView.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nicknameBackView)
        }
        
        contactTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(contactBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        passwordBackView.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nicknameBackView)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        checkPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordBackView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailLabel)
        }
        
        checkPasswordBackView.snp.makeConstraints { make in
            make.top.equalTo(checkPasswordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(nicknameBackView)
        }
        
        checkPasswordTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    
}
