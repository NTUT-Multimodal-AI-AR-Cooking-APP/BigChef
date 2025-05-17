//
//  RecipeCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import SwiftUI

@MainActor
final class RecipeCoordinator: Coordinator, ObservableObject {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // 創建一個空的食譜列表視圖
        let viewModel = RecipeViewModel(response: SuggestRecipeResponse(
            dish_name: "",
            dish_description: "",
            ingredients: [],
            equipment: [],
            recipe: []
        ))
        pushRecipeView(with: viewModel)
    }
    
    func showRecipeDetail(_ recipe: SuggestRecipeResponse) {
        let viewModel = RecipeViewModel(response: recipe)
        viewModel.onCookRequested = { [weak self] in
            self?.startCooking(with: recipe.recipe)
        }
        pushRecipeView(with: viewModel)
    }
    
    func showRecipeEdit(_ recipe: SuggestRecipeResponse) {
        pushRecipeView(with: RecipeViewModel(response: recipe))
    }
    
    func showScanning() {
        let coordinator = ScanningCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showCamera() {
        let coordinator = CameraCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    // MARK: - Private Helpers
    
    private func pushRecipeView(with viewModel: RecipeViewModel) {
        let view = RecipeView(viewModel: viewModel)
            .environmentObject(self)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    private func startCooking(with steps: [RecipeStep]) {
        let coordinator = CookCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start(with: steps)
    }
}
