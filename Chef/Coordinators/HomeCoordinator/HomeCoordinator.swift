//
//  HomeCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit
import SwiftUI // For UIHostingController

final class HomeCoordinator: Coordinator {
    var router: Router
    var childCoordinators: [Coordinator] = []

    var onCanceled: ((Coordinator) -> Void)?
    var onFinished: ((Coordinator) -> Void)? // 當 Home 流程因登出等原因結束時呼叫
    var onFailed: ((Coordinator, Error) -> Void)?
    
    private var homeViewModel: HomeViewModel // 持有 ViewModel 實例

    // MARK: - Initialization
    init(router: Router) {
        self.router = router
        // 確保 HomeViewModel 使用了正確的 NetworkService (如果需要的話)
        // 或者 NetworkService 是透過 HomeViewModel 的預設參數注入的
        self.homeViewModel = HomeViewModel()
        print("HomeCoordinator: 初始化完成")
        setupViewModelCallbacks()
    }

    private func setupViewModelCallbacks() {
        homeViewModel.onSelectDish = { [weak self] dish in
            guard let strongSelf = self else { return }
            print("HomeCoordinator: ViewModel 請求顯示菜品詳情 - \(dish.name)")
            // strongSelf.showDishDetail(dish: dish, animated: true) // 實際導航邏輯
        }

        homeViewModel.onRequestLogout = { [weak self] in
            guard let strongSelf = self else { return }
            print("HomeCoordinator: ViewModel 請求登出")
            // 通知父 Coordinator (MainTabCoordinator)，Home 流程已結束 (因為用戶登出)
            strongSelf.onFinished?(strongSelf)
        }
    }

    // MARK: - Coordinator
    func start(animated: Bool) {
        print("HomeCoordinator: 啟動 (animated: \(animated))")
        showHomeView(animated: animated)
    }

    private func showHomeView(animated: Bool) {
        // HomeView 會透過 @ObservedObject 或 @EnvironmentObject 獲取 homeViewModel
        // 這裡我們假設 HomeView 的初始化方式是 viewModel: homeViewModel
        // 您的 HomeView 檔案路徑: ntut-multimodal-ai-ar-cooking-app/bigchef/BigChef-main/Chef/Features/Home/Views/HomeView.swift
        let homeView = HomeView(viewModel: self.homeViewModel)
        let hostingController = UIHostingController(rootView: homeView)
        // Tab 的標題通常由 UITabBarItem 設定，而不是 hostingController.title
        
        // HomeCoordinator 通常管理一個 Tab 的根視圖，所以使用 setRootViewController
        router.setRootViewController(hostingController, animated: animated)
        print("HomeCoordinator: HomeView 已設定為此 Tab 的根視圖")
    }

    // 範例：顯示菜品詳情 (如果需要)
    // func showDishDetail(dish: Dish, animated: Bool) {
    //     let detailViewModel = DishDetailViewModel(dish: dish) // 假設有 DishDetailViewModel
    //     let detailView = DishDetailView(viewModel: detailViewModel) // 假設 DishDetailView 已存在
    //     let hostingController = UIHostingController(rootView: detailView)
    //     hostingController.title = dish.name // 設定導航欄標題
    //
    //     // 使用 router 推送新的 ViewController
    //     // push 的 completion 回調會在 DishDetailView 被 pop 時觸發
    //     router.push(hostingController, animated: animated) { [weak self] in
    //         print("HomeCoordinator: DishDetailView 被 pop")
    //         // 通常，子畫面的 pop 不會結束 HomeCoordinator 本身
    //     }
    // }
}
