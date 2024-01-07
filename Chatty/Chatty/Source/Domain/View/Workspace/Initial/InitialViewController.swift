//
//  InitialViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/07.
//

import UIKit

final class InitialViewController: BaseViewController {
    
    private let mainView = InitialView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
