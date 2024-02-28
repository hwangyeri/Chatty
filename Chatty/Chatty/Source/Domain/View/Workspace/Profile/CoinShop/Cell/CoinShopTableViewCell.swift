//
//  CoinShopTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/28.
//

import UIKit
import SnapKit
import Then

final class CoinShopTableViewCell: BaseTableViewCell {

    let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 3
        $0.axis = .horizontal
    }

    let mainLabel = CLabel(text: "🌱 현재 보유한 코인", custFont: .bodyBold)
    
    let coinLabel = CLabel(text: "330개", custFont: .bodyBold).then {
        $0.textColor = .point
    }
    
    let buttonStackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    let subLabel = CLabel(text: "코인이란?", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    let coinButton = CTextButton(name: "₩100", font: .title2).then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 8
    }
    
    override func configureHierarchy() {
        [stackView, buttonStackView].forEach {
            contentView.addSubview($0)
        }
        
        [mainLabel, coinLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [subLabel, coinButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(18)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(12)
            make.height.greaterThanOrEqualTo(18)
        }
        
        coinButton.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(28)
        }
    }


}
