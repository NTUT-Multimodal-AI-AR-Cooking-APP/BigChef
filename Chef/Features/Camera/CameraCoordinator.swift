//
//  CameraCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

// Sources/Features/Camera/CameraCoordinator.swift
// Sources/Coordinators/Camera/CameraCoordinator.swift
import UIKit

final class CameraCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    private let nav: UINavigationController

    /// 當相機流程結束時，讓父協調器可以把它移除
    var onFinish: (() -> Void)?

    init(nav: UINavigationController) {
        self.nav = nav
    }

    
    func start() {
        let cameraVC = ARCameraViewController()
        cameraVC.title = "Camera"

        // 右上角 Close ⇒ 用 navigationItem 搭配 pop
        cameraVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { [weak self] _ in self?.close() }
        )

        nav.pushViewController(cameraVC, animated: true)
    }

    private func close() {
        nav.popViewController(animated: true)
        onFinish?()
    }
}
