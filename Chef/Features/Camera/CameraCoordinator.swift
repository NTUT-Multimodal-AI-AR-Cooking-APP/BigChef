//
//  CameraCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

// Sources/Features/Camera/CameraCoordinator.swift
import UIKit

final class CameraCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    private let root: UIViewController

    init(root: UIViewController) { self.root = root }

    func start() {
        let vm   = CameraViewModel()
        let page = CameraViewController(viewModel: vm)
        page.modalPresentationStyle = .fullScreen
        root.present(page, animated: true)
    }
    var onFinish: (() -> Void)?
}
