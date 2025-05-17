//
//  AppCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

//import UIKit
//
//final class AppCoordinator: Coordinator {
//    var childCoordinators = [Coordinator]()
//    private let window: UIWindow
//    init(window: UIWindow) { self.window = window }
//
//    func start() {
//        let main = MainTabCoordinator()
//        store(main)
//        window.rootViewController = main.root
//        window.makeKeyAndVisible()
//        main.start()
//    }
//}
import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let nav: UINavigationController

    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        Task { @MainActor in
            let main = MainTabCoordinator(nav: nav)
            childCoordinators.append(main)
            await main.start()
        }
    }
}
