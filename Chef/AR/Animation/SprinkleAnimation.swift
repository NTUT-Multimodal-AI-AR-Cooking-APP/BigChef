import Foundation
import simd
import RealityKit

class SprinkleAnimation: Animation {
    private let sprinkle: Entity

    override var prompt: String {
        return """
        動作：撒上調味料。
        請根據以下截圖分析，找出最適合放置撒調味料動畫的三維座標，並僅回傳 JSON 格式：
        {"coordinate":[x, y, z]}
        其中 x, y, z 為 0 到 1 之間的浮點數列表。
        """
    }
    init(position: SIMD3<Float> = .zero, scale: Float = 1.0, isRepeat: Bool = false) {
        guard let url = Bundle.main.url(forResource: "sprinkle", withExtension: "usdz") else {
            fatalError("❌ 找不到 sprinkle.usdz")
        }
        do {
            sprinkle = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 sprinkle.usdz：\(error)")
        }
        super.init(type: .sprinkle, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = sprinkle
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：sprinkle")
        }
    }
}
