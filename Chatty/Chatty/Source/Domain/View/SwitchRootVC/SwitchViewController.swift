//
//  SwitchViewController.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/13.
//

import UIKit

class SwitchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SwitchVC 진입", #function)
        
        switchToRootVC()
    }

    // 탭바 루트뷰 전환
    private func switchToRootVC() {
        let tabBar = UITabBarController()
        
        let homeVC = HomeViewController()
        let firstVC = UINavigationController(rootViewController: homeVC)
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "homeActive2"), selectedImage: UIImage(named: "homeActive"))
        
        let dmVC = HomeViewController()
        let secondVC = UINavigationController(rootViewController: dmVC)
        secondVC.tabBarItem = UITabBarItem(title: "DM", image: UIImage(named: "messageActive2"), selectedImage: UIImage(named: "messageActive"))
        
        let searchVC = HomeViewController()
        let thirdVC = UINavigationController(rootViewController: searchVC)
        thirdVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "profileActive2"), selectedImage: UIImage(named: "profileActive"))
        
        let settingVC = HomeViewController()
        let fourthVC = UINavigationController(rootViewController: settingVC)
        fourthVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(named: "Vector2"), selectedImage: UIImage(named: "Vector"))
        
        tabBar.viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        tabBar.tabBar.backgroundColor = UIColor.white
        tabBar.tabBar.tintColor = UIColor.black
        tabBar.selectedIndex = 0
        
        ChangeRootVCManager.shared.changeRootVC(tabBar)
    }
    
}
