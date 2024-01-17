//
//  SideMenuView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/14.
//

import UIKit
import SnapKit
import Then

final class SideMenuView: BaseView {
    
    let titleLabel = CLabel(text: "워크스페이스", custFont: .title1)
    
    let divider = CDivider()
    
    let emptyView = UIView()
    
    let mainLabel = CLabel(text: "워크스페이스를\n찾을 수 없어요.", custFont: .title1).then {
        $0.textAlignment = .center
    }
    
    let subLabel = CLabel(text: "관리자에게 초대를 요청하거나,\n다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.", custFont: .body).then {
        $0.textAlignment = .center
    }
    
    let createButton = CButton(text: "워크스페이스 생성", font: .title2).then {
        $0.backgroundColor = .point
        $0.isEnabled = true
    }
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 72
      }
    
    let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: Constants.plus)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .textSecondary
    }
    
    let wsAddButton = CTextButton(name: "워크스페이스 추가", font: .body)
    
    let helpImageView = UIImageView().then {
        $0.image = .help
        $0.contentMode = .scaleAspectFit
    }
    
    let helpButton = CTextButton(name: "도움말", font: .body)
    
    override func configureHierarchy() {
        [titleLabel, divider, emptyView, tableView, plusImageView, wsAddButton, helpImageView, helpButton].forEach {
            self.addSubview($0)
        }
        
        [mainLabel, subLabel, createButton].forEach {
            emptyView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(183)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(plusImageView.snp.top).inset(6)
        }
        
        helpImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(45)
            make.leading.equalToSuperview().inset(16)
        }
        
        helpButton.snp.makeConstraints { make in
            make.centerY.equalTo(helpImageView)
            make.leading.equalTo(helpImageView.snp.trailing).offset(16)
        }
        
        plusImageView.snp.makeConstraints { make in
            make.bottom.equalTo(helpImageView.snp.top).offset(-25)
            make.leading.equalTo(helpImageView)
        }
        
        wsAddButton.snp.makeConstraints { make in
            make.centerY.equalTo(plusImageView)
            make.leading.equalTo(plusImageView.snp.trailing).offset(16)
            make.top.equalTo(emptyView.snp.bottom)
        }
    }
    
}
