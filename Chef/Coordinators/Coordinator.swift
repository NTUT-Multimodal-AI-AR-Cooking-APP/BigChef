//
//  Coordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func store(_ child: Coordinator) { childCoordinators.append(child) }
    func free(_ child: Coordinator)  { childCoordinators.removeAll { $0 === child } }
}
