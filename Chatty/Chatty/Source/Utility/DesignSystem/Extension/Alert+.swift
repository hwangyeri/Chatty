//
//  Alert+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/05.
//

import UIKit

extension UIViewController {
    
    // 확인 얼럿
    func showOkAlert(title: String, message: String, handler: (() -> ())? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // 토스트
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        toastLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        toastLabel.backgroundColor = UIColor.point
        toastLabel.textColor = UIColor.white
        toastLabel.font = .customFont(.body)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.5, delay: 0.2, options: .curveLinear, animations: {
             toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

