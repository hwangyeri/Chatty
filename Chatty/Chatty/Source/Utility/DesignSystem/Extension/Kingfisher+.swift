//
//  Kingfisher+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/08.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageKF(withURL imageUrl: String) {
        
        // Header
        let modifier = AnyModifier { request in
            var headers = request
            headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
            headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
            return headers
        }
        
        // Cache
        var options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .transition(.fade(1.2)) // 애니메이션
        ]
        
        options.append(.requestModifier(modifier))
        
        // Downsampling
        options.append(.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))))
        
        options.append(.scaleFactor(UIScreen.main.scale))
        
        // 이미지 로드 실패하면 재시도
        let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
        options.append(.retryStrategy(retryStrategy))
        
        self.kf.indicatorType = .activity
        
        self.kf.setImage(
            with: URL(string: APIKey.baseURL + "/v1" + imageUrl),
            placeholder: UIImage(named: "Dummy"),
            options: options
        )
    }
    
}

extension UIButton {
    
    func setImageKF(withURL imageUrl: String) {
        
        // Header
        let modifier = AnyModifier { request in
            var headers = request
            headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
            headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
            return headers
        }
        
        // Cache
        var options: KingfisherOptionsInfo = [
            .cacheOriginalImage,
            .transition(.fade(1.2)) // 애니메이션
        ]
        
        options.append(.requestModifier(modifier))
        
        // Downsampling
        options.append(.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))))
        
        options.append(.scaleFactor(UIScreen.main.scale))
        
        // 이미지 로드 실패하면 재시도
        let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
        options.append(.retryStrategy(retryStrategy))
        
        self.kf.setImage(
            with: URL(string: APIKey.baseURL + "/v1" + imageUrl),
            for: .normal,
            placeholder: UIImage(named: "Dummy"),
            options: options
        )
    }
    
}

