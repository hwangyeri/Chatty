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
        text: "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다",
        custFont: .title1
    ).then {
        $0.textAlignment = .center
    }
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "TeamWork")
        $0.contentMode = .scaleAspectFit
    }
    
    let startButton = CButton(text: "시작하기", font: .title2)
    
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
            make.size.equalTo(320)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(45)
            make.height.equalTo(44)
        }
    }
    
}
