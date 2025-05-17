//
//  AppDelegate.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

// Chef/Shared/Services/AppDelegate.swift
import UIKit
import Firebase

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate, UIWindowSceneDelegate { // 確保遵從協定

    var window: UIWindow?
    var appCoordinator: AppCoordinator? // 改為可選，因為 AppCoordinator 現在需要 Router

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let cfg = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        cfg.delegateClass = Self.self
        FirebaseApp.configure()
        return cfg
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // 建立根 UINavigationController
        let rootNavController = UINavigationController()
        window.rootViewController = rootNavController // 先設定 rootViewController
        window.makeKeyAndVisible()

        // 建立 App 的主 Router
        let appRouter = UIKitRouter(navigationController: rootNavController)

        // 建立並啟動 AppCoordinator
        let coordinator = AppCoordinator(router: appRouter)
        self.appCoordinator = coordinator // 儲存 appCoordinator
        coordinator.start(animated: false) // 傳遞 animated 參數

        print("✅ AppCoordinator.start() 完成, router 的根是 \(appRouter.navigationController)")
    }
}
