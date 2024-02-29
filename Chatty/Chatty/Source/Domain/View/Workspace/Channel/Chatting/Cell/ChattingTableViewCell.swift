//
//  ChattingTableViewCell.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/25.
//

import UIKit
import SnapKit
import Then

final class ChattingTableViewCell: BaseTableViewCell {
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = .dummy
    }
    
    let nameLabel = CLabel(text: "옹골찬 고래밥", custFont: .body)
    
    let contentStackView = UIStackView().then {
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 5
        $0.axis = .vertical
    }
    
    let messageBackView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.inactive.cgColor
        $0.layer.borderWidth = 1
    }
    
    let messageLabel = CLabel(
        text: "문래역 근처 맛집 추천 받습니다~\n창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠..\n맛잘알 계신가요?",
        custFont: .body
    )
    
    let imageStackView = UIStackView().then {
        $0.distribution = .fillProportionally
        $0.alignment = .top
        $0.spacing = 2
        $0.axis = .vertical
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    let firstSectionStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let secondSectionStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 2
        $0.axis = .horizontal
    }
    
    let img01 = CImageView()
    
    let img02 = CImageView()
    
    let img03 = CImageView()
    
    let img04 = CImageView()
    
    let img05 = CImageView()
    
    let dateLabel = CLabel(text: "08:16 오전", custFont: .caption2)
    
    override func configureHierarchy() {
        [profileImageView, nameLabel, contentStackView, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        [messageBackView, imageStackView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        messageBackView.addSubview(messageLabel)
        
        [firstSectionStackView, secondSectionStackView].forEach {
            imageStackView.addArrangedSubview($0)
        }
        
        [img01, img02, img03].forEach {
            firstSectionStackView.addArrangedSubview($0)
        }
        
        [img04, img05].forEach {
            secondSectionStackView.addArrangedSubview($0)
        }
    }
   
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview()
            make.size.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
            make.height.greaterThanOrEqualTo(34)
            make.bottom.equalToSuperview().inset(6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentStackView.snp.trailing).offset(8)
            make.bottom.equalTo(contentStackView).inset(2)
        }
        
        messageBackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(34)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        firstSectionStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
            make.height.equalTo(80)
        }
        
        secondSectionStackView.snp.makeConstraints { make in
            make.horizontalEdges.width.equalTo(firstSectionStackView)
            make.height.equalTo(80)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentStackView.isHidden = false
        imageStackView.isHidden = false
        firstSectionStackView.isHidden = false
        secondSectionStackView.isHidden = false
        img01.isHidden = false
        img02.isHidden = false
        img03.isHidden = false
        img04.isHidden = false
        img05.isHidden = false
    }
    
    func imageLayout(_ files: [String]) {
        print(#function, "✅ files: \(files)")
        
        let imgCount = files.count
        
        if imgCount == 0 {
            imageStackView.isHidden = true
        } else if imgCount == 1 {
            secondSectionStackView.isHidden = true
            img02.isHidden = true
            img03.isHidden = true
            img01.setImageKF(withURL: files[0])
            oneImageLayout()
        } else if imgCount == 2 {
            secondSectionStackView.isHidden = true
            img03.isHidden = true
            img01.setImageKF(withURL: files[0])
            img02.setImageKF(withURL: files[1])
            updateImageLayout()
        } else if imgCount == 3 {
            secondSectionStackView.isHidden = true
            img01.setImageKF(withURL: files[0])
            img02.setImageKF(withURL: files[1])
            img03.setImageKF(withURL: files[2])
            updateImageLayout()
        } else if imgCount == 4 {
            img03.isHidden = true
            img01.setImageKF(withURL: files[0])
            img02.setImageKF(withURL: files[1])
            img04.setImageKF(withURL: files[2])
            img05.setImageKF(withURL: files[3])
            updateImageLayout()
        } else if imgCount == 5 {
            img01.setImageKF(withURL: files[0])
            img02.setImageKF(withURL: files[1])
            img03.setImageKF(withURL: files[2])
            img04.setImageKF(withURL: files[3])
            img05.setImageKF(withURL: files[4])
            updateImageLayout()
        }
        
    }
    
    private func oneImageLayout() {
        firstSectionStackView.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
            make.height.equalTo(160)
        }
    }
    
    private func updateImageLayout() {
        firstSectionStackView.snp.updateConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
            make.height.equalTo(80)
        }
    }
    
}
