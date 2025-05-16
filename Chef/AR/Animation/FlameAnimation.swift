import Foundation
import simd
import RealityKit

enum FlameLevel: String {
    case small
    case medium
    case large
}

class FlameAnimation: Animation {
    private let flame: Entity
    private let level: FlameLevel

    override var prompt: String {
        return """
        動作：調整火焰大小（小/中/大）。
        請依據參數 level (\(level.rawValue)) 選擇合適的火焰資源，並找出最適合放置火焰動畫的三維座標，僅回傳 JSON：
        {"coordinate":[x, y, z], "FlameLevel":"\(level.rawValue)"}
        """
    }

    init(level: FlameLevel = .medium,
         position: SIMD3<Float> = .zero,
         scale: Float = 1.0,
         isRepeat: Bool = false) {
        let resourceName = "flame_\(level.rawValue)"
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz") else {
            fatalError("❌ 找不到 \(resourceName).usdz")
        }
        do {
            flame = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 \(resourceName).usdz：\(error)")
        }
        self.level = level
        super.init(type: .flame, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = flame
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：flame")
        }
    }
}
