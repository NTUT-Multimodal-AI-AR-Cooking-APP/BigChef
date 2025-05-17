//
//  ScanningViewModel.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/3.
//

import Foundation

final class ScanningViewModel: ObservableObject {
    // MARK: - Recipe Generation
    @Published var isLoading: Bool = false
    @Published var equipmentItems: [String] = []
    @Published var ingredients: [Ingredient] = []
    var onEquipmentScanRequested: (() -> Void)?
    func equipmentButtonTapped() { onEquipmentScanRequested?() }
    
    var onRecipeGenerated: ((SuggestRecipeResponse) -> Void)?
    var onScanRequested: (() -> Void)?

    func scanButtonTapped() { onScanRequested?() }
    func generateRecipe() {
        print("🚀 開始準備請求資料")
        isLoading = true

        let equipment = equipmentItems.map {
            Equipment(name: $0, type: "鍋具", size: "中型", material: "不鏽鋼", power_source: "電")
        }

        let preference = Preference(cooking_method: "煎", dietary_restrictions: ["無"], serving_size: "1人份")

        let request = SuggestRecipeRequest(
            available_ingredients: ingredients,
            available_equipment: equipment,
            preference: preference
        )

        RecipeService.generateRecipe(using: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let resp):
                    print("✅ 成功解析 JSON，菜名：\(resp.dish_name)")
                    print("🎉 觸發畫面跳轉 → RecipeView")
                    self.onRecipeGenerated?(resp)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.isLoading = false
                    }

                case .failure(let err):
                    self.isLoading = false
                    print("❌ 錯誤：\(err.localizedDescription)")
                }
            }
        }
    }

 
}
