//
//  ARCameraViewController.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/6.
//

import UIKit
import ARKit

final class ARCameraViewController: UIViewController {

    // ARKit 視圖
    private let sceneView = ARSCNView(frame: .zero)

    // 上方自訂按鈕
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Action", for: .normal)   // 之後可改成拍照或辨識
        btn.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // 1️⃣ 加入 ARSCNView
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // 2️⃣ 加入 Action 按鈕（右上角）
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic   // 先用最基本追蹤
        sceneView.session.run(config)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - Action
    @objc private func actionTapped() {
        // TODO: 執行拍照、辨識或截圖
        print("📸 Action tapped")
    }
}
