//
//  HomeCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import UIKit
import SwiftUI

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private unowned let nav: UINavigationController
    
    init(nav: UINavigationController) { self.nav = nav }

    func start() {
        let vm = HomeViewModel()
        let view = HomeView(viewModel: vm)
        let page = UIHostingController(rootView: view)
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(page, animated: false)
    }
}
