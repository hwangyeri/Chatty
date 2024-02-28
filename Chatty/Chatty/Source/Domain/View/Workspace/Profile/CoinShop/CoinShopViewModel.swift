//
//  CoinShopViewModel.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/28.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class CoinShopViewModel: BaseViewModel {
    
    var coin: Int?
    
    var coinData: CoinItemList?
    
    struct Input {
        let backButton: ControlEvent<Void>
    }
    
    struct Output {
        let isCompleted: PublishRelay<Bool>
        let backButtonTap: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let isCompleted = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        // 뒤로가기 버튼 탭
        let backButtonTap = input.backButton
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
        
        
        return Output(
            isCompleted: isCompleted,
            backButtonTap: backButtonTap
        )
    }
    
    func fetchCoinShopData() {
        // 새싹 코인 스토어 아이템 리스트 API
        NetworkManager.shared.request(
            type: CoinItemList.self,
            router: .storeItemList) { [weak self] result in
                switch result {
                case .success(let data):
                    print("🩵 새싹 코인 스토어 아이템 리스트 API 성공")
                    dump(data)
                    self?.coinData = data
                    self?.isCompleted.accept(true)
                case .failure(let error):
                    print("💛 새싹 코인 스토어 아이템 리스트 API 실패: \(error.errorDescription)")
                }
            }
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
                    self?.coin = data.sesacCoin
                    self?.isCompleted.accept(true)
                case .failure(let error):
                    print("💛 내 프로필 정보 조회 API 실패: \(error.errorDescription)")
                }
            }
    }
    
}

// MARK: PG 결제
extension CoinShopViewModel {
    
    // 1. 결제 요청 데이터 구성
    func configurePGData(_ indexPath: IndexPath) -> IamportPayment {
        
        ///pg: PG 사, 어떤 결제 사를 통해 결제를 진행할 지
        ///merchant_uid: 앱에서 결제한 내역을 식별할 수 있는 고유한 주문 번호
        ///amount: 결제할 금액
        ///pay_method: 결제 수단
        ///name: 결제할 상품명
        ///buyer_name: 주문자 이름
        ///app_scheme: 결제 후 SLP 앱으로 돌아올 때 사용됨
        
        let data = coinData?[indexPath.row]
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), // KG이니시스
            merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
            amount: data?.amount ?? "").then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = data?.item
                $0.buyer_name = "황예리"
                $0.app_scheme = "sesac"
            }
        
        return payment
    }
    
    // 2. 결제 유효성 검증
    func isValidPG(_ iamportResponse: IamportResponse?) {
        guard let iamportResponse else { return }
        
        // 새싹 코인 결제 검증 API
        NetworkManager.shared.request(
            type: PGValidOutput.self,
            router: .storePayValid(
                model: PGValidInput(
                    impUid: iamportResponse.imp_uid ?? "", // 포트원 고유 결제 번호
                    merchantUid: iamportResponse.merchant_uid ?? "" // 포트원 결제 요청 시 설정한 주문번호
                )
            )
        ) { [weak self] result in
            switch result {
            case .success(let data):
                print("🩵 새싹 코인 결제 검증 API 성공")
                dump(data)
                self?.fetchMyProfile()
            case .failure(let error):
                print("💛 새싹 코인 결제 검증 API 실패: \(error.errorDescription)")
            }
        }
    }
    
}
