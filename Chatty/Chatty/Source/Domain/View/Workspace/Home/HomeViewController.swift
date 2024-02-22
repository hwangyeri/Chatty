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
import RealmSwift

final class HomeViewController: BaseViewController {
    
    let realm = try! Realm()
    
    var workspaceID: Int?
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let mainView = HomeView()
    
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("✅", realm.configuration.fileURL)

        viewModel.workspaceID = workspaceID
        fetchHomeEmptyUI()
        viewModel.fetchTopData()
        bind()
    }
    
    override func configureLayout() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // 워크스페이스 없는 경우 홈 화면으로 초기 셋팅
    private func fetchHomeEmptyUI() {
        print(#function)
        
        var isEmpty: Bool = true
        
        if workspaceID != nil {
            isEmpty = false
        } else {
            isEmpty = true
        }
        
        print("✅ isEmpty: \(isEmpty)")
        
        mainView.tableView.isHidden = isEmpty
        mainView.divider2.isHidden = isEmpty
        mainView.emptyView.isHidden = !isEmpty
        self.navigationController?.tabBarController?.tabBar.isHidden = isEmpty
    }
    
    // Top UI 업데이트
    private func updateTopUI() {
        print(#function)
        if workspaceID != nil {
            // 워크스페이스 있는 경우
            guard let workspaceData = viewModel.workspaceData else {
                print("workspaceData Error")
                return
            }
            
            mainView.wsImageView.setImageKF(withURL: workspaceData.thumbnail) { result in
                switch result {
                case .success(_):
                    print("🩵 이미지 로드 성공")
                case .failure(let error):
                    print("💛 이미지 로드 실패: \(error)")
                }
            }
            
            mainView.wsNameButton.setTitle(workspaceData.name, for: .normal)
        } else {
            //워크스페이스 없는 경우
            mainView.wsImageView.image = .dummy
            mainView.wsNameButton.setTitle("No Workspace", for: .normal)
        }
        
        if let profileImage = viewModel.myProfile?.profileImage, !profileImage.isEmpty {
            mainView.myProfileButton.setImageKF(withURL: profileImage) { result in
                switch result {
                case .success(_):
                    print("🩵 이미지 로드 성공")
                case .failure(let error):
                    print("💛 이미지 로드 실패: \(error)")
                }
            }
        } else {
            mainView.myProfileButton.setImage(UIImage(named: "Dummy"), for: .normal)
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
        
        // 워크스페이스 생성하기 버튼 탭
        output.createButtonTap
            .drive(with: self) { owner, _ in
                print("워크스페이스 생성하기 버튼 클릭")
                let vc = AddViewController()
                vc.workspaceAction = .add
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
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
                
                vc.workspaceID = owner.viewModel.workspaceID
                vc.workspaceData = owner.viewModel.workspaceData
                
                owner.present(sideMenuVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // Top UI 업데이트 트리거
        output.isCompletedTopUIData
            .subscribe(with: self) { owner, isValid in
                if isValid {
                    owner.fetchHomeEmptyUI()
                    owner.updateTopUI()
                    print("✅ Top UI 업데이트")
                }
            }
            .disposed(by: disposeBag)
        
        // 전체 네트워크 통신 완료 => 테이블뷰 리로드 트리거
        output.isCompletedHomeData
            .subscribe(with: self) { owner,  isValid in
                print("✅ 전체 네트워크 통신 완료")
                if isValid {
                    owner.mainView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 생성 시, 토스트 알럿
        NotificationCenter.default.rx.notification(.createChannelSuccessToast)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, notification in
                let buttonY = owner.mainView.createButton.frame.origin.y
                owner.viewModel.fetchTopData()
                owner.showToast(message: "채널이 생성되었습니다. ", y: buttonY)
            }
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchNumberOfRowsInSection(section: section)
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
            
            
            // 유저 프로필 없을 때, 예외 처리
            if let profileImage = data.0 {
                cell.imgView.setImageKF(withURL: profileImage) { result in
                    switch result {
                    case .success(_):
                        print("🩵 이미지 로드 성공")
                    case .failure(let error):
                        print("💛 이미지 로드 실패: \(error)")
                    }
                }
            } else {
                cell.imgView.image = .dummy
            }
            
            cell.selectionStyle = .none
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
            // 채널 선택
            let vc = ChattingViewController()
            vc.workspaceID = viewModel.workspaceID
            vc.channelID = viewModel.channelRowCellData(indexPath).2
            vc.channelName = viewModel.channelRowCellData(indexPath).0
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .dmRowCell:
            print("DM Row Cell Clicked")
        case .plusCell:
            print("Plus Cell Clicked")
            if indexPath.section == 0 {
                // 팀원 추가
                print("팀원 추가 버튼 클릭")
                let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
                
                let addAction = UIAlertAction(title: "채널 생성", style: .default) { [weak self] _ in
                    print("채널 생성 클릭")
                    let vc = ChannelAddViewController()
                    vc.workspaceID = self?.viewModel.workspaceID
                    self?.present(vc, animated: true)
                }
                
                let searchAction = UIAlertAction(title: "채널 탐색", style: .default) { [weak self] _ in
                    print("채널 탐색 클릭")
                    let vc = ChannelSearchViewController()
                    vc.workspaceID = self?.viewModel.workspaceID
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                
                actionSheet.addAction(addAction)
                actionSheet.addAction(searchAction)
                actionSheet.addAction(cancelAction)
                
                present(actionSheet, animated: true)
            }
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
