import Foundation
import simd
import RealityKit

class PutIntoContainerAnimation: Animation {
    private let ingredientName: String
    private let ingredient: Entity

    override var prompt: String {
        return """
        動作：將食材「\(ingredientName)」放入容器。
        請根據以下截圖分析，找出食材掉落前出現的座標（Coordinate），並僅回傳 JSON：
        {"Coordinate":[x, y, z], "ingredient":"\(ingredientName)"}
        其中 x, y, z 為 0 到 1 之間的浮點數列表。
        其中 Coordinate 為食材掉落前出現的座標。
        """
    }

    init(ingredientName: String, position: SIMD3<Float> = .zero, scale: Float = 1.0, isRepeat: Bool = true) {
        self.ingredientName = ingredientName
        guard let url = Bundle.main.url(forResource: ingredientName, withExtension: "usdz") else {
            fatalError("❌ 找不到 \(ingredientName).usdz")
        }
        do {
            ingredient = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 \(ingredientName).usdz：\(error)")
        }
        super.init(type: .putIntoContainer, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = ingredient
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：putIntoContainer")
        }
    }
}
