//
//  HomeViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import Foundation
import RxSwift
import RxCocoa

struct ChannelSectionData {
    let title = "채널"
    var isOpened: Bool
    var sectionData: [ChannelCellData]
    
    struct ChannelCellData {
        let channelData: Channel
        var messageCount: Int
    }
}

struct DMSectionData {
    let title = "다이렉트 메시지"
    var isOpened: Bool
    var sectionData: [DMCellData]
    
    struct DMCellData {
        let dmData: DM
        var messageCount: Int
    }
}

final class HomeViewModel: BaseViewModel {
    
    var myProfile: MyProfileOutput? // 내 프로필 정보
    var workspaceData: WorkspaceOutput? // 워크스페이스 ID, name, thumbnail
    var channelsData: ChannelSectionData? // 내가 속한 모든 채널
    var dmData: DMSectionData? // DM 방 조회
    
    struct Input {
        let wsNameButton: ControlEvent<Void> // 워크스페이스 이름 버튼
        let myProfileButton: ControlEvent<Void> // 내 프로필 버튼
        let createButton: ControlEvent<Void> // 워크스페이스 생성 버튼
        let postButton: ControlEvent<Void> // 작성하기 버튼
    }
    
    struct Output {
        let wsNameButtonTap: Driver<Void>
        let myProfileButtonTap: Driver<Void>
        let createButtonTap: Driver<Void>
        let postButtonTap: Driver<Void>
        let isCompletedTopUIData: PublishRelay<Bool> // Top UI 업데이트 트리거
        let isCompletedHomeData: PublishRelay<Bool> // 테이블뷰 업데이트 트리거
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompletedTopUIData = PublishRelay<Bool>()
    
    let isCompletedHomeData = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 워크스페이스 이름 탭 -> SideMenu
        let wsNameButtonTap = input.wsNameButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 내 프로필 버튼 탭
        let myProfileButtonTap = input.myProfileButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 워크스페이스 생성하기 버튼 탭
        let createButtonTap = input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 작성하기 버튼 텝
        let postButtonTap = input.createButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            wsNameButtonTap: wsNameButtonTap, 
            myProfileButtonTap: myProfileButtonTap, 
            createButtonTap: createButtonTap, 
            postButtonTap: postButtonTap, 
            isCompletedTopUIData: isCompletedTopUIData,
            isCompletedHomeData: isCompletedHomeData
        )
    }
    
    // 홈 화면에서 쓰이는 데이터 초기 셋팅
    func fetchHomeData() {
        let group = DispatchGroup()
        
        group.enter()
        // 내가 속한 워크스페이스 조회 API
        NetworkManager.shared.request(
            type: WorkspaceOutput.self,
            router: .workspaceRead,
            completion: { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 워크스페이스 조회 API 성공: \(data)")
                    self?.workspaceData = data
                    UserDefaults.standard.workspaceID = data[0].workspaceID
                case .failure(let error):
                    print("💛 워크스페이스 조회 API 실패: \(error.errorDescription)")
                }
                
                group.leave()
            })
        
        let workspaceID = UserDefaults.standard.workspaceID ?? 0
        //print("++ workspaceID: \(UserDefaults.standard.workspaceID)")
        
        group.enter()
        // 내 프로필 정보 조회 API
        NetworkManager.shared.request(type: MyProfileOutput.self, router: .usersMy) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 내 프로필 정보 조회 API 성공: \(data)")
                self?.myProfile = data
                self?.isCompletedTopUIData.accept(true)
            case .failure(let error):
                print("💛 내 프로필 정보 조회 API 실패: \(error.errorDescription)")
            }
            
            group.leave()
        }
        
        group.enter()
        // 내가 속한 모든 채널 조회 API
        NetworkManager.shared.request(
            type: ChannelsOutput.self,
            router: .channelsMyRead(id: workspaceID)) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 내가 속한 모든 채널 조회 API 성공: \(data)")
                    self?.channelsData = ChannelSectionData(
                        isOpened: true,
                        sectionData: data.map {
                            ChannelSectionData.ChannelCellData(
                                channelData: $0,
                                messageCount: 0
                            )
                        }
                    )
                case .failure(let error):
                    print("💛 내가 속한 모든 채널 조회 API 실패: \(error.errorDescription)")
                }
                
                group.leave()
            }
        
        group.enter()
        // DM 방 조회 API
        NetworkManager.shared.request(type: DMOutput.self, router: .dmsRead(id: workspaceID)) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 DM 방 조회 API 성공: \(data)")
                self?.dmData = DMSectionData(
                    isOpened: true,
                    sectionData: data.map {
                        DMSectionData.DMCellData(
                            dmData: $0,
                            messageCount: 0
                        )
                    }
                )
                
                
            case .failure(let error):
                print("💛 DM 방 조회 API 실패: \(error.errorDescription)")
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.fetchUnreadsChatCount()
        }
    }
    
    // 읽지 않은 채팅 수 API
    func fetchUnreadsChatCount() {
        let group = DispatchGroup()
        
        guard let channelsData = channelsData else {
            print("읽지 않은 채팅 수 channelsData Error")
            return
        }
        
        for (index, value) in channelsData.sectionData.enumerated() {
            var workspaceID = value.channelData.workspaceID
            var channelName = value.channelData.name
            
            group.enter()
            // 읽지 않은 채널 채팅 개수 API
            NetworkManager.shared.request(
                type: UnreadsChannelChatCount.self,
                router: .channelsUnreadsChatCount(id: workspaceID, name: channelName)) { result in
                switch result {
                case .success(let data):
                    print("🩵 읽지 않은 채널 채팅 개수 API 성공: \(data)")
                    self.channelsData?.sectionData[index].messageCount = data.count
                case .failure(let error):
                    print("💛 읽지 않은 채널 채팅 개수 API 실패: \(error.errorDescription)")
                }
                
                group.leave()
            }
        }
        
        guard let dmData = dmData else {
            print("읽지 않은 DM 수 dmData Error")
            return
        }
        
        for (index, value) in dmData.sectionData.enumerated() {
            var workspaceID = value.dmData.workspaceID
            var roomID = value.dmData.roomID
            
            group.enter()
            // 읽지 않은 DM 채팅 개수 API
            NetworkManager.shared.request(
                type: UnreadsDMChatCount.self,
                router: .dmsUnreadsChatCount(id: workspaceID, roomID: roomID)) { result in
                    switch result {
                    case .success(let data):
                        print("🩵 읽지 않은 DM 채팅 개수 API 성공: \(data)")
                        self.dmData?.sectionData[index].messageCount = data.count
                    case .failure(let error):
                        print("💛 읽지 않은 DM 채팅 개수 API 실패: \(error.errorDescription)")
                    }
                    
                    group.leave()
                }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isCompletedHomeData.accept(true)
        }
    }
    
    // TableView numberOfRowsInSection
    func setNumberOfRowsInSection(section: Int) -> Int {
        guard let channelsData = channelsData, let dmData = dmData else {
            print("NumberOfRowsInSection channelsData Error: \(channelsData)")
            print("NumberOfRowsInSection dmData Error: \(dmData)")
            return 0
        }
        
        switch section {
        // 섹션이 열린 경우 => 데이터 개수 + 제목 셀 하나 추가해서 보여주기
        // 섹션이 닫힌 경우 => 제목 셀 하나 보여주기
        case 0:
            // 채널
            return channelsData.isOpened ? channelsData.sectionData.count + 2 : 1 // 플러스 셀 때문에 + 2
        case 1:
            // 다이렉트 메세지
            return dmData.isOpened ? dmData.sectionData.count + 2 : 1
        default:
            // 팀원 추가
            return 1
        }
    }
    
    enum HomeTableViewCellType {
        case sectionCell
        case channelRowCell
        case dmRowCell
        case plusCell
    }
    
    func cellType(indexPath: IndexPath) -> HomeTableViewCellType {
        guard let channelsData = channelsData, let dmData = dmData else {
            return .sectionCell
        }
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0), (1, 0): 
            return .sectionCell
        case (0, channelsData.sectionData.count + 1), (1, dmData.sectionData.count + 1), (2, 0):
            return .plusCell
        case (0, _): 
            return .channelRowCell
        case (1, _):
            return .dmRowCell
        default:
            return .sectionCell
            
        }
    }
    
    func sectionCellTitle(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return "채널"
        } else {
            return "다이렉트 메세지"
        }
    }
    
    func channelRowCellData(_ indexPath: IndexPath) -> (String, Int) {
        guard let channelsData = channelsData else {
            print("channelsData Error")
            return ("", 0)
        }
        
        return (
            channelsData.sectionData[indexPath.row - 1].channelData.name,
            channelsData.sectionData[indexPath.row - 1].messageCount
        )
    }
    
    func dmRowCellData(_ indexPath: IndexPath) -> (String, String, Int) {
        guard let dmData = dmData else {
            print("dmData Error")
            return ("", "", 0)
        }
        
        return (
            dmData.sectionData[indexPath.row - 1].dmData.user.profileImage,
            dmData.sectionData[indexPath.row - 1].dmData.user.nickname,
            dmData.sectionData[indexPath.row - 1].messageCount
        )
    }
    
    func plusCellTitle(_ indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return "채널 추가"
        } else if indexPath.section == 1 {
            return "새 메세지 시작"
        } else {
            return "팀원 추가"
        }
    }
    
    func isOpenedToggle(_ indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            channelsData?.isOpened.toggle()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            dmData?.isOpened.toggle()
        }
    }
    
}
