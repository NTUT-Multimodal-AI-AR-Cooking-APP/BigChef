//
//  CameraCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

// Sources/Features/Camera/CameraCoordinator.swift
// Sources/Coordinators/Camera/CameraCoordinator.swift
import UIKit
import SwiftUI

@MainActor
final class CameraCoordinator: Coordinator, ObservableObject {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    /// 當相機流程結束時，讓父協調器可以把它移除
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let cameraVC = ARCameraViewController(steps: [])
        cameraVC.title = "Camera"

        cameraVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { [weak self] _ in self?.close() }
        )

        navigationController.pushViewController(cameraVC, animated: true)
    }

    /// Start cooking camera flow with recipe steps
    func start(with steps: [RecipeStep]) {
        let cameraVC = ARCameraViewController(steps: steps)
        cameraVC.title = "Cooking Camera"

        cameraVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction { [weak self] _ in self?.close() }
        )

        navigationController.pushViewController(cameraVC, animated: true)
    }

    func startScanning() {
        let vc = ScanViewController()
        navigationController.pushViewController(vc, animated: true)
    }

    // 烹飪流程（帶步驟）
    func startCooking(with steps: [RecipeStep]) {
        let vc = CookViewController(steps: steps)
        navigationController.pushViewController(vc, animated: true)
    }

    private func close() {
        navigationController.popViewController(animated: true)
        onFinish?()
    }
}
