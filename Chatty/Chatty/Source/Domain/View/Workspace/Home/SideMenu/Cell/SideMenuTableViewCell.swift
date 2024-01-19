//
//  SideMenuTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/14.
//

import UIKit
import SnapKit
import Then

final class SideMenuTableViewCell: BaseTableViewCell {

    let wsImageView = UIImageView().then {
        $0.image = .dummy
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let titleLabel = CLabel(text: "Workspace Name", custFont: .body).then {
        $0.textColor = .textPrimary
    }
    
    let dateLabel = CLabel(text: "2024.01.14", custFont: .body).then {
        $0.textColor = .textSecondary
    }
    
    let menuImageButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureHierarchy() {
        [wsImageView, titleLabel, dateLabel, menuImageButton].forEach {
            contentView.addSubview($0)
        }
        
        contentView.layer.cornerRadius = 8
//        contentView.backgroundColor = .cGray
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        wsImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(wsImageView)
            make.leading.equalTo(wsImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        menuImageButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(18)
            make.trailing.equalToSuperview().inset(18)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }

}
