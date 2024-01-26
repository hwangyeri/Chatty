//
//  KFModifier.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/26.
//

import Foundation
import Kingfisher

struct KFModifier {
    
    static let shared = KFModifier()
    
    let modifier = AnyModifier { request in
        var headers = request
        headers.setValue(KeychainManager.shared.accessToken, forHTTPHeaderField: Constants.authorization)
        headers.setValue(APIKey.sesacKey, forHTTPHeaderField: Constants.sesacKey)
        return headers
    }
    
}
