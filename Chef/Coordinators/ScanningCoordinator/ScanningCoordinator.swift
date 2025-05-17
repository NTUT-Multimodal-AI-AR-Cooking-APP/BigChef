////
////  ScanningCoordinator.swift
////  ChefHelper
////
//
//import UIKit
//import SwiftUI // For UIHostingController
//
<<<<<<< HEAD
//final class ScanningCoordinator: Coordinator {
//    var router: Router
//    var childCoordinators: [Coordinator] = []
//
//    var onCanceled: ((Coordinator) -> Void)?
//    var onFinished: ((Coordinator) -> Void)?
//    var onFailed: ((Coordinator, Error) -> Void)?
//
//    private var recipeCoordinator: RecipeCoordinator? // 用於追蹤食譜流程
//    private var cameraCoordinator: CameraCoordinator? // 用於追蹤相機流程
//
//    // MARK: - Initialization
//    init(router: Router) {
//        self.router = router
//        print("ScanningCoordinator: 初始化完成")
//    }
//
//    // MARK: - Coordinator
//    func start(animated: Bool) {
//        print("ScanningCoordinator: 啟動 (animated: \(animated))")
//        showScanningView(animated: animated)
//    }
//
//    private func showScanningView(animated: Bool) {
//     
//        let viewModel = ScanningViewModel() // 確保 ScanningViewModel 已適配
//
//        viewModel.onEquipmentScanRequested = { [weak self] in
//            print("ScanningCoordinator: 請求掃描設備")
//            self?.startCameraFlow(forScanningType: .equipment, animated: true)
//        }
//        viewModel.onScanRequested = { [weak self] in // 假設這是掃描食材的請求
//            print("ScanningCoordinator: 請求掃描食材")
//            self?.startCameraFlow(forScanningType: .ingredient, animated: true)
//        }
//        viewModel.onRecipeGenerated = { [weak self] recipeResponse in
//            print("ScanningCoordinator: 食譜已生成 - \(recipeResponse.dish_name)")
//            self?.showRecipeFlow(with: recipeResponse, animated: true)
//        }
//        viewModel.onRecipeGenerationFailed = { [weak self] error in
//            print("ScanningCoordinator: 食譜生成失敗 - \(error.localizedDescription)")
//            // 通知父 Coordinator (MainTabCoordinator) 此流程中的一個重要部分失敗了
//            // 或者在這裡處理錯誤，例如顯示一個 Alert
//            // self?.onFailed?(self, error) // 如果希望將錯誤上報
//            self?.showError(error, on: self?.router.navigationController.topViewController)
//        }
//
//        let scanningView = ScanningView(viewModel: viewModel)
//        let hostingController = UIHostingController(rootView: scanningView)
//        hostingController.title = "智慧掃描"
//        // router.navigationController.isNavigationBarHidden = true // 根據 UI 設計決定
//
//        router.setRootViewController(hostingController, animated: animated)
//        print("ScanningCoordinator: ScanningView 已設定為根視圖")
//    }
//
//    private enum ScanningType { case equipment, ingredient }
//    private func startCameraFlow(forScanningType type: ScanningType, animated: Bool) {
//        // 每個 Camera 流程都應該是獨立的，所以如果已存在，先結束舊的
//        if let existingCameraCoordinator = self.cameraCoordinator {
//            free(existingCameraCoordinator)
//            self.cameraCoordinator = nil
//        }
//
//        // CameraCoordinator 需要自己的 UINavigationController 來呈現其 ViewController
//        // 或者，如果 CameraCoordinator 的 ViewController 可以直接 push 到 ScanningCoordinator 的 router 上，
//        // 則可以傳遞 self.router。這取決於 CameraCoordinator 的設計。
//        // 假設 CameraCoordinator 需要一個新的導航堆疊來呈現其 modal 或全螢幕相機。
//        let cameraNavController = UINavigationController()
//        let cameraRouter = UIKitRouter(navigationController: cameraNavController)
//        let cameraCoordinator = CameraCoordinator(router: cameraRouter)
//        self.cameraCoordinator = cameraCoordinator
//
//        cameraCoordinator.onFinished = { [weak self] finishedCameraCoord in
//            print("ScanningCoordinator: CameraCoordinator (for \(type)) 完成")
//            self?.router.dismiss(animated: true, completion: nil) // Dismiss 相機的導航控制器
//            self?.free(finishedCameraCoord)
//            self?.cameraCoordinator = nil
//            // 在這裡處理掃描結果，例如更新 ScanningViewModel
//            // (CameraCoordinator 可能需要一個帶有掃描結果的回調)
//        }
//        cameraCoordinator.onCanceled = { [weak self] canceledCameraCoord in
//            print("ScanningCoordinator: CameraCoordinator (for \(type)) 取消")
//            self?.router.dismiss(animated: true, completion: nil)
//            self?.free(canceledCameraCoord)
//            self?.cameraCoordinator = nil
//        }
//        cameraCoordinator.onFailed = { [weak self] failedCameraCoord, error in
//            print("ScanningCoordinator: CameraCoordinator (for \(type)) 失敗: \(error.localizedDescription)")
//            self?.router.dismiss(animated: true, completion: nil)
//            self?.free(failedCameraCoord)
//            self?.cameraCoordinator = nil
//            self?.showError(error, on: self?.router.navigationController.topViewController)
//        }
//
//        store(cameraCoordinator)
//        // 根據掃描類型啟動 CameraCoordinator 的特定方法
//        switch type {
//        case .equipment:
//            cameraCoordinator.startScanning(animated: false) // 假設 startScanning 是用於設備/食材掃描
//        case .ingredient:
//            cameraCoordinator.startScanning(animated: false) // 同上
//        }
//        // 以 modal 方式呈現相機的導航控制器
//        router.present(cameraNavController, animated: animated, completion: nil)
//    }
//
//    private func showRecipeFlow(with response: SuggestRecipeResponse, animated: Bool) {
//        // 同樣，確保一次只有一個 RecipeCoordinator 實例
//        if let existingRecipeCoordinator = self.recipeCoordinator {
//            free(existingRecipeCoordinator)
//            self.recipeCoordinator = nil
//        }
//
//        // RecipeCoordinator 通常會 push 到當前的導航堆疊 (ScanningCoordinator 的 router)
//        let recipeCoordinator = RecipeCoordinator(router: self.router) // 使用相同的 router
//        self.recipeCoordinator = recipeCoordinator
//
//        recipeCoordinator.onFinished = { [weak self] finishedRecipeCoord in
//            print("ScanningCoordinator: RecipeCoordinator 完成")
//            // RecipeCoordinator 完成後，通常意味著用戶已完成查看食譜或完成烹飪
//            // ScanningCoordinator 可能會決定 pop RecipeView 回到 ScanningView
//            // 或者 RecipeCoordinator 自己在結束前 pop
//            self?.free(finishedRecipeCoord)
//            self?.recipeCoordinator = nil
//        }
//        recipeCoordinator.onCanceled = { [weak self] canceledRecipeCoord in
//            print("ScanningCoordinator: RecipeCoordinator 取消")
//            // 如果 RecipeView 被用戶 pop 返回，會觸發這裡
//            self?.free(canceledRecipeCoord)
//            self?.recipeCoordinator = nil
//        }
//         recipeCoordinator.onFailed = { [weak self] failedRecipeCoord, error in
//            print("ScanningCoordinator: RecipeCoordinator 失敗: \(error.localizedDescription)")
//            self?.free(failedRecipeCoord)
//            self?.recipeCoordinator = nil
//            self?.showError(error, on: self?.router.navigationController.topViewController)
//        }
//
//        store(recipeCoordinator)
//        recipeCoordinator.start(with: response, animated: animated) // 假設 RecipeCoordinator 有 start(with:animated:)
//    }
//    
//    private func showError(_ error: Error, on viewController: UIViewController?) {
//        guard let vc = viewController else { return }
//        let alert = UIAlertController(title: "錯誤", message: error.localizedDescription, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "確定", style: .default))
//        vc.present(alert, animated: true)
//    }
//}
=======

import UIKit
import SwiftUI      // 為了 UIHostingController

@MainActor
final class ScanningCoordinator: Coordinator, ObservableObject {

    // MARK: - Protocol Requirements
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    // MARK: - Private
    private unowned let nav: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.nav = navigationController
    }

    // MARK: - Start
    func start() {
        let viewModel = ScanningViewModel()
        let view = ScanningView(viewModel: viewModel)
            .environmentObject(self)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }

    func showCamera() {
        let coordinator = CameraCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showRecipeDetail(_ recipe: SuggestRecipeResponse) {
        let coordinator = RecipeCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.showRecipeDetail(recipe)
    }
}
>>>>>>> upstream/allan-brach
