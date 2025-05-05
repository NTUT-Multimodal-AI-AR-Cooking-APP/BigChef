//
//  ScanningCoordinator.swift
//  ChefHelper
//

import UIKit
import SwiftUI      // 為了 UIHostingController

final class ScanningCoordinator: Coordinator {

    // MARK: - Protocol Requirements
    var childCoordinators: [Coordinator] = []

    // MARK: - Private
    private unowned let nav: UINavigationController

    // MARK: - Init
    init(nav: UINavigationController) {
        self.nav = nav
    }

    // MARK: - Start
//    func start() {
//        let vm = ScanningViewModel()
//
//        vm.onScanRequested = { [weak self] in
//            self?.presentCamera()
//        }
//
//        vm.onRecipeGenerated = { [weak self] response in
//            guard let self else { return }
//            let recipe = RecipeCoordinator(nav: self.nav)
//            self.childCoordinators.append(recipe)
//            recipe.start(with: response)
//            
//        }
//
//
//        let view = ScanningView(viewModel: vm)
//        nav.pushViewController(UIHostingController(rootView: view), animated: false)
//    }
    func start() {
        let vm = ScanningViewModel()
        print("👀 Coordinator vm = \(Unmanaged.passUnretained(vm).toOpaque())")

        vm.onRecipeGenerated = { [weak self] resp in
            guard let self else { return }
            // 這裡一定要印得到
            print("🛫 ScanningCoordinator 收到 resp，準備 push")
            let recipe = RecipeCoordinator(nav: self.nav)
            self.childCoordinators.append(recipe)
            recipe.start(with: resp)
        }

        let page = ScanningView(viewModel: vm)
        nav.pushViewController(UIHostingController(rootView: page), animated: false)
    }



    // MARK: - Navigation
    private func presentCamera() {
        // A. 建立相機 Flow
        let camera = CameraCoordinator(root: nav)
        childCoordinators.append(camera)

        // B. 開始並在 CameraCoordinator 完成時把它移除
        camera.onFinish = { [weak self, weak camera] in
            guard let self, let camera else { return }
            self.childCoordinators.removeAll { $0 === camera }
        }
        camera.start()
    }
}
