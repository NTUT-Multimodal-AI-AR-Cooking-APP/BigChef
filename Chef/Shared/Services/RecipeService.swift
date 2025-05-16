import Foundation

enum RecipeService {
    // MARK: - Constants
    private static let baseURL = "http://localhost:8080"
    
    // MARK: - Recipe Generation
    static func generateRecipe(
        using request: SuggestRecipeRequest,
        completion: @escaping (Result<SuggestRecipeResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/v1/recipe/suggest") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("🟢 發送食譜生成請求：\n\(jsonString)")
            }
        } catch {
            print("❌ 請求編碼失敗：\(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ 網路請求失敗：\(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ 無效的伺服器回應")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ HTTP 錯誤：\(httpResponse.statusCode)")
                completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("❌ 沒有收到資料")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(SuggestRecipeResponse.self, from: data)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("✅ AI 回傳食譜：\n\(jsonString)")
                }
                completion(.success(decoded))
            } catch {
                if let raw = String(data: data, encoding: .utf8) {
                    print("🔴 AI 回傳原始資料：\n\(raw)")
                }
                print("❌ 解碼失敗：\(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Image Scanning
    static func scanImage(
        using request: ScanImageRequest,
        completion: @escaping (Result<ScanImageResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/api/v1/recipe/ingredient") else {
            print("❌ 無效的 URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            
            // 只打印請求的描述提示，不打印圖片數據
            let requestInfo = """
            🟢 發送圖片掃描請求：
            描述提示：\(request.description_hint)
            圖片大小：\(request.image.count) 字元
            """
            print(requestInfo)
        } catch {
            print("❌ 請求編碼失敗：\(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("❌ 網路請求失敗：\(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ 無效的伺服器回應")
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ HTTP 錯誤：\(httpResponse.statusCode)")
                completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("❌ 沒有收到資料")
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ScanImageResponse.self, from: data)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("✅ AI 回傳掃描結果：\n\(jsonString)")
                    print("📝 識別摘要：\(response.summary)")
                    print("🥬 識別出 \(response.ingredients.count) 個食材")
                    print("🔧 識別出 \(response.equipment.count) 個設備")
                }
                completion(.success(response))
            } catch {
                if let raw = String(data: data, encoding: .utf8) {
                    print("🔴 AI 回傳原始資料：\n\(raw)")
                }
                print("❌ 解碼失敗：\(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無效的 URL"
        case .invalidResponse:
            return "無效的伺服器回應"
        case .httpError(let code):
            return "HTTP 錯誤：\(code)"
        case .noData:
            return "沒有收到資料"
        }
    }
} 
