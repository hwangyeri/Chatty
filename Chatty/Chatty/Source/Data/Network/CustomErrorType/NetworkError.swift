//
//  NetworkError.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import Foundation

enum NetworkError: String, Error {
    
    case unknownError
    case decodedError
    case noDataError
    case jsonSerializationFailed
    
    case e01 = "E01"
    case e99 = "E99"
    case e02 = "E02"
    case e03 = "E03"
    case e11 = "E11"
    case e12 = "E12"
    case e21 = "E21"
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return "알 수 없는 에러입니다."
        case .decodedError:
            return "디코딩에 실패하였습니다."
        case .noDataError:
            return "응답 데이터가 없습니다."
        case .jsonSerializationFailed:
            return "JSON 데이터 변환에 실패하였습니다."
        case .e01:
            return "SesacKey를 넣어주세요."
        case .e99:
            return "내부 서버 오류로 인한 응답값입니다."
        case .e02:
            return "로그인에 실패하였습니다."
        case .e03:
            return "알 수 없는 계정입니다."
        case .e11:
            return "잘못된 요청입니다."
        case .e12:
            return "중복 데이터입니다."
        case .e21:
            return "새싹 코인이 부족합니다."
        }
    }
}
