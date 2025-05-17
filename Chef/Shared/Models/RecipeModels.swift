//
//  RecipeModels.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/24.
//

import Foundation

struct Ingredient: Codable, Identifiable {
    var id = UUID() // ✅ 本地用於 SwiftUI 辨識，不參與 JSON 傳輸

    let name: String
    let type: String
    let amount: String
    let unit: String
    let preparation: String

    private enum CodingKeys: String, CodingKey {
        case name, type, amount, unit, preparation
        // ❌ 不包含 id
    }
}
struct Equipment: Codable {
    let name: String
    let type: String
    let size: String
    let material: String
    let power_source: String
}

struct Preference: Codable {
    let cooking_method: String
    let dietary_restrictions: [String]
    let serving_size: String
}

struct SuggestRecipeRequest: Codable {
    let available_ingredients: [Ingredient]
    let available_equipment: [Equipment]
    let preference: Preference
}

struct SuggestRecipeResponse: Codable {
    let dish_name: String
    let dish_description: String
    let ingredients: [Ingredient]
    let equipment: [Equipment]
    let recipe: [RecipeStep]
}

struct RecipeStep: Codable, Identifiable {
    var id: Int { step_number }
    let step_number: Int
    let title: String
    let description: String
    let actions: [Action]
    let estimated_total_time: String
    let temperature: String
    let warnings: String?
    let notes: String
}

struct Action: Codable {
    let action: String
    let tool_required: String
    let material_required: [String]
    let time_minutes: Int
    let instruction_detail: String
}
