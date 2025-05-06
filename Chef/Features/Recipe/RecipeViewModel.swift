
//
//  RecipeViewModel.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import Foundation

final class RecipeViewModel: ObservableObject {
    let dishName: String
    let dishDescription: String
    let steps: [RecipeStep]

    init(response: RecipeResponse) {
        self.dishName = response.dishName
        self.dishDescription = response.dishDescription
        self.steps = response.recipe
    }
}
