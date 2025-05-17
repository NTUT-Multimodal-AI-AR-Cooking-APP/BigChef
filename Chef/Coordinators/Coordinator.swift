//
//  Coordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

<<<<<<< HEAD
import UIKit
=======
import SwiftUI
>>>>>>> upstream/allan-brach

@MainActor
protocol Coordinator: AnyObject {
    var router: Router { get set}
    var childCoordinators: [Coordinator] { get set }
<<<<<<< HEAD
    
    // 啟動 coordinator 流程的方法
    func start(animated: Bool)

    // 給父 coordinator 的回調 (callbacks)
    var onCanceled: ((Coordinator) -> Void)? { get set }
    var onFinished: ((Coordinator) -> Void)? { get set }
    var onFailed: ((Coordinator, Error) -> Void)? { get set }

    // 輔助方法 (可以在 extension 或基底類別中)
    func store(_ child: Coordinator)
    func free(_ child: Coordinator?)
=======
    var navigationController: UINavigationController { get set }
    
    func start()
>>>>>>> upstream/allan-brach
}

// MARK: - Default Implementation for Child Coordinator Management
extension Coordinator {
<<<<<<< HEAD
    func store(_ child: Coordinator) {
        print("\(type(of: self)): 儲存子 Coordinator -> \(type(of: child))")
        childCoordinators.append(child)
    }

    func free(_ child: Coordinator?) {
        guard let child = child else { return }
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
            print("\(type(of: self)): 釋放子 Coordinator -> \(type(of: child))")
        } else {
            print("\(type(of: self)): 警告 - 嘗試釋放一個不存在的子 Coordinator -> \(type(of: child))")
        }
=======
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
>>>>>>> upstream/allan-brach
    }
}
