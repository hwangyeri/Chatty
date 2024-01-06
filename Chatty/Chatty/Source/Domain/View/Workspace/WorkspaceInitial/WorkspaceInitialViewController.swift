//
//  WorkspaceInitialViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/06.
//

import UIKit

final class WorkspaceInitialViewController: BaseViewController {
    
    private let mainView = WorkspaceInitialView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
