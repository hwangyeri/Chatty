//
//  HomeView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
    
    let wsImageView = UIImageView().then {
        $0.image = .dummy
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let wsNameButton = CTextButton(name: "Workspace Name", font: .title1).then {
        $0.setTitleColor(.black, for: .normal)
    }
    
    let myProfileButton = CImageButton(imageName: "Dummy").then {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.viewSelected.cgColor
    }
    
    let divider1 = CDivider()
    
    let divider2 = CDivider()
    
    let emptyView = UIView()
    
    let mainLabel = CLabel(text: "워크스페이스를 찾을 수 없어요.", custFont: .title1).then {
        $0.textAlignment = .center
    }
    
    let subLabel = CLabel(text: "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요.", custFont: .body).then {
        $0.textAlignment = .center
    }
    
    let emptyImageView = UIImageView().then {
        $0.image = .homeEmpty
        $0.contentMode = .scaleAspectFit
    }
    
    let createButton = CButton(text: "워크스페이스 생성", font: .title2).then {
        $0.backgroundColor = .point
        $0.isEnabled = true
    }
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(HomeSectionTableViewCell.self, forCellReuseIdentifier: HomeSectionTableViewCell.identifier)
        $0.register(HomeChannelTableViewCell.self, forCellReuseIdentifier: HomeChannelTableViewCell.identifier)
        $0.register(HomeDMTableViewCell.self, forCellReuseIdentifier: HomeDMTableViewCell.identifier)
        $0.register(HomePlusTableViewCell.self, forCellReuseIdentifier: HomePlusTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
      }
    
    let postButton = CImageButton(imageName: "messageCustom").then {
        $0.backgroundColor = .point
        $0.layer.cornerRadius = 26.5
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 7.6
        $0.layer.shadowOffset = CGSize(width: 0, height: 3.8)
    }
    
    override func configureHierarchy() {
        [wsImageView, wsNameButton, myProfileButton, divider1, emptyView, tableView, divider2].forEach {
            self.addSubview($0)
        }
        
        [mainLabel, subLabel, emptyImageView, createButton].forEach {
            emptyView.addSubview($0)
        }
        
        tableView.addSubview(postButton)
    }
    
    override func configureLayout() {
        wsImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(52) // 클릭 안됨
            make.top.equalTo(self.safeAreaLayoutGuide).offset(-25)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        wsNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(wsImageView)
            make.leading.equalTo(wsImageView.snp.trailing).offset(8)
        }
        
        myProfileButton.snp.makeConstraints { make in
            make.top.equalTo(wsImageView)
            make.leading.greaterThanOrEqualTo(wsNameButton.snp.trailing).priority(5)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        divider1.snp.makeConstraints { make in
            make.top.equalTo(myProfileButton.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(35)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(mainLabel)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(270)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(45)
            make.horizontalEdges.equalTo(mainLabel)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        postButton.snp.makeConstraints { make in
            //FIXME: 위치 변경
            //make.trailing.equalToSuperview().inset(16)
            //make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview().offset(150)
            make.centerY.equalToSuperview().offset(280)
            make.size.equalTo(54)
        }
        
        divider2.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
}
