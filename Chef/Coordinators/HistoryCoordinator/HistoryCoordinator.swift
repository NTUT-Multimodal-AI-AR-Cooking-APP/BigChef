//
//  HistoryCoordinator.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/8.
//


import UIKit
import SwiftUI // For UIHostingController

@MainActor
final class HistoryCoordinator: Coordinator {
    var router: Router
    var childCoordinators: [Coordinator] = []

    var onCanceled: ((Coordinator) -> Void)?
    var onFinished: ((Coordinator) -> Void)?
    var onFailed: ((Coordinator, Error) -> Void)?

    // MARK: - Initialization
    init(router: Router) {
        self.router = router
        print("HistoryCoordinator: 初始化完成")
    }

    // MARK: - Coordinator
    func start(animated: Bool) {
        print("HistoryCoordinator: 啟動 (animated: \(animated))")
        showHistoryView(animated: animated)
    }

    private func showHistoryView(animated: Bool) {
        // 您的 HistoryView 檔案路徑: Chef/Features/History/View/HistoryView.swift
        // 您的 HistoryViewModel 檔案路徑: Chef/Features/History/ViewModel/HistoryViewModel.swift
        let viewModel = HistoryViewModel() // 確保 HistoryViewModel 已適配
        // viewModel.onSelectRecord = { [weak self] record in
        //     self?.showRecordDetail(record, animated: true)
        // }

        let historyView = HistoryView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: historyView)
        hostingController.title = "歷史紀錄"
        // router.navigationController.isNavigationBarHidden = true // 根據 UI 設計決定

        router.setRootViewController(hostingController, animated: animated)
        print("HistoryCoordinator: HistoryView 已設定為根視圖")
    }

    // func showRecordDetail(_ record: DailyRecord, animated: Bool) {
    //     // 假設有一個 RecordDetailView (SwiftUI)
    //     // let detailView = RecordDetailView(record: record)
    //     // let hostingController = UIHostingController(rootView: detailView)
    //     // hostingController.title = "紀錄詳情"
    //     // router.push(hostingController, animated: animated) { [weak self] in
    //     //     print("HistoryCoordinator: RecordDetailView 被 pop")
    //     // }
    // }
}

