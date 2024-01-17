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
    
    func requestSingle<T: Decodable>(
        type: T.Type,
        router: APIRouter
    ) -> Single<Result<T, NetworkError>>
    
    func requestCheckEmail(
        router: APIRouter,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
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
                print("🩵 request 응답 데이터: ", String(data: response.data ?? Data(), encoding: .utf8))
                
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
    
    // 이메일 중복 확인 API
    func requestCheckEmail(router: APIRouter, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        AF.request(router).response { response in
            switch response.result {
            case .success(let success):
                if 200..<300 ~= response.response?.statusCode ?? 0 {
                    print(success)
                    completion(.success("🩵 이메일 중복 확인 API 성공"))
                } else {
                    print("💛 이메일 중복 확인 API 실패")
                    if let responseData = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                            
                            if let networkError = NetworkError(rawValue: errorResponse.errorCode) {
                                completion(.failure(networkError))
                            } else {
                                completion(.failure(.unknownError))
                            }
                        } catch {
                            completion(.failure(.decodedError))
                        }
                    }
                }
            case .failure(let failure):
                print(failure)
                if let responseData = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                        
                        if let networkError = NetworkError(rawValue: errorResponse.errorCode) {
                            completion(.failure(networkError))
                        } else {
                            completion(.failure(.unknownError))
                        }
                    } catch {
                        completion(.failure(.decodedError))
                    }
                }
            }
        }
    }
    
    // Multipart Single
    func requestMultipart<T: Decodable>(type: T.Type, router: APIRouter) -> Single<Result<T, NetworkError>> {
        return Single.create { single in
            AF.upload(multipartFormData: router.multipart, with: router).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(_):
                    if let responseData = response.data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                            
                            if let networkError = NetworkError(rawValue: errorResponse.errorCode) {
                                single(.success(.failure(networkError)))
                            } else {
                                single(.failure(NetworkError.unknownError))
                            }
                        } catch {
                            single(.failure(NetworkError.decodedError))
                        }
                    } else {
                        single(.failure(NetworkError.noDataError))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    
}
