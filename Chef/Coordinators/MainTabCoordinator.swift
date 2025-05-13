//
//  MainTabCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit

final class MainTabCoordinator: Coordinator {

    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    /// 提供給 AppCoordinator 當 rootViewController

    private let nav : UINavigationController
    init(nav: UINavigationController) { self.nav = nav }
    
    // MARK: - Public
    func start() {
        startFlow()
    }
    
    private func startFlow() {
            let scan = ScanningCoordinator(nav: nav)
            childCoordinators.append(scan)
            scan.start()
    }

    // MARK: - Private - 工具
    private func makeHomeTab() -> UIViewController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        // 建立並啟動 Home Flow
        let home = HomeCoordinator(nav: nav)     // ← 如果你還沒寫 HomeCoordinator，先用假協調器
        store(home)
        home.start()

        return nav
    }

    private func makeScanningTab() -> UIViewController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Scan",
            image: UIImage(systemName: "viewfinder"),
            tag: 1
        )

        let scan = ScanningCoordinator(nav: nav)
        store(scan)
        scan.start()

        return nav
    }
}
