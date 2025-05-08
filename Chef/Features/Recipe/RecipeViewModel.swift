
//
//  RecipeViewModel.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import Foundation

// RecipeViewModel.swift
final class RecipeViewModel: ObservableObject {
    let dishName: String
    let dishDescription: String
    let steps: [RecipeStep]

    // ① 新增對外事件
    var onCookRequested: (() -> Void)?

    init(response: RecipeResponse) {
        self.dishName        = response.dishName
        self.dishDescription = response.dishDescription
        self.steps           = response.recipe
    }

    // ② 按鈕點擊時呼叫
    func cookButtonTapped() { onCookRequested?() }
}
