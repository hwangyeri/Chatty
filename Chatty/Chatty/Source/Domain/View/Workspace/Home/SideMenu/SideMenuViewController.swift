//
//  SideMenuViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/14.
//

import UIKit
import RxSwift
import RxCocoa

// 워크스페이스 여부 체크
enum CheckWorkspaceList {
    case empty
    case defaults
}

final class SideMenuViewController: BaseViewController {
    
    private let mainView = SideMenuView()
    
//    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    var checkWorkspaceList: CheckWorkspaceList?
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setWorkspaceList()
    }
    
    override func configureLayout() {
        view.layer.cornerRadius = 25
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func setWorkspaceList() {
        switch checkWorkspaceList {
        case .empty:
            mainView.tableView.isHidden = true
            mainView.emptyView.isHidden = false
        default:
            mainView.tableView.isHidden = false
            mainView.emptyView.isHidden = true
        }
    }
    

}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
