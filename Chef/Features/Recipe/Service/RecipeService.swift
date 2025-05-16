//
//  RecipeAPI.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/24.
//

import Foundation

struct RecipeService {
    static func generateRecipe(
        using request: SuggestRecipeRequest,
        completion: @escaping (Result<SuggestRecipeResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "http://localhost:8080/api/v1/recipe/suggest") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("🟢 實際送出的 JSON：\n\(jsonString)")
            }
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(SuggestRecipeResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                if let raw = String(data: data, encoding: .utf8) {
                    print("🔴 回傳原始 JSON：\n\(raw)")
                }
                print("❌ 解碼失敗：\(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
