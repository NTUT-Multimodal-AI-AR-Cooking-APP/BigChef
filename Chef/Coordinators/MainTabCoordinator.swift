//
//  MainTabCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit
import SwiftUI // For UIHostingController

@MainActor
final class MainTabCoordinator: Coordinator {
    var router: Router // 這個 router 是由 AppCoordinator 傳入的，代表 App 的主導航控制器
    var childCoordinators: [Coordinator] = []

    var onCanceled: ((Coordinator) -> Void)?
    var onFinished: ((Coordinator) -> Void)? // 當整個 Tab 流程結束時 (例如登出) 呼叫
    var onFailed: ((Coordinator, Error) -> Void)?

    // MARK: - Initialization
    init(router: Router) {
        self.router = router
        print("MainTabCoordinator: 初始化完成")
    }

    // MARK: - Coordinator
    func start(animated: Bool) {
        print("MainTabCoordinator: 啟動 (animated: \(animated))")
        let tabBarController = UITabBarController()

        // 設定 TabBar 外觀
        tabBarController.tabBar.backgroundColor = UIColor.brandOrange // 確保 UIColor.brandOrange 已定義
        tabBarController.tabBar.isTranslucent = false
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.brandOrange
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        tabBarController.tabBar.tintColor = .white // 選中時的顏色
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray // 未選中時的顏色


        // --- 建立各個 Tab 的 Coordinator ---
        // 每個 Tab 都有自己的 UINavigationController 和 Router
        let homeNavController = UINavigationController()
        let homeRouter = UIKitRouter(navigationController: homeNavController)
        let homeCoordinator = HomeCoordinator(router: homeRouter)
        // 當 HomeCoordinator 完成 (例如因為登出)，MainTabCoordinator 也應該結束
        configureChildCoordinatorListeners(for: homeCoordinator, description: "HomeCoordinator") { [weak self] (finishedChild) in
            guard let strongSelf = self else { return }
            print("MainTabCoordinator: HomeCoordinator 完成，觸發 MainTabCoordinator 的 onFinished (登出)")
            strongSelf.onFinished?(strongSelf) // 通知 AppCoordinator
        }

//        let scanningNavController = UINavigationController()
//        let scanningRouter = UIKitRouter(navigationController: scanningNavController)
//        let scanningCoordinator = ScanningCoordinator(router: scanningRouter) // 假設 ScanningCoordinator 已更新
//        configureChildCoordinatorListeners(for: scanningCoordinator, description: "ScanningCoordinator") { [weak self] (finishedChild) in
//            // 如果 ScanningCoordinator 的完成也意味著登出或整個 App 流程結束，則執行類似邏輯
//             print("MainTabCoordinator: ScanningCoordinator 完成")
//            // self?.onFinished?(self) // 根據需要決定是否觸發，通常一個 Tab 的結束不代表整個 App 結束
//        }

        let historyNavController = UINavigationController()
        let historyRouter = UIKitRouter(navigationController: historyNavController)
        let historyCoordinator = HistoryCoordinator(router: historyRouter) // 假設 HistoryCoordinator 已更新
        configureChildCoordinatorListeners(for: historyCoordinator, description: "HistoryCoordinator") { [weak self] (finishedChild) in
             print("MainTabCoordinator: HistoryCoordinator 完成")
            // self?.onFinished?(self) // 同上
        }
        
        // --- 設定 TabBarItem ---
        homeNavController.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
//        scanningNavController.tabBarItem = UITabBarItem(title: "掃描", image: UIImage(systemName: "qrcode.viewfinder"), selectedImage: UIImage(systemName: "qrcode.viewfinder")) // 確保圖示存在
        historyNavController.tabBarItem = UITabBarItem(title: "歷史", image: UIImage(systemName: "clock"), selectedImage: UIImage(systemName: "clock.fill")) // 確保圖示存在

        tabBarController.viewControllers = [homeNavController, /*scanningNavController,*/ historyNavController]
        tabBarController.selectedIndex = 0 // 預設選中第一個 Tab
        
        // 在設定和儲存子 coordinator 之後啟動它們
        homeCoordinator.start(animated: false)
//        scanningCoordinator.start(animated: false)
        historyCoordinator.start(animated: false)

        // 將 TabBarController 設定為 MainTabCoordinator router (即 App's router) 的根
        router.setRootViewController(tabBarController, animated: animated)
        print("MainTabCoordinator: TabBarController 已設定為 Router 的根視圖。")
    }

    // 修改 configureChildCoordinatorListeners 以接受一個特定的 onChildFinished 處理
    private func configureChildCoordinatorListeners(
        for child: Coordinator,
        description: String,
        onSpecificChildFinished: @escaping (Coordinator) -> Void // 特定於子 Coordinator 完成的回調
    ) {
        child.onFinished = { [weak self] finishedChild in
            guard let strongSelf = self else { return }
            print("MainTabCoordinator: \(description) 回報 onFinished。")
            onSpecificChildFinished(finishedChild) // 呼叫特定於子 Coordinator 的完成處理
            strongSelf.free(finishedChild) // 仍然釋放子 Coordinator
        }
        child.onCanceled = { [weak self] canceledChild in
            guard let strongSelf = self else { return }
            print("MainTabCoordinator: \(description) 回報 onCanceled。")
            strongSelf.free(canceledChild)
        }
        child.onFailed = { [weak self] failedChild, error in
            guard let strongSelf = self else { return }
            print("MainTabCoordinator: \(description) 回報 onFailed: \(error.localizedDescription)。")
            strongSelf.free(failedChild)
            // 考慮是否將錯誤上報給 AppCoordinator
            // strongSelf.onFailed?(strongSelf, error)
        }
        store(child) // 儲存子 Coordinator
        print("MainTabCoordinator: 已設定並儲存 \(description)。")
    }
}
