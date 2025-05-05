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

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let nav: UINavigationController

    init(nav: UINavigationController) { self.nav = nav }
    
    func start() {
        let main = MainTabCoordinator(nav: nav)   // 直接傳 nav
        childCoordinators.append(main)
        main.start()                              // 調用 start() 即可
    }
}
