//
//  RecipeCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import SwiftUI

final class RecipeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private unowned let nav: UINavigationController
    func start() {fatalError("Use start(with:) instead.") }
    init(nav: UINavigationController) {
        self.nav = nav
    }

//    func start(
//        with response: RecipeResponse
//    ) {
//        let vm = RecipeViewModel(response: response)
//        let view = RecipeView(viewModel: vm)
//        let page = UIHostingController(rootView: view)
//
//        nav.pushViewController(page, animated: true)
//    }
    func start(with response: RecipeResponse) {
        print("🍽 push RecipeView 進 nav")
        print("   nav = \(nav)")
        print("   nav.stack.count(before) = \(nav.viewControllers.count)")

        let vm   = RecipeViewModel(response: response)
        let page = UIHostingController(rootView: RecipeView(viewModel: vm))
        nav.pushViewController(page, animated: true)

        print("   nav.stack.count(after)  = \(nav.viewControllers.count)")
    }

}
