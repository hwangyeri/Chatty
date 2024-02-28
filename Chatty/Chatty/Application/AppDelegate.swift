//
//  AppDelegate.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/01/03.
//

import UIKit
import IQKeyboardManagerSwift
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging
import iamport_ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Iamport.shared.receivedURL(url)
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        // 메인 번들에 있는 카카오 앱 키 불러오기
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        // KakaoSDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 푸시 알림 권한 설정, FCM 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .providesAppNotificationSettings]
        
        // 알림 허용 확인
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { didAllow, error in
            print("✅ Notification Authorization : \(didAllow)")
        }
        
        // 메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ Device Token: \(tokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // foreground 상태일 때 Push 받으면 alert 띄워주기 위한 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //guard let userInfo = notification.request.content.userInfo as? [String: Any] else { return }
        
        // FIXME: 현재 접속한 채팅방 푸시 알림 - 예외처리
        // 푸시 알람 디코딩 필요
        
        completionHandler([.list, .badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function, "✅ 푸시 알람 클릭!")
        
        //guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return }
        
        // FIXME: 푸시 받은 채팅 화면으로 이동시켜주기
        // 푸시 알람 디코딩 필요
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("🩵 Firebase registration token: \(token)")
            KeychainManager.shared.deviceToken = token
        } else {
            print("💛 Firebase registration token is nil.")
        }
    }
    
}
