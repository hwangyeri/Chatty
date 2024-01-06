//
//  AuthView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit
import SnapKit
import Then

final class AuthView: BaseView {
    
    let appleLoginButton = CImageButton(imageName: "AppleLogin")
    
    let kakaoLoginButton = CImageButton(imageName: "KakaoLogin")
    
    let emailLoginButton = UIButton().then {
        $0.backgroundColor = .point
        $0.setTitle(" 이메일로 계속하기", for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
        $0.setImage(.emailIcon, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    let orLabel = CLabel(text: "또는", custFont: .title2)
    
    let joinTextButton = UIButton().then {
        $0.setTitle("새롭게 회원가입 하기", for: .normal)
        $0.setTitleColor(.point, for: .normal)
        $0.titleLabel?.font = .customFont(.title2)
    }
    
    override func configureHierarchy() {
        [appleLoginButton, kakaoLoginButton, emailLoginButton, orLabel, joinTextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(42)
            make.horizontalEdges.equalToSuperview().inset(35)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(appleLoginButton)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(appleLoginButton)
            make.height.equalTo(44)
        }
        
        joinTextButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(10)
        }
        
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(joinTextButton).offset(2)
            make.trailing.equalTo(joinTextButton.snp.leading).offset(-5)
        }
    }
}
