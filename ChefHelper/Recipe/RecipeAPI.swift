//
//  RecipeAPI.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/24.
//

import Foundation

struct RecipeAPI {
    static func generateRecipe(
        equipment: [[String: String]],
        ingredients: [[String: String]],
        preference: [String: String],
        completion: @escaping (Result<RecipeResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "http://localhost:8080/generate-recipe") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "equipment": equipment,
            "ingredients": ingredients,
            "preference": preference
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey: "無回應資料"])
                completion(.failure(noDataError))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}
