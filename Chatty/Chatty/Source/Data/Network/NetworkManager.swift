//
//  NetworkManager.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkService {
    
    func request<T: Decodable>(
        type: T.Type,
        router: APIRouter,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func requestSingle<T: Decodable>(type: T.Type, router: APIRouter) -> Single<Result<T, NetworkError>>
}

final class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()

    private init() { }
    
}

extension NetworkManager {
    
    // AF Request
    func request<T: Decodable>(
        type: T.Type,
        router: APIRouter,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        AF.request(router)
            .responseDecodable(of: T.self) { response in
                print("🩵 request 응답 데이터: ", String(data: response.data!, encoding: .utf8))
                
                switch response.result {
                case .success(let data):
                    dump(data)
                    completion(.success(data))
                case .failure(_):
                    if let responseData = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                            
                            if let networkError = NetworkError(rawValue: errorResponse.errorCode) {
                                completion(.failure(networkError))
                            } else {
                                completion(.failure(NetworkError.unknownError))
                            }
                        } catch {
                            completion(.failure(NetworkError.decodedError))
                        }
                    } else {
                        completion(.failure(NetworkError.noDataError))
                    }
                }
            }
    }
    
    // RxSwift Single
    func requestSingle<T: Decodable>(type: T.Type, router: APIRouter) -> Single<Result<T, NetworkError>> {
        return Single.create { [weak self] single in
            
            self?.request(type: T.self, router: router) { result in
                switch result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    
}
