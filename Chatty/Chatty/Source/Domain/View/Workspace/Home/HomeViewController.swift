//
//  HomeViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

// 워크스페이스 여부 체크
enum CheckWorkspace {
    case homeEmpty
    case homeInitial
}

// 테이블뷰 데이터
struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

final class HomeViewController: BaseViewController {
    
    var checkWorkspace: CheckWorkspace?
    
    var tableViewData = [cellData]()
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let mainView = HomeView()
    
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
        setHomeUI()
        bind()
    }
    
    override func configureLayout() {
        let name = UserDefaults.standard.workspaceName
        mainView.wsNameButton.setTitle(name, for: .normal)
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    private func setData() {
        let workspaceID = UserDefaults.standard.workspaceID ?? 0
        print("workspaceID: \(workspaceID)")
        
        // 모든 채널 조회 API
        NetworkManager.shared.request(
            type: ChannelsOutput.self,
            router: .channelsRead(id: workspaceID)) { result in
            switch result {
            case .success(let data):
                print("🩵 모든 채널 조회 API 성공: \(data)")
            case .failure(let error):
                print("💛 모든 채널 조회 API 실패: \(error.errorDescription)")
            }
        }
    }
    
    // 워크스페이스 여부에 따라 홈 화면 UI 업데이트
    private func setHomeUI() {
        switch checkWorkspace {
        case .homeEmpty:
            // 워크스페이스 없는 경우 홈 화면
            mainView.tableView.isHidden = true
            mainView.divider2.isHidden = true
            mainView.emptyView.isHidden = false
        default: // homeInitial
            // 워크스페이스 생성 시 홈 화면
            mainView.tableView.isHidden = false
            mainView.divider2.isHidden = false
            mainView.emptyView.isHidden = true
            
            tableViewData = [
                cellData(opened: false, title: "Section01", sectionData: ["Cell01", "Cell02", "Cell03"]),
                cellData(opened: false, title: "Section02", sectionData: ["Cell04", "Cell5", "Cell06"]),
                cellData(opened: false, title: "Section03", sectionData: ["Cell011", "Cell022", "Cell033"])
            ]
        }
    }
    
    private func bind() {
        
        let input = HomeViewModel.Input(
            wsNameButton: mainView.wsNameButton.rx.tap,
            myProfileButton: mainView.myProfileButton.rx.tap,
            createButton: mainView.createButton.rx.tap,
            postButton: mainView.postButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 워크스페이스 이름 버튼 클릭 => SideMenu
        output.wsNameButtonTap
            .drive(with: self) { owner, _ in
                print("워크스페이스 이름 클릭")
                let vc = SideMenuViewController()
                let sideMenuVC = SideMenuNavigationController(rootViewController: vc)
                sideMenuVC.menuWidth = UIScreen.main.bounds.width * 0.8
                sideMenuVC.presentationStyle = .menuSlideIn
                
                SideMenuManager.default.leftMenuNavigationController = sideMenuVC
                SideMenuManager.default.addPanGestureToPresent(toView: owner.view)
                
                owner.present(sideMenuVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        } else {
            if tableViewData[section].opened == true {
                // 섹션이 열린 경우, 데이터 개수 + 제목 셀 하나 추가해서 보여주기
                return tableViewData[section].sectionData.count + 1
            } else {
                // 섹션이 닫힌 경우, 제목 셀 하나 보여주기
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 42
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 56
            } else {
                return 42
            }
        } else {
            if indexPath.row == 0 {
                return 56
            } else {
                return 45
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = CDivider()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeAddTableViewCell.identifier, for: indexPath) as? HomeAddTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.titleLabel.text = "팀원 추가"
            
            return cell
        } else if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSectionTableViewCell.identifier, for: indexPath) as? HomeSectionTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.titleLabel.text = "채널"
                
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.identifier, for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.titleLabel.text = "일반"
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.identifier, for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSectionTableViewCell.identifier, for: indexPath) as? HomeSectionTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.titleLabel.text = "다이렉트 메세지"
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDMTableViewCell.identifier, for: indexPath) as? HomeDMTableViewCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            print("팀원 추가 클릭")
        } else {
            if indexPath.row == 0 {
                print("Section 선택")
                tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
                tableView.reloadSections([indexPath.section], with: .none)
            } else {
                print("Section Data 선택")
            }
        }
        
        print("++ indexPath.section: \([indexPath.section]), indexPath.row: \([indexPath.row])")
    }
    
}

// 사이드메뉴 오픈 => 홈뷰 블러 처리
extension HomeViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        self.tabBarController?.tabBar.backgroundColor = .alpha
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.tabBarController?.tabBar.backgroundColor = .white
        blurEffectView.removeFromSuperview()
    }

}
