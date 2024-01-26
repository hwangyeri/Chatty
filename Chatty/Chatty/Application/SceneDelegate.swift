//
//  SceneDelegate.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/03.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let OnboardingVC = OnboardingViewController()
        let vc = UINavigationController(rootViewController: OnboardingVC)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    // 외부 소스(카카오)로 부터 딥 링크를 처리하는 함수, 앱이 URL과 함께 시작될 때 호출됨
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // KakaoTalk URL인지 확인
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                // KakaoTalk 로그인 URL이면, AuthController 호출해서 URL 처리
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    // 루트뷰 전환하는 메서드
    func changeRootVC(_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc
        
        UIView.transition(
            with: window, duration: 0.2,
            options: [.transitionCrossDissolve], animations: nil, completion: nil
        )
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

