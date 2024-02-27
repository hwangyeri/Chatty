//
//  MessageImageCollectionViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/25.
//

import UIKit
import SnapKit
import Then

final class MessageImageCollectionViewCell: BaseCollectionViewCell {
    
    let imgView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = .dummy
    }
    
    let xImageButton = CImageButton(imageName: "xIcon")
    
    override func configureHierarchy() {
        [imgView, xImageButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.8)
        }
        
        xImageButton.snp.makeConstraints { make in
            make.top.equalTo(imgView).offset(-6)
            make.trailing.equalTo(imgView).offset(6)
            make.size.equalToSuperview().multipliedBy(0.4)
        }
    }
    
}
