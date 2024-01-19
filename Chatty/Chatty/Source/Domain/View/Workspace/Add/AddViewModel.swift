//
//  AddViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/11.
//

import Foundation
import RxSwift
import RxCocoa

final class AddViewModel: BaseViewModel {
    
    var workspaceID: Int?
    
    struct Input {
        let xButton: ControlEvent<Void>
        let profileImageButton: ControlEvent<Void> // 워크스페이스 이미지 추가 버튼
        let nameTextField: ControlProperty<String>
        let explainTextField: ControlProperty<String>
        let workspaceImage: PublishRelay<Data> // 워크스페이스 이미지 데이터
        let doneButton: ControlEvent<Void> // 완료 버튼
    }
    
    struct Output {
        let xButtonTap: Driver<Void>
        let profileImageButtonTap: Driver<Void>
        let doneButtonValid: Driver<Bool> // 생성하기 버튼 활성화
        let isNameValidResult: PublishRelay<Bool> // 이름 유효성 검증 결과 방출
        let isDoneButtonValid: PublishRelay<Bool> // 워크스페이스 생성 API 결과 방출
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let xButtonTap = input.xButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        let profileImageButtonTap = input.profileImageButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        // 워크스페이스 이름 빈 값인지 확인
        let isNotEmptyName = input.nameTextField
            .map { $0.count > 0 }
        
        // 워크스페이스 이미지 빈 값인지 확인
        let isNotEmptyImage = input.workspaceImage
            .map { !$0.isEmpty }
        
        // 생성하기 버튼 활성화
        let doneButtonValid = Observable.combineLatest(
            isNotEmptyName, isNotEmptyImage
        ).map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        // 워크스페이스 이름 유효성 검증
        let isNameValid = input.nameTextField
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { name in
                let nameRegex = "^[A-Za-z0-9ㄱ-ㅎ가-힣 ]{1,30}$"
                guard let _ = name.range(of: nameRegex, options: .regularExpression) else {
                    return false
                }
                return true
            }
        
        // 이름 유효성 검증 결과 방출
        let isNameValidResult = PublishRelay<Bool>()
        
        // 워크스페이스 생성 API 결과 방출
        let isDoneButtonValid = PublishRelay<Bool>()
        
        // 완료 버튼 탭
        input.doneButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(isNameValid)
            .map { nameValid in
                isNameValidResult.accept(nameValid)
                return nameValid
            }
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(
                input.nameTextField,
                input.explainTextField,
                input.workspaceImage
            ))
            .flatMapLatest { name, explain, image in
                // 워크스페이스 생성 API
                NetworkManager.shared.requestMultipart(type: Workspace.self, router: .workspaceCreate(model: WorkspaceCreateInput(name: name, description: explain, image: image)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("🩵 워크스페이스 생성 API 성공: \(data)")
                    isDoneButtonValid.accept(true)
                    owner.workspaceID = data.workspaceID
                case .failure(let error):
                    print("💛 워크스페이스 생성 API 실패: \(error.errorDescription)")
                    isDoneButtonValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            xButtonTap: xButtonTap, 
            profileImageButtonTap: profileImageButtonTap, 
            doneButtonValid: doneButtonValid,
            isNameValidResult: isNameValidResult,
            isDoneButtonValid: isDoneButtonValid
        )
    }
        
}
