//
//  WSInitialViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class WSInitialViewController: BaseViewController {
    
    private let mainView = WSInitialView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
