//
//  RecipeModels.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/24.
//

import Foundation

struct Equipment: Codable {
    var name: String
    var type: String
    var size: String
    var material: String
    
    
}

struct Ingredient: Codable, Identifiable {
    var id = UUID() // SwiftUI List 需要 identifiable
    var name: String
    var type: String
    var amount: String
    var unit: String
    var weight: String?
    static let examples: [Ingredient] = [
           Ingredient(name: "牛排", type: "食材", amount: "1", unit: "塊", weight: "250g"),
//           Ingredient(name: "油", type: "食材", amount: "2", unit: "湯匙", weight: nil)
       ]
}

struct Preference: Codable {
    var cooking_method: String
    var doneness: String
}

struct RecipeRequest: Codable {
    var equipment: [Equipment]
    var ingredients: [Ingredient]
    var preference: Preference
}

struct RecipeResponse: Codable {
    let dishName: String
    let dishDescription: String
    let recipe: [RecipeStep]

    enum CodingKeys: String, CodingKey {
        case dishName = "dish_name"
        case dishDescription = "dish_description"
        case recipe
    }
}

struct RecipeStep: Codable {
    let step: String
    let time: String
    let temperature: String
    let description: String
    let doneness: String?
}
