//
//  MainTabCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit
import SwiftUICore

@MainActor
final class MainTabCoordinator: Coordinator {

    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    /// 提供給 AppCoordinator 當 rootViewController

    private let nav : UINavigationController
    init(nav: UINavigationController) { self.nav = nav }
    
    // MARK: - Public
    func start() {
        Task { @MainActor in
            await startFlow()
        }
    }
    
    private func startFlow() async {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            await makeHomeTab(),
            await makeScanningTab(),
            await makeHistoryTab()
        ]
        tabBar.selectedIndex = 1
        tabBar.tabBar.backgroundColor = UIColor.brandOrange
        tabBar.tabBar.isTranslucent = false
        // Unify standard and scroll‑edge appearance colors
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.brandOrange
        tabBar.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tabBar.tintColor = .white
        nav.setViewControllers([tabBar], animated: false)
    }

    // MARK: - Private - 工具
    private func makeHomeTab() async -> UIViewController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        // 建立並啟動 Home Flow
        let home = HomeCoordinator(nav: nav)     // ← 如果你還沒寫 HomeCoordinator，先用假協調器
        store(home)
        await home.start()

        return nav
    }

    private func makeScanningTab() async -> UIViewController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Scan",
            image: UIImage(systemName: "viewfinder"),
            tag: 1
        )

        let scan = ScanningCoordinator(nav: nav)
        store(scan)
        await scan.start()

        return nav
    }

    private func makeHistoryTab() async -> UIViewController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock.arrow.circlepath"),
            tag: 2
        )

        let history = HistoryCoordinator(nav: nav)
        store(history)
        await history.start()

        return nav
    }
}
