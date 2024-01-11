//
//  ChangeRootVCManager.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/10.
//

import UIKit

final class ChangeRootVCManager {
    
    static let shared = ChangeRootVCManager()
    
    private init() { }
    
    func changeRootVC(_ vc: UIViewController) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootVC(vc, animated: true)
        } else {
            print("changeRootVC Error")
        }
    }
    
}

