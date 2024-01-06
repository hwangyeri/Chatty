//
//  SignUpViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
}
