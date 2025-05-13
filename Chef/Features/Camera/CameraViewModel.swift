import Combine
import UIKit

final class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage?
    private let cameraService: CameraServiceProtocol

    init(cameraService: CameraServiceProtocol = CameraService()) {
        self.cameraService = cameraService
    }

    func start(in view: UIView) {
        cameraService.startPreview(in: view)
    }

    func stop() {
        cameraService.stop()
    }

    func takePhoto() {
        cameraService.capturePhoto { [weak self] image in
            DispatchQueue.main.async {
                self?.capturedImage = image
            }
        }
    }
}
