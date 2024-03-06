//
//  StoreDTO.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/03/06.
//

import Foundation

// 새싹 코인 스토어 아이템 리스트
typealias CoinItemList = [CoinItem]

struct CoinItem: Codable {
    let item, amount: String
}

// PG 결제
struct PGValidInput: Decodable {
    let impUid, merchantUid: String

    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case merchantUid = "merchant_uid"
    }
}

// 새싹 코인 결제 검증
struct PGValidOutput: Codable {
    let billingID: Int
    let merchantUid: String
    let amount, sesacCoin: Int
    let success: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case billingID = "billing_id"
        case merchantUid = "merchant_uid"
        case amount, sesacCoin, success, createdAt
    }
}
