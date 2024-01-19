//
//  SideMenuViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/17.
//

import Foundation
import RxSwift
import RxCocoa

final class SideMenuViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    var workspaceData: WorkspaceOutput?
    
    struct Input {
        
    }
    
    struct Output {
        let isCompletedNetwork: PublishRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    let isCompletedNetwork = PublishRelay<Bool>() // 네트워크 통신 완료 트리거
    
    func transform(input: Input) -> Output {
        
        
        return Output(
            isCompletedNetwork: isCompletedNetwork
        )
    }
    
    func fetchWorkspace() {
        // 내가 속한 워크스페이스 조회 API
        NetworkManager.shared.request(type: WorkspaceOutput.self, router: .workspaceRead) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 내가 속한 워크스페이스 조회 API 성공")
                dump(data)
                self?.workspaceData = data
                self?.isCompletedNetwork.accept(true)
            case .failure(let error):
                print("💛 내가 속한 워크스페이스 조회 API 실패: \(error.errorDescription)")
            }
        }
    }
    
}
