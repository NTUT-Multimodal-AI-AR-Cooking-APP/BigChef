import Foundation
import GoogleGenerativeAI
import simd
import UIKit
import RealityKit

class AnimationManger {
    private let model: GenerativeModel
    
    init() {
        let apiKey = Bundle.main
            .object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String
        ?? ""
        self.model = GenerativeModel(name: "gemini-2.0-flash-lite", apiKey: apiKey)
    }
    
    func selectType(for step: String) async -> AnimationType? {
        let choices = AnimationType.allCases
            .map { $0.rawValue }
            .joined(separator: ", ")
        let prompt = """
        請根據以下烹飪步驟，從 [\(choices)] 中選擇最符合的 rawValue，僅回傳 enum 的 rawValue，不要其他文字。
        步驟：\(step)
        """
        
        print("📨 發送 Prompt：\(prompt)")
        
        do {
            let response = try await model.generateContent(prompt)
            
            let raw = response.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                ?? ""

            let cleaned = raw.lowercased()
            if let match = AnimationType.allCases.first(where: { $0.rawValue.lowercased() == cleaned }) {
                print("✅ 成功匹配 AnimationType: \(match)")
                return match
            } else {
                print("❌ 無法匹配的類型：\(cleaned)")
                return nil
            }
            
        } catch {
            print("❌ Gemini SDK 發生錯誤：\(error.localizedDescription)")
            return nil
        }
    }
    
    func selectParameters(for type: AnimationType, from arView: ARView) async -> AnimationParameters? {
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
            print("⚠️ 無法取得 key window")
            return nil
        }
        // Take an ARView snapshot asynchronously
        let screenshot: UIImage = await withCheckedContinuation { continuation in
            arView.snapshot(saveToHDR: false) { image in
                if let image = image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: UIImage())
                }
            }
        }
        let dummyAnimation: Animation = {
            switch type {
            case .putIntoContainer:
                return PutIntoContainerAnimation(
                    ingredientName: "",
                    position: .zero,
                    scale: 1.0,
                    isRepeat: true
                )
            case .stir:
                return StirAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: true
                )
            case .pourLiquid:
                return PourLiquidAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false,
                    color: .white
                )
            case .flipPan, .flip:
                return FlipAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .countdown:
                return CountdownAnimation(
                    minutes: 1,
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .temperature:
                return TemperatureAnimation(
                    temperature: 0.0,
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .flame:
                return FlameAnimation(
                    level: .medium,
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .sprinkle:
                return SprinkleAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .torch:
                return TorchAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .cut:
                return CutAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .peel:
                return PeelAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            case .beatEgg:
                return BeatEggAnimation(
                    position: .zero,
                    scale: 1.0,
                    isRepeat: false
                )
            }
        }()
        let promptText = dummyAnimation.prompt
        
        let textPart  = ModelContent.Part.text(promptText)
        let imagePart = ModelContent.Part.png(screenshot.pngData()!)
        
        print("📨 發送 Prompt：\(promptText)")
        
        do {
            let response = try await model.generateContent(textPart, imagePart)
            let raw = response.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                ?? ""
            // 清理可能的 Markdown 反引號與程式碼區塊
            var jsonString = raw
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .replacingOccurrences(of: "`", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            print("🔧 清理后 JSON 字串：\(jsonString)")
            if let startIndex = jsonString.firstIndex(where: { $0 == "{" || $0 == "[" }) {
                jsonString = String(jsonString[startIndex...])
                print("🔧 裁切前置文字后 JSON：\(jsonString)")
            }
            guard let data = jsonString.data(using: .utf8) else {
                print("⚠️ 無法將回傳轉為 Data：\(jsonString)")
                return nil
            }
            let decoder = JSONDecoder()
            let params: AnimationParameters
            do {
                params = try decoder.decode(AnimationParameters.self, from: data)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("⚠️ JSON 解码类型不符 (\(type))，路径：\(context.codingPath)，原始：\(jsonString)")
                return nil
            }
            print("✅ 解析參數：\(params)")
            return params
        } catch {
            print("❌ 解析參數失敗：\(error)")
            return nil
        }
    }
}

struct AnimationParameters: Codable {
    var ingredient: String?
    var color: String?
    var coordinate: [Float]?
    var time: Float?
    var temperature: Float?
    var FlameLevel: String?
}
