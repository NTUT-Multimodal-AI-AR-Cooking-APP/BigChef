//
//  CameraViewController.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

// Sources/Features/Camera/CameraViewController.swift
import UIKit
import Combine

final class CameraViewController: UIViewController {
    private let viewModel: CameraViewModel
    private var bag = Set<AnyCancellable>()

    // UI
    private let shutter = UIButton(type: .custom)
    private let close   = UIButton(type: .close)

    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // 遮罩按鈕
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(close)
        NSLayoutConstraint.activate([
            close.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])

        // 快門
        shutter.translatesAutoresizingMaskIntoConstraints = false
        shutter.layer.borderWidth = 4
        shutter.layer.borderColor = UIColor.white.cgColor
        shutter.layer.cornerRadius = 36
        shutter.addTarget(self, action: #selector(shutterTapped), for: .touchUpInside)
        view.addSubview(shutter)
        NSLayoutConstraint.activate([
            shutter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            shutter.widthAnchor.constraint(equalToConstant: 72),
            shutter.heightAnchor.constraint(equalTo: shutter.widthAnchor)
        ])

        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start(in: view)   // 將 Preview layer 插入底層
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stop()
    }

    private func bind() {
        viewModel.$capturedImage
            .compactMap { $0 }
            .sink { [weak self] image in
                // 這裡之後可 push 到預覽頁或直接丟回 ScanningViewModel
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
    }

    @objc private func shutterTapped() { viewModel.takePhoto() }
    @objc private func closeTapped()   { dismiss(animated: true) }
}
