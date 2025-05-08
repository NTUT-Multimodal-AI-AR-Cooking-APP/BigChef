//
//  CookViewController.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/7.
//


import UIKit

/// 「開始烹飪」AR 流程 —— 延續你原本 ARCameraVC 的 UI
final class CookViewController: BaseCameraViewController<ARSessionAdapter> {

    // MARK: - Data
    private let steps: [RecipeStep]
    private var currentIndex = 0 { didSet { updateStepLabel() } }

    // MARK: - UI
    private let stepLabel = UILabel()
    private let prevBtn   = UIButton(type: .system)
    private let nextBtn   = UIButton(type: .system)

    // MARK: - Init
    init(steps: [RecipeStep]) {
        self.steps = steps
        super.init(session: ARSessionAdapter())
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // ▲ Step Label
        stepLabel.numberOfLines = 0
        stepLabel.textColor = .white
        stepLabel.font = .preferredFont(forTextStyle: .headline)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stepLabel)

        // ▼ Prev / Next Buttons
        let hStack = UIStackView(arrangedSubviews: [prevBtn, nextBtn])
        hStack.axis = .horizontal
        hStack.spacing = 40
        hStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStack)

        prevBtn.setTitle("〈 上一步", for: .normal)
        nextBtn.setTitle("下一步 〉", for: .normal)
        prevBtn.addTarget(self, action: #selector(prevStep), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)

        NSLayoutConstraint.activate([
            stepLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stepLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stepLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        updateStepLabel()
    }

    // MARK: - Helpers
    private func updateStepLabel() {
        guard !steps.isEmpty else { stepLabel.text = "無步驟"; return }
        let step = steps[currentIndex]
        stepLabel.text = "步驟 \(currentIndex + 1)/\(steps.count)：\(step.description)"
        prevBtn.isEnabled = currentIndex > 0
        nextBtn.isEnabled = currentIndex < steps.count - 1
    }
    @objc private func prevStep() { currentIndex -= 1 }
    @objc private func nextStep() { currentIndex += 1 }
}