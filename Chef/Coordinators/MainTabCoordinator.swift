import UIKit
import SwiftUI

@MainActor
final class MainTabCoordinator: Coordinator, ObservableObject {

    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public Methods
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

    // MARK: - Navigation

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
            if let recipeCoordinator {
                RecipeView(viewModel: RecipeViewModel())
                    .environmentObject(recipeCoordinator)
            } else {
                ProgressView()
                    .onAppear {
                        let newCoordinator = RecipeCoordinator(navigationController: coordinator.navigationController)
                        coordinator.addChildCoordinator(newCoordinator)
                        recipeCoordinator = newCoordinator
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
            if let scanningCoordinator {
                ScanningView(viewModel: ScanningViewModel())
                    .environmentObject(scanningCoordinator)
            } else {
                ProgressView()
                    .onAppear {
                        let newCoordinator = ScanningCoordinator(navigationController: coordinator.navigationController)
                        coordinator.addChildCoordinator(newCoordinator)
                        scanningCoordinator = newCoordinator
                    }
            }
        }
    }
}