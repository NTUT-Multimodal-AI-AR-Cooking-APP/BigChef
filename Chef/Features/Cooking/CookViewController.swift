//
//  CookViewController.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/7.
//


import UIKit
import SwiftUI
import AVFoundation
import Vision
/// 「開始烹飪」AR 流程 —— 延續你原本 ARCameraVC 的 UI
final class CookViewController: BaseCameraViewController<ARSessionAdapter> {

    // MARK: - Data
    private let steps: [RecipeStep]
    private let stepViewModel = StepViewModel()
    private var currentIndex = 0 {
        didSet {
            updateStepLabel()
            stepViewModel.currentDescription = steps[currentIndex].description
            // 重新設定 rootView 以強制 SwiftUI 更新
            arContainer.rootView = CookingARView(step: stepBinding)
        }
    }

    // MARK: - UI
    private let stepLabel = UILabel()
    private let prevBtn   = UIButton(type: .system)
    private let nextBtn   = UIButton(type: .system)

    private var arContainer: UIHostingController<CookingARView>!
    private var stepBinding: Binding<String>!

    // MARK: - Init
    init(steps: [RecipeStep]) {
        self.steps = steps
        super.init(session: ARSessionAdapter())
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stepViewModel.currentDescription = steps[currentIndex].description
        updateStepLabel()
        stepBinding = Binding<String>(
            get: { self.stepViewModel.currentDescription },
            set: { self.stepViewModel.currentDescription = $0 }
        )
        arContainer = UIHostingController(
            rootView: CookingARView(
                step: stepBinding
            )
        )
        addChild(arContainer)
        arContainer.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arContainer.view)

        NSLayoutConstraint.activate([
            arContainer.view.topAnchor.constraint(equalTo: view.topAnchor),
            arContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arContainer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arContainer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        arContainer.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("📏 AR Container frame = \(self.arContainer.view.frame)")
        }
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📸 View Did Appear")
    }
    
    // MARK: - Helpers
    private func updateStepLabel() {
        guard !steps.isEmpty else { stepLabel.text = "無步驟"; return }
        let step = steps[currentIndex]
        stepLabel.text = "步驟 \(step.step_number)：\(step.title)\n\(step.description)"
        prevBtn.isEnabled = currentIndex > 0
        nextBtn.isEnabled = currentIndex < steps.count - 1
    }
    @objc private func prevStep() { currentIndex -= 1 }
    @objc private func nextStep() { currentIndex += 1 }
}
