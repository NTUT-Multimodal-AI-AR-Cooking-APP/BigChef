//
//  AuthCoordinator.swift
//  ChefHelper
//
//  Created by 羅辰澔 on 2025/5/16.
//

import UIKit
import SwiftUI // For UIHostingController
import FirebaseAuth // 為了 Auth.auth().currentUser

final class AuthCoordinator: Coordinator {
    var router: Router
    var childCoordinators: [Coordinator] = []

    var onCanceled: ((Coordinator) -> Void)?
    var onFinished: ((Coordinator) -> Void)? // 登入或註冊成功
    var onFailed: ((Coordinator, Error) -> Void)?

    private var authViewModel: AuthViewModel // 持有 ViewModel 實例

    // MARK: - Initialization
    init(router: Router) {
        self.router = router
        self.authViewModel = AuthViewModel() // 在 Coordinator 初始化時創建 ViewModel
        print("AuthCoordinator: 初始化完成")
        setupViewModelCallbacks()
    }

    // 設定 ViewModel 的回調
    private func setupViewModelCallbacks() {
        authViewModel.onLoginSuccess = { [weak self] in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 回報登入成功")
            strongSelf.onFinished?(strongSelf) // 使用解包後的 strongSelf
        }

        authViewModel.onRegistrationSuccess = { [weak self] in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 回報註冊成功")
            strongSelf.onFinished?(strongSelf) // 使用解包後的 strongSelf
        }

        authViewModel.onNavigateToRegistration = { [weak self] in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 請求導航到註冊頁面")
            strongSelf.showRegistrationView(animated: true)
        }
        
        authViewModel.onNavigateBackToLogin = { [weak self] in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 請求導航回登入頁面")
            strongSelf.router.pop(animated: true, completion: nil)
        }

        authViewModel.onAuthFailure = { [weak self] error in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 回報驗證失敗 - \(error.localizedDescription)")
            // 可以在 LoginView/RegistrationView 中顯示錯誤，或者將錯誤上報
            // strongSelf.onFailed?(strongSelf, error) // 如果希望將錯誤完全交給父 Coordinator 處理
            strongSelf.showError(error, on: strongSelf.router.navigationController.topViewController)
        }
        
        authViewModel.onUserWantsToCancelAuth = { [weak self] in
            guard let strongSelf = self else { return } // 安全解包 self
            print("AuthCoordinator: ViewModel 回報用戶取消驗證流程")
            strongSelf.onCanceled?(strongSelf) // 使用解包後的 strongSelf
        }
    }

    // MARK: - Coordinator
    func start(animated: Bool) {
        print("AuthCoordinator: 啟動 (animated: \(animated))")
        if Auth.auth().currentUser != nil && authViewModel.currentUser != nil {
             print("AuthCoordinator: 已存在有效用戶 session，直接觸發 onFinished")
             self.onFinished?(self) // 在這裡，self 尚未進入閉包，所以是 AuthCoordinator (非可選)
        } else {
            if authViewModel.userSession != nil && authViewModel.currentUser == nil {
                authViewModel.fetchUser { [weak self] success in
                    guard let strongSelf = self else { return }
                    if success && strongSelf.authViewModel.currentUser != nil {
                        print("AuthCoordinator: 重新獲取用戶資料成功，觸發 onFinished")
                        strongSelf.onFinished?(strongSelf)
                    } else {
                        print("AuthCoordinator: 重新獲取用戶資料失敗，顯示登入頁面")
                        strongSelf.showLoginView(animated: animated)
                    }
                }
            } else {
                 print("AuthCoordinator: 無有效用戶 session 或用戶資料，顯示登入頁面")
                 showLoginView(animated: animated)
            }
        }
    }

    // MARK: - Flow Navigation
    private func showLoginView(animated: Bool) {
        let loginView = LoginView()
        let hostingController = UIHostingController(rootView: loginView.environmentObject(authViewModel))
        hostingController.title = "登入"
        router.setRootViewController(hostingController, animated: animated)
        print("AuthCoordinator: LoginView 已設定為根視圖")
    }

    private func showRegistrationView(animated: Bool) {
        let placeholderView = Text("註冊頁面 (待實作)\n請返回上一頁或完成實作")
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        let hostingController = UIHostingController(rootView: placeholderView.environmentObject(authViewModel))
        hostingController.title = "註冊帳號"
        router.push(hostingController, animated: animated) { [weak self] in
            print("AuthCoordinator: RegistrationView 被 pop (可能是用戶點擊返回)")
        }
        print("AuthCoordinator: RegistrationView 已推送")
    }
    
    private func showError(_ error: Error, on viewController: UIViewController?) {
        DispatchQueue.main.async {
            // 使用 self.router 來獲取 topViewController，因為 self 在這裡可能還未解包
            guard let vc = viewController ?? self.router.navigationController.topViewController else {
                print("AuthCoordinator: 無法顯示錯誤，因為沒有可見的 ViewController。錯誤: \(error.localizedDescription)")
                return
            }
            let alert = UIAlertController(title: "驗證錯誤", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            if vc.presentedViewController == nil {
                vc.present(alert, animated: true)
            } else {
                print("AuthCoordinator: showError - 另一個 Alert 已經在顯示，錯誤: \(error.localizedDescription)")
            }
        }
    }
}
