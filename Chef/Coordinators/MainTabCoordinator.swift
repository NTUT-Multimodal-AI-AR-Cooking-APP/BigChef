//
//  MainTabCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit
import SwiftUICore
import SwiftUI

@MainActor
final class MainTabCoordinator: Coordinator, ObservableObject {

    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    /// 提供給 AppCoordinator 當 rootViewController

    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public
    func start() {
        let tabView = TabView {
            // Recipe Tab
            NavigationStack {
                RecipeTabView(coordinator: self)
            }
            .tabItem {
                Label("Recipes", systemImage: "book.fill")
            }
            
            // Scanning Tab
            NavigationStack {
                ScanningTabView(coordinator: self)
            }
            .tabItem {
                Label("Scan", systemImage: "camera.fill")
            }
            
            // Settings Tab
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        
        let hostingController = UIHostingController(rootView: tabView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    // MARK: - Navigation Methods
    
    func showRecipeDetail(_ recipe: SuggestRecipeResponse) {
        let coordinator = RecipeCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.showRecipeDetail(recipe)
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
}

// MARK: - Tab Views

private struct RecipeTabView: View {
    @ObservedObject var coordinator: MainTabCoordinator
    @State private var recipeCoordinator: RecipeCoordinator?
    
    var body: some View {
        Group {
            if let recipeCoordinator = recipeCoordinator {
                RecipeView(viewModel: RecipeViewModel(response: SuggestRecipeResponse(
                    dish_name: "",
                    dish_description: "",
                    ingredients: [],
                    equipment: [],
                    recipe: []
                )))
                .environmentObject(recipeCoordinator)
            } else {
                ProgressView()
                    .onAppear {
                        recipeCoordinator = RecipeCoordinator(navigationController: coordinator.navigationController)
                        coordinator.addChildCoordinator(recipeCoordinator!)
                    }
            }
        }
    }
}

private struct ScanningTabView: View {
    @ObservedObject var coordinator: MainTabCoordinator
    @State private var scanningCoordinator: ScanningCoordinator?
    
    var body: some View {
        Group {
            if let scanningCoordinator = scanningCoordinator {
                ScanningView(viewModel: ScanningViewModel())
                    .environmentObject(scanningCoordinator)
            } else {
                ProgressView()
                    .onAppear {
                        scanningCoordinator = ScanningCoordinator(navigationController: coordinator.navigationController)
                        coordinator.addChildCoordinator(scanningCoordinator!)
                    }
            }
        }
    }
}
