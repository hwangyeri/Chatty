//
//  ChattingView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import SnapKit
import Then

final class ChattingView: BaseView {
    
    let titleLabel = CLabel(text: "#그냥 떠들고 싶을 때 14", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let backButton = CImageButton(imageName: Constants.chevronLeft)
    
    let listButton = CImageButton(imageName: "list")
    
    let divider = CDivider()
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
    }
    
    let messageBackView = CBackView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let plusImageButton = CImageButton(imageName: "plus")
    
    let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 4
        $0.axis = .vertical
    }
   
    let messageTextView = UITextView().then {
        $0.text = "메세지를 입력하세요"
        $0.font = .customFont(.body)
        $0.textColor = .textSecondary
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.backgroundColor = .backgroundPrimary
        $0.showsVerticalScrollIndicator = false
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
        $0.register(MessageImageCollectionViewCell.self, forCellWithReuseIdentifier: MessageImageCollectionViewCell.identifier)
        $0.backgroundColor = .backgroundPrimary
        $0.isScrollEnabled = false
        $0.isHidden = true
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 6
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        return layout
    }
    
    let sendImageButton = CImageButton(imageName: "ic")
    
    override func configureHierarchy() {
        [titleLabel, backButton, listButton, divider, tableView, messageBackView].forEach {
            self.addSubview($0)
        }
        
        [plusImageButton, stackView, sendImageButton].forEach {
            messageBackView.addSubview($0)
        }
        
        [messageTextView, collectionView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(18)
        }
        
        listButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(10)
        }
        
        messageBackView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-10)
            make.height.greaterThanOrEqualTo(38)
        }
        
        plusImageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        sendImageButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(24)
            make.bottom.equalTo(plusImageButton)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(plusImageButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendImageButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(18)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
}
