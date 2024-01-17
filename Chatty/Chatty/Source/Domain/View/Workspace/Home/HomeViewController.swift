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
import Kingfisher

// 워크스페이스 여부 체크
enum CheckWorkspace {
    case homeEmpty
    case homeInitial
}

final class HomeViewController: BaseViewController {
    
    var checkWorkspace: CheckWorkspace?
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let mainView = HomeView()
    
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchHomeData()
        updateHomeUI()
        bind()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // Top UI 업데이트
    private func updateTopUI() {
        print(#function)
        guard let data = viewModel.workspaceData?[0] else {
            print("workspaceData Error")
            return
        }
        print("워크스페이스 이미지 url: \(data.thumbnail)")
        
        let modifier = AnyModifier { request in
            var headers = request
            headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
            headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
            return headers
        }
        
        mainView.wsImageView.kf.setImage(
            with: URL(string: APIKey.baseURL + "/v1" + data.thumbnail),
            options: [.requestModifier(modifier)]
        )
        
        mainView.wsNameButton.setTitle(data.name, for: .normal)
        
        if let profileImage = viewModel.myProfile?.profileImage, !profileImage.isEmpty {
            let url = URL(string: profileImage)
            mainView.myProfileButton.kf.setImage(with: url, for: .normal)
        } else {
            //FIXME: 내 프로필 이미지 없을 때, 디폴트 이미지 변경하기
            mainView.myProfileButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        mainView.tableView.reloadData()
    }
    
    // 워크스페이스 여부에 따라 홈 화면 UI 업데이트
    private func updateHomeUI() {
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
        
        //워크스페이스 조회, 내 프로필 조회 API 데이터로 Top UI 업데이트
        output.isCompletedTopUIData
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.updateTopUI()
                    print("Top UI 업데이트")
                }
            }
            .disposed(by: disposeBag)
        
        //네트워크 통신 완료 => 테이블뷰 리로드 트리거
        output.isCompletedHomeData
            .subscribe(with: self) { owner, isValid in
                print("네트워크 통신 완료")
                if isValid {
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.setNumberOfRowsInSection(section: section)
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
        let cellType = viewModel.cellType(indexPath: indexPath)
       
        switch cellType {
        case .sectionCell:
            // Section
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSectionTableViewCell.identifier, for: indexPath) as? HomeSectionTableViewCell else { return UITableViewCell() }
            let title = viewModel.sectionCellTitle(indexPath)
            
            cell.selectionStyle = .none
            cell.titleLabel.text = title
            
            return cell
        case .channelRowCell:
            // 채널 Row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeChannelTableViewCell.identifier, for: indexPath) as? HomeChannelTableViewCell else { return UITableViewCell() }
            let data = viewModel.channelRowCellData(indexPath)
            
            cell.selectionStyle = .none
            cell.titleLabel.text = data.0
            
            // 안 읽은 메세지 없을 때, 예외 처리
            if data.1 == 0 {
                cell.backView.isHidden = true
                cell.countLabel.isHidden = true
            } else {
                cell.backView.isHidden = false
                cell.countLabel.isHidden = false
                cell.countLabel.text = "\(data.1)"
            }
            
            return cell
        case .dmRowCell:
            // 다이렉트 메세지 Row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDMTableViewCell.identifier, for: indexPath) as? HomeDMTableViewCell else { return UITableViewCell() }
            let data = viewModel.dmRowCellData(indexPath)
            let url = URL(string: data.0)
            
            cell.selectionStyle = .none
            cell.imgView.kf.setImage(with: url)
            cell.titleLabel.text = data.1
            
            // 안 읽은 메세지 없을 때, 예외 처리
            if data.2 == 0 {
                cell.backView.isHidden = true
                cell.countLabel.isHidden = true
            } else {
                cell.backView.isHidden = false
                cell.countLabel.isHidden = false
                cell.countLabel.text = "\(data.1)"
            }
            
            return cell
        case .plusCell:
            // Section03 팀원 추가
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomePlusTableViewCell.identifier, for: indexPath) as? HomePlusTableViewCell else { return UITableViewCell() }
            let title = viewModel.plusCellTitle(indexPath)
            
            cell.selectionStyle = .none
            cell.titleLabel.text = title
            
            return cell
        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModel.cellType(indexPath: indexPath)
        switch cellType {
        case .sectionCell:
            print("Section Cell Clicked")
            viewModel.isOpenedToggle(indexPath)
            tableView.reloadSections([indexPath.section], with: .none)
        case .channelRowCell:
            print("Channel Row Cell Clicked")
        case .dmRowCell:
            print("DM Row Cell Clicked")
        case .plusCell:
            print("Plus Cell Clicked")
        }
        
        print("++ Clicked indexPath.section: \([indexPath.section]), indexPath.row: \([indexPath.row])")
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
