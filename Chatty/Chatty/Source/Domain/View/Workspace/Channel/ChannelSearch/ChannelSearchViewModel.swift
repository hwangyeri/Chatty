//
//  ChannelSearchViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelSearchViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    var allChannelsData: ChannelsOutput?
    
    var myChannelsData: [Channel]?
    
    var selectedChannelID: Int?
    
    var myChannelsID: [Int]?
    
    struct Input {
        let itemSelected: ControlEvent<IndexPath> // TableView didSelectRowAt
    }
    
    struct Output {
        let isCompletedFetch: PublishRelay<Bool> // 네트워크 통신 완료 트리거
        let isMyChannelValid: PublishRelay<Bool> // 내가 속한 채널인지 확인
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompletedFetch = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 내가 속한 채널인지 확인
        let isMyChannelValid = PublishRelay<Bool>()
        
        input.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.selectedChannelID = owner.allChannelsData?[indexPath.row].channelID
                print("✅ indexPath, selectedChannelID: \(indexPath), \(owner.selectedChannelID)")
                
                if let myChannelsID = owner.myChannelsID, myChannelsID.contains(owner.selectedChannelID ?? 0) {
                    // 내가 속한 채널인 경우
                    isMyChannelValid.accept(true)
                } else {
                    // 내가 속하지 않은 채널인 경우
                    isMyChannelValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            isCompletedFetch: isCompletedFetch, 
            isMyChannelValid: isMyChannelValid
        )
    }
    
    func fetchAllChannels() {
        // 모든 채널 조회 API
        NetworkManager.shared.request(
            type: ChannelsOutput.self,
            router: .channelsRead(id: workspaceID ?? 0)) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 모든 채널 조회 API 성공")
                    dump(data)
                    self?.allChannelsData = data
                    self?.isCompletedFetch.accept(true)
                    self?.fetchMyChannels()
                case .failure(let error):
                    print("💛 모든 채널 조회 API 실패: \(error.errorDescription)")
                }
            }
    }
    
    func fetchMyChannels() {
        // 내가 속한 채널 조회 API
        NetworkManager.shared.request(
            type: ChannelsOutput.self,
            router: .channelsMyRead(id: workspaceID ?? 0)) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 내가 속한 채널 조회 API 성공")
                    dump(data)
                    self?.myChannelsData = data
                    
                    // 내가 속한 모든 채널 channelID 저장
                    self?.myChannelsData.flatMap { channels in
                        channels.map { channel in
                            return channel.channelID
                        }
                    }.map { self?.myChannelsID = $0 }

                    print("✅ myChannelsID: \(self?.myChannelsID)")
                case .failure(let error):
                    print("💛 내가 속한 채널 조회 API 실패: \(error.errorDescription)")
                }
            }
    }
    
}
