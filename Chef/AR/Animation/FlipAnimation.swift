import Foundation
import simd
import RealityKit

class FlipAnimation: Animation {
    private var flip: Entity = Entity()
    override var prompt: String {
        return """
        動作：翻面食材。
        請根據以下截圖分析，找出最適合放置翻面動畫的三維座標，並僅回傳 JSON 格式：
        {"coordinate":[x, y, z]}
        其中 x, y, z 為 0 到 1 之間的浮點數列表。
        """
    }

    init(position: SIMD3<Float> = .zero,
         scale: Float = 1.0,
         isRepeat: Bool = true) {
        super.init(type: .flip,
                   position: position,
                   scale: scale,
                   isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        download(resourceName: "flip") { [weak self] node in
            guard let self = self, let node = node else {
                print("⚠️ 載入 flip.usdz 失敗11111")
                return
            }
            self.flip = node

            let anchor = AnchorEntity(world: self.position)
            anchor.addChild(node)
            arView.scene.addAnchor(anchor)

            if let animation = node.availableAnimations.first {
                let resource = self.isRepeat
                    ? animation.repeat(duration: .infinity)
                    : animation
                _ = node.playAnimation(resource)
            } else {
                print("⚠️ USDZ 檔案無可用動畫：flipEntity")
            }
        }
    }
}
