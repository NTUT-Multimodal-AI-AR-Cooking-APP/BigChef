import Foundation
import simd
import RealityKit

class TemperatureAnimation: Animation {
    private let temperatureValue: Float
    private let temperatureEntity: Entity
    override var prompt: String {
        return """
        動作：顯示溫度讀數 (\(temperatureValue)°C)。
        請根據以下截圖分析，找出最適合放置溫度動畫的三維座標，並僅回傳 JSON 格式：
        {"coordinate":[x, y, z], "temperature":\(temperatureValue)}
        其中 x, y, z 為 0 到 1 之間的浮點數列表。
        """
    }
    init(temperature: Float, position: SIMD3<Float> = .zero, scale: Float = 1.0, isRepeat: Bool = false) {
        self.temperatureValue = temperature
        guard let url = Bundle.main.url(forResource: "temperature", withExtension: "usdz") else {
            fatalError("❌ 找不到 temperature.usdz")
        }
        do {
            temperatureEntity = try Entity.load(contentsOf: url)
        } catch {
            fatalError("❌ 無法載入 temperature.usdz：\(error)")
        }
        super.init(type: .temperature, position: position, scale: scale, isRepeat: isRepeat)
    }

    override func play(on arView: ARView) {
        let entity = temperatureEntity
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        if let animation = entity.availableAnimations.first {
            let resource = isRepeat
                ? animation.repeat(duration: .infinity)
                : animation
            _ = entity.playAnimation(resource)
        } else {
            print("⚠️ USDZ 檔案無可用動畫：temperature")
        }
    }
}
