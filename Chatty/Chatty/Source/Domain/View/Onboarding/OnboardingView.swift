//
//  OnboardingView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/04.
//

import UIKit
import SnapKit
import Then

final class OnboardingView: BaseView {
    
    let titleLabel = CLabel(
        text: "Chatty와 함께라면\n어디서나 팀을 모을 수 있어요",
        custFont: .title1
    ).then {
        $0.textAlignment = .center
    }
    
    let imageView = UIImageView().then {
        $0.image = .onboardingCustom
        $0.contentMode = .scaleAspectFit
    }
    
    let startButton = CButton(text: "시작하기", font: .title2).then {
        $0.backgroundColor = .point
        $0.isEnabled = true
    }
    
    override func configureHierarchy() {
        [titleLabel, imageView, startButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(93)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(270)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(45)
            make.height.equalTo(44)
        }
    }
    
}
