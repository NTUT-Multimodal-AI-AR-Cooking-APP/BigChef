//
//  AppCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//
import UIKit
import FirebaseAuth // 為了檢查 Auth.auth().currentUser 和登出

@MainActor
final class AppCoordinator: Coordinator {
<<<<<<< HEAD
    var router: Router
    var childCoordinators: [Coordinator] = []

    var onCanceled: ((Coordinator) -> Void)?
    var onFinished: ((Coordinator) -> Void)?
    var onFailed: ((Coordinator, Error) -> Void)?

    private var authViewModel: AuthViewModel

    // MARK: - Initialization
    init(router: Router) {
        self.router = router
        self.authViewModel = AuthViewModel() // 創建 AuthViewModel 實例
        print("AppCoordinator: 初始化完成，Router: \(type(of: router))")
    }

    // MARK: - Coordinator
    func start(animated: Bool) {
        print("AppCoordinator: 啟動 (animated: \(animated))")
        if isLoggedIn() {
            print("AppCoordinator: 用戶已登入，顯示主 Tab 流程")
            showMainTabFlow(animated: false)
        } else {
            print("AppCoordinator: 用戶未登入，顯示身份驗證流程")
            showAuthFlow(animated: false)
        }
    }

    private func isLoggedIn() -> Bool {
        let loggedIn = Auth.auth().currentUser != nil
        print("AppCoordinator: 檢查登入狀態 - \(loggedIn)")
        if let user = Auth.auth().currentUser {
            print("AppCoordinator: 目前 Firebase 偵測到的用戶 UID: \(user.uid), Email: \(user.email ?? "N/A")")
        }
        return loggedIn
    }

    private func showMainTabFlow(animated: Bool) {
        if let authCoordinator = childCoordinators.first(where: { $0 is AuthCoordinator }) {
            free(authCoordinator)
            print("AppCoordinator: 已釋放舊的 AuthCoordinator")
        }

        // MainTabCoordinator 使用 AppCoordinator 的主 router，
        // 並在其 start 方法中將 UITabBarController 設定為該 router 的根。
        let mainTabCoordinator = MainTabCoordinator(router: self.router)
        mainTabCoordinator.onFinished = { [weak self] finishedMainTabCoordinator in
            guard let strongSelf = self else { return }
            print("AppCoordinator: MainTabCoordinator 回報 onFinished (因為登出)")
            strongSelf.free(finishedMainTabCoordinator)
            
            strongSelf.authViewModel.logout()
            print("AppCoordinator: 已呼叫 AuthViewModel.logout()")
            
            DispatchQueue.main.async {
                print("AppCoordinator: 準備在主執行緒上顯示 Auth 流程")
                strongSelf.showAuthFlow(animated: true)
            }
        }
        mainTabCoordinator.onCanceled = { [weak self] canceledCoordinator in
            print("AppCoordinator: MainTabCoordinator 回報 onCanceled (不太可能)")
            self?.free(canceledCoordinator)
        }
        mainTabCoordinator.onFailed = { [weak self] failedCoordinator, error in
            print("AppCoordinator: MainTabCoordinator 回報 onFailed: \(error.localizedDescription)")
            self?.free(failedCoordinator)
        }

        store(mainTabCoordinator)
        mainTabCoordinator.start(animated: animated) // MainTabCoordinator.start 會在其 router 上設定 UITabBarController
        print("AppCoordinator: MainTabCoordinator 已啟動")
    }

    private func showAuthFlow(animated: Bool) {
        if let mainTabCoordinator = childCoordinators.first(where: { $0 is MainTabCoordinator }) {
            free(mainTabCoordinator)
            print("AppCoordinator: 已釋放舊的 MainTabCoordinator (在 showAuthFlow 中)")
        }

        // AuthCoordinator 將直接使用 AppCoordinator 的主 router。
        // 它不需要一個新的 UINavigationController，因為它將替換 App 主 router 的內容。
        let authCoordinator = AuthCoordinator(router: self.router) // <--- 修正點：傳遞 self.router

        authCoordinator.onFinished = { [weak self] finishedAuthCoordinator in
            guard let strongSelf = self else { return }
            print("AppCoordinator: AuthCoordinator 回報 onFinished (登入/註冊成功)")
            strongSelf.free(finishedAuthCoordinator)
            DispatchQueue.main.async {
                print("AppCoordinator: 準備在主執行緒上顯示 MainTab 流程")
                strongSelf.showMainTabFlow(animated: true)
            }
        }
        authCoordinator.onCanceled = { [weak self] canceledAuthCoordinator in
            print("AppCoordinator: AuthCoordinator 回報 onCanceled (用戶取消驗證)")
            self?.free(canceledAuthCoordinator)
        }
        authCoordinator.onFailed = { [weak self] failedAuthCoordinator, error in
            print("AppCoordinator: AuthCoordinator 回報 onFailed: \(error.localizedDescription)")
            self?.free(failedAuthCoordinator)
        }

        store(authCoordinator)
        
        // AuthCoordinator 的 start 方法會負責在其 router (即 AppCoordinator 的主 router) 上
        // 設定 LoginView 為根視圖控制器。
        // AppCoordinator 不需要再呼叫 self.router.setRootViewController。
        authCoordinator.start(animated: animated) // 'animated' 參數會傳遞給 AuthCoordinator 的 start 方法
                                                 // AuthCoordinator 的 start 方法內部會呼叫 router.setRootViewController
        print("AppCoordinator: AuthCoordinator 已啟動，它將設定自己的根視圖。")
=======
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let main = MainTabCoordinator(navigationController: navigationController)
        addChildCoordinator(main)
        main.start()
>>>>>>> upstream/allan-brach
    }
}
