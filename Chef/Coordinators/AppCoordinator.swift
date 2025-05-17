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
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let main = MainTabCoordinator(navigationController: navigationController)
        addChildCoordinator(main)
        main.start()
    }
}
