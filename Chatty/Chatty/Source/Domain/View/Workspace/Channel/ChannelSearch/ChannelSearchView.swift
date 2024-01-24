//
//  ChannelSearchView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import UIKit
import SnapKit
import Then

final class ChannelSearchView: BaseView {
    
    let titleLabel = CLabel(text: "채널 탐색", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let xButton = XmarkButton()
    
    let divider = CDivider()
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(HomeChannelTableViewCell.self, forCellReuseIdentifier: HomeChannelTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 41
    }
    
    override func configureHierarchy() {
        [titleLabel, xButton, divider, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(11)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalToSuperview().inset(14)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
