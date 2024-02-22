//
//  Kingfisher+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/08.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageKF(withURL imageUrl: String, completionHandler: @escaping ((Result<RetrieveImageResult, KingfisherError>) -> Void)) {
        
        // Header
        let modifier = AnyModifier { request in
            var headers = request
            headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
            headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
            return headers
        }
        
        // Cache
        var options: KingfisherOptionsInfo = [
            .cacheOriginalImage
        ]
        
        options.append(.requestModifier(modifier))
        
        // Downsampling
        options.append(.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))))
        
        options.append(.scaleFactor(UIScreen.main.scale))
        
        self.kf.setImage(
            with: URL(string: APIKey.baseURL + "/v1" + imageUrl),
            placeholder: UIImage(named: "Dummy"),
            options: options,
            completionHandler: { result in
                completionHandler(result)
            }
        )
    }
    
}

extension UIButton {
    
    func setImageKF(withURL imageUrl: String, completionHandler: @escaping ((Result<RetrieveImageResult, KingfisherError>) -> Void)) {
        
        // Header
        let modifier = AnyModifier { request in
            var headers = request
            headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
            headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
            return headers
        }
        
        // Cache
        var options: KingfisherOptionsInfo = [
            .cacheOriginalImage
        ]
        
        options.append(.requestModifier(modifier))
        
        // Downsampling
        options.append(.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))))
        
        options.append(.scaleFactor(UIScreen.main.scale))
        
        self.kf.setImage(
            with: URL(string: APIKey.baseURL + "/v1" + imageUrl),
            for: .normal,
            placeholder: UIImage(named: "Dummy"),
            options: options,
            completionHandler: { result in
                completionHandler(result)
            }
        )
    }
    
}

