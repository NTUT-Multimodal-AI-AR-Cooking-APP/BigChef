import Foundation
import simd
import RealityKit
import UIKit

class PourLiquidAnimation: Animation {
    private let pourLiquid: Entity
    private let color: UIColor

    override var prompt: String {
        return """
        動作：將液體倒入容器。
        液體顏色：\\(color)
        請根據以下截圖分析，找出最適合放置倒液體動畫的三維座標，並僅回傳 JSON 格式：
        {"coordinate":[x, y, z], "color":"\\(color)"}
        其中 x, y, z 為 0 到 1 之間的浮點數列表；顏色請以 UIKit 類型輸出（例如 UIExtendedSRGBColorSpace 形式）。
        """
    }

    init(position: SIMD3<Float> = .zero,
         scale: Float = 1.0,
         isRepeat: Bool = false,
         color: UIColor = .white) {
        self.color = color
        guard let url = Bundle.main.url(forResource: "pourLiquid", withExtension: "usdz") else {
            fatalError("❌ 找不到 pourLiquid.usdz")
        }
        do {
            pourLiquid = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 pourLiquid.usdz：\(error)")
        }
        super.init(type: .pourLiquid, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = pourLiquid
        if var model = entity as? ModelEntity {
            model.model?.materials = [SimpleMaterial(color: color, isMetallic: false)]
        }
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：pourLiquid")
        }
    }
}
