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
    var onRecipeGenerated: ((RecipeResponse) -> Void)?
    
    var onScanRequested: (() -> Void)?

    func scanButtonTapped() { onScanRequested?() }
    func generateRecipe() {
        print("🚀 開始準備請求資料")
        isLoading = true
        /* ……組 equipment / ingredients / preference 省略…… */
        let equipment = equipmentItems.map {
            Equipment(name: $0, type: "鍋具", size: "中型", material: "不鏽鋼")
        }
        
        let ingredientsDict = ingredients.map {
            [
                "name": $0.name,
                "type": $0.type,
                "amount": $0.amount,
                "unit": $0.unit
            ]
        }
        
        let equipmentDict = equipment.map {
            [
                "name": $0.name,
                "type": $0.type,
                "size": $0.size,
                "material": $0.material
            ]
        }
        
        let preference: [String: String] = [
            "cooking_method": "無",
            "doneness": "無"
        ]
        
        RecipeAPI.generateRecipe(equipment: equipmentDict,
                                 ingredients: ingredientsDict,
                                 preference: preference) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                switch result {
                case .success(let resp):
                    print("✅ 成功解析 JSON，菜名：\(resp.dishName)")
                    print("🎉 觸發畫面跳轉 → RecipeView")
                    self.onRecipeGenerated?(resp)          // ① push

                    // ② 稍晚 0.2 秒關掉 loading，避免把畫面遮住
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

    /*
    func generateRecipe() {
        print("🚀 開始準備請求資料")
        isLoading = true

        let equipment = equipmentItems.map {
            Equipment(name: $0, type: "鍋具", size: "中型", material: "不鏽鋼")
        }
        
        let ingredientsDict = ingredients.map {
            [
                "name": $0.name,
                "type": $0.type,
                "amount": $0.amount,
                "unit": $0.unit
            ]
        }
        
        let equipmentDict = equipment.map {
            [
                "name": $0.name,
                "type": $0.type,
                "size": $0.size,
                "material": $0.material
            ]
        }
        
        let preference: [String: String] = [
            "cooking_method": "無",
            "doneness": "無"
        ]
        
        RecipeAPI.generateRecipe(equipment: equipmentDict, ingredients: ingredientsDict, preference: preference) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let recipeResponse):
                    print("✅ 成功解析 JSON，菜名：\(recipeResponse.dishName)")
                    print("📌 菜名：\(recipeResponse.dishName)")
                    print("📌 描述：\(recipeResponse.dishDescription)")
                    print("📌 步驟數量：\(recipeResponse.recipe.count)")
                    print("🎉 觸發畫面跳轉 → RecipeView")
                    self.onRecipeGenerated?(recipeResponse)
                    // 2️⃣ 等下一個 runloop 再關閉 loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.isLoading = false
                    }

                case .failure(let error):
                    print("❌ 錯誤：\(error.localizedDescription)")
                    print("🔍 錯誤類型：\(error.localizedDescription)")
                }
            }
        }
    }
*/
}

