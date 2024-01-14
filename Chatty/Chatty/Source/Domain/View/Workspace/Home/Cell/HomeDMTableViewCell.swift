//
//  HomeDMTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeDMTableViewCell: BaseTableViewCell {
    
    let imgView = UIImageView().then {
        $0.image = UIImage(named: "Dummy")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
    }
    
    let titleLabel = CLabel(text: "일반", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    let backView = UIView().then {
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 8
    }
    
    let countLabel = CLabel(text: "99", custFont: .caption).then {
        $0.textColor = .white
    }
    
    override func configureHierarchy() {
        [imgView, titleLabel, backView].forEach {
            contentView.addSubview($0)
        }
        
        backView.addSubview(countLabel)
    }
    
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imgView.snp.trailing).offset(11)
        }
        
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).priority(8)
            make.trailing.equalToSuperview().inset(17)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(4)
            make.verticalEdges.equalToSuperview().inset(2)
        }
    }

}
