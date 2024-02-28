//
//  CoinShopView.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/28.
//

import UIKit
import SnapKit
import Then

final class CoinShopView: BaseView {
    
    let titleLabel = CLabel(text: "코인샵", custFont: .navTitle).then {
        $0.textAlignment = .center
    }
    
    let backButton = CImageButton(imageName: Constants.chevronLeft)
    
    let divider = CDivider()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(CoinShopTableViewCell.self, forCellReuseIdentifier: CoinShopTableViewCell.identifier)
        $0.backgroundColor = .backgroundPrimary
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.isScrollEnabled = false
    }
    
    override func configureHierarchy() {
        [titleLabel, backButton, divider, tableView].forEach {
            self.addSubview($0)
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
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.height.greaterThanOrEqualTo(300)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
