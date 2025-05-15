import Foundation
import simd
import RealityKit

class CountdownAnimation: Animation {
    private let countdown: Entity
    private let minutes: Int
    override var prompt: String {
        return """
        動作：顯示倒數計時（\\(minutes) 分鐘）。
        請根據以下截圖分析，找出最適合放置倒數計時動畫的三維座標，並僅回傳 JSON 格式：
        {"coordinate":[x, y, z], "minutes":\\(minutes)}
        其中 x, y, z 為 0 到 1 之間的浮點數列表。
        """
    }
    init(minutes: Int = 1,
         position: SIMD3<Float> = .zero,
         scale: Float = 1.0,
         isRepeat: Bool = false) {
        guard let url = Bundle.main.url(forResource: "countdown", withExtension: "usdz") else {
            fatalError("❌ 找不到 countdown.usdz")
        }
        do {
            countdown = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 countdown.usdz：\(error)")
        }
        self.minutes = minutes
        super.init(type: .countdown, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = countdown
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：countdown")
        }
    }
}
