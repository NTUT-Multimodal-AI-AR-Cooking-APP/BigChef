//
//  AppDelegate.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import UIKit

// 同時採用 UIApplicationDelegate + UIWindowSceneDelegate
class AppDelegate: NSObject,
                   UIApplicationDelegate,
                   UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // ① 告訴系統：這個 Scene 仍用預設設定，
    //    但 Scene 的 delegate 直接就是 AppDelegate 自己
    func application(
        _ application: UIApplication,
        configurationForConnecting
            connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let cfg = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        cfg.delegateClass = Self.self   // ← 關鍵
        return cfg
    }

    // ② Scene 建立完成，這裡一定拿得到 UIWindowScene
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // 建立導航控制器
        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()

        // 啟動 AppCoordinator
        let coordinator = AppCoordinator(navigationController: nav)
        self.appCoordinator = coordinator
        coordinator.start()

        print("✅ AppCoordinator.start() 完成，root = \(nav)")
    }
}
