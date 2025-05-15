import SwiftUI
import RealityKit
import ARKit
import Combine
import Foundation
import UIKit
import simd

struct CookingARView: UIViewRepresentable {

    @Binding var step: String
    private let manager = AnimationManger()

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
    }

    @MainActor
    func updateUIView(_ uiView: ARView, context: Context) {
        guard !step.isEmpty, context.coordinator.lastStep != step else { return }
        context.coordinator.lastStep = step
        uiView.scene.anchors.removeAll()

        Task { @MainActor in
            guard let type = await manager.selectType(for: step) else { return }
            context.coordinator.lastType = type
            guard let params = await manager.selectParameters(for: type, from: uiView),
                  let coords = params.coordinate, coords.count == 3
            else { return }
            let position = SIMD3<Float>(coords[0], coords[1], coords[2])
            
            let animation: Animation
            switch type {
            case .putIntoContainer:
                animation = PutIntoContainerAnimation(
                    ingredientName: params.ingredient ?? "",
                    position: position,
                    scale: 1.0,
                    isRepeat: true
                )
            case .stir:
                animation = StirAnimation(position: position, scale: 1.0, isRepeat: true)
            case .pourLiquid:
                let liquidColor = UIColor(named: params.color ?? "") ?? .white
                animation = PourLiquidAnimation(
                    position: position,
                    scale: 1.0,
                    isRepeat: false,
                    color: liquidColor
                )
            case .flipPan, .flip:
                animation = FlipAnimation(position: position, scale: 1.0, isRepeat: false)
            case .countdown:
                animation = CountdownAnimation(
                    minutes: Int(params.time ?? 1),
                    position: position,
                    scale: 1.0,
                    isRepeat: false
                )
            case .temperature:
                animation = TemperatureAnimation(
                    temperature: params.temperature ?? 0.0,
                    position: position,
                    scale: 1.0,
                    isRepeat: false
                )
            case .flame:
                let flameLevel = FlameLevel(rawValue: params.FlameLevel ?? FlameLevel.medium.rawValue) ?? .medium
                animation = FlameAnimation(
                    level: flameLevel,
                    position: position,
                    scale: 1.0,
                    isRepeat: false
                )
            case .sprinkle:
                animation = SprinkleAnimation(position: position, scale: 1.0, isRepeat: false)
            case .torch:
                animation = TorchAnimation(position: position, scale: 1.0, isRepeat: false)
            case .cut:
                animation = CutAnimation(position: position, scale: 1.0, isRepeat: false)
            case .peel:
                animation = PeelAnimation(position: position, scale: 1.0, isRepeat: false)
            case .beatEgg:
                animation = BeatEggAnimation(position: position, scale: 1.0, isRepeat: false)
            }

            animation.play(on: uiView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                uiView.scene.anchors.removeAll()
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator {
        var lastStep: String = ""
        var lastType: AnimationType?
    }
}
