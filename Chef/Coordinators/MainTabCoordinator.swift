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
//    let root: UITabBarController = UITabBarController()
    private let nav : UINavigationController
//    private let tab = UITabBarController()
    init(nav: UINavigationController) { self.nav = nav }
    
    // MARK: - Public
    func start() {
        startFlow()
//        fatalError("Use start(in:) instead")
    }
    
    private func startFlow() {
            let scan = ScanningCoordinator(nav: nav)
            childCoordinators.append(scan)
            scan.start()
        }
//    func start(in nav: UINavigationController) {
//            let scanNav = UINavigationController()
//            scanNav.tabBarItem = UITabBarItem(
//                title: "Scan",
//                image: UIImage(systemName: "viewfinder"),
//                tag: 0
//            )
//
//            let scan = ScanningCoordinator(nav: scanNav)
//            childCoordinators.append(scan)
//            scan.start()
//
//            tab.setViewControllers([scanNav], animated: false)
//            tab.selectedIndex = 0
//            nav.viewControllers = [tab]          // 讓 UITabBarController 成為 nav 的 root
//        }

//    func start() {
//            let scanNav = UINavigationController()
//            scanNav.tabBarItem = UITabBarItem(
//                title: "Scan",
//                image: UIImage(systemName: "viewfinder"),
//                tag: 0
//            )
//
//            let scanning = ScanningCoordinator(nav: scanNav)
//            childCoordinators.append(scanning)
//            scanning.start()
//
//            // ✅ 這行是關鍵，讓 tab bar 有內容！
//            root.setViewControllers([scanNav], animated: false)
//            root.selectedIndex = 0
//            root.tabBar.isTranslucent = false
//        }
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
