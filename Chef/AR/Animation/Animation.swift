import Foundation
import simd
import RealityKit
class Animation {
    
    open var prompt: String {
        return "動作：\(type.rawValue)。"
    }
    let type: AnimationType
    var position: SIMD3<Float>
    var scale: Float
    var isRepeat: Bool = true
    
    init(
        type: AnimationType,
        position: SIMD3<Float>,
        scale: Float,
        isRepeat: Bool = true) {
        self.type = type
        self.position = position
        self.scale = scale
        self.isRepeat = isRepeat
    }
    
    func play(on arView: ARView) {
        fatalError("Subclasses must override play() to implement animation playback.")
    }
    
    func download(resourceName: String, completion: @escaping (Entity?) -> Void) {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz") else {
            print("❌ 找不到 \(resourceName).usdz")
            completion(nil)
            return
        }
        DispatchQueue.main.async {
            do {
                let entity = try Entity.load(contentsOf: url)
                print("✅ 成功載入 \(resourceName).usdz2222")
                completion(entity)
            } catch {
                print("❌ 無法載入 \(resourceName).usdz：\(error)")
                completion(nil)
            }
        }
    }

}

enum AnimationType: String, CaseIterable {
    case putIntoContainer
    case stir
    case pourLiquid
    case flipPan
    case countdown
    case temperature
    case flame
    case sprinkle
    case torch
    case cut
    case peel
    case flip
    case beatEgg
}
