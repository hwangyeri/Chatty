//
//  ProfileViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/27.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    
    var myProfileData: MyProfileOutput?
    
    struct Input {
        let backButton: ControlEvent<Void>
    }
    
    struct Output {
        let backButtonTap: Driver<Void>
        let isCompletedFetch: PublishRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    private let isCompletedFetch = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            backButtonTap: backButtonTap,
            isCompletedFetch: isCompletedFetch
        )
    }
    
    func fetchMyProfile() {
        // 내 프로필 정보 조회 API
        NetworkManager.shared.request(
            type: MyProfileOutput.self,
            router: .usersMy) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 내 프로필 정보 조회 API 성공")
                    dump(data)
                    self?.myProfileData = data
                    self?.isCompletedFetch.accept(true)
                case .failure(let error):
                    print("💛 내 프로필 정보 조회 API 실패: \(error.errorDescription)")
                }
            }
    }
    
    enum ProfileTableViewCellType {
        case coinRowCell
        case nicknameRowCell
        case contactRowCell
        case emailRowCell
        case socialRowCell
        case logoutRowCell
    }
    
    func profileCellType(_ indexPath: IndexPath) -> ProfileTableViewCellType {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return .coinRowCell
        case (0, 1):
            return .nicknameRowCell
        case (0, 2):
            return .contactRowCell
        case (1, 0):
            return .emailRowCell
        case (1, 1):
            return .socialRowCell
        case (1, 2):
            return .logoutRowCell
        default:
            return .logoutRowCell
        }
    }
    
}
