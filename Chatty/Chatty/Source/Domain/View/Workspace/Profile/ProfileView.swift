//
//  ProfileView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/27.
//

import UIKit
import SnapKit
import Then

final class ProfileView: BaseView {
    
    let titleLabel = CLabel(text: "내 정보 수정", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let backButton = CImageButton(imageName: Constants.chevronLeft)
    
    let divider = CDivider()
    
    let backView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
    }
    
    let workspaceImageButton = CSymbolButton(size: 38, name: "message.fill")
    
    let cameraBackView = UIView().then {
        $0.backgroundColor = .point
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 13
    }
    
    let cameraImageView = UIImageView().then {
        $0.image = .camera
        $0.contentMode = .scaleAspectFit
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(Profile01TableViewCell.self, forCellReuseIdentifier: Profile01TableViewCell.identifier)
        $0.register(Profile02TableViewCell.self, forCellReuseIdentifier: Profile02TableViewCell.identifier)
        $0.backgroundColor = .backgroundPrimary
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.isScrollEnabled = false
    }
    
    override func configureHierarchy() {
        [titleLabel, backButton, divider, backView].forEach {
            self.addSubview($0)
        }
        
        [workspaceImageButton, cameraBackView, tableView].forEach {
            backView.addSubview($0)
        }
        
        cameraBackView.addSubview(cameraImageView)
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
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(11)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        workspaceImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraBackView.snp.makeConstraints { make in
            make.bottom.equalTo(workspaceImageButton).offset(5)
            make.trailing.equalTo(workspaceImageButton).offset(5)
            make.size.equalTo(26)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(-0.5)
            make.size.equalTo(14)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(workspaceImageButton.snp.bottom).offset(2)
            make.height.greaterThanOrEqualTo(300)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
