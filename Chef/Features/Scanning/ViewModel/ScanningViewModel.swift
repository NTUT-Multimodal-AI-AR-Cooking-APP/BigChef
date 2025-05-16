import Foundation
import UIKit

final class ScanningViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isLoading = false
    @Published var equipment: [Equipment] = []
    @Published var ingredients: [Ingredient] = []
    @Published var isShowingImagePicker = false
    @Published var isShowingImagePreview = false
    @Published var selectedImage: UIImage?
    @Published var descriptionHint = ""
    
    // MARK: - Callbacks
    var onEquipmentScanRequested: (() -> Void)?
    var onScanRequested: (() -> Void)?
    var onRecipeGenerated: ((SuggestRecipeResponse) -> Void)?
    /// 掃描完成時的回調，包含掃描結果和摘要
    var onScanCompleted: ((ScanImageResponse, String) -> Void)?
    
    // MARK: - Public Methods
    
    /// 掃描設備按鈕點擊
    func equipmentButtonTapped() {
        onEquipmentScanRequested?()
    }
    
    /// 掃描食材按鈕點擊
    func scanButtonTapped() {
        isShowingImagePicker = true
    }
    
    /// 更新偏好設定
    func updatePreference(_ newPreference: Preference) {
        // 確保必要欄位有值
        self.preference = Preference(
            cooking_method: newPreference.cooking_method.isEmpty ? "一般烹調" : newPreference.cooking_method,
            dietary_restrictions: newPreference.dietary_restrictions,
            serving_size: newPreference.serving_size.isEmpty ? "1人份" : newPreference.serving_size
        )
    }
    
    /// 移除設備
    func removeEquipment(_ equipment: Equipment) {
        self.equipment.removeAll { $0.id == equipment.id }
    }
    
    /// 移除食材
    func removeIngredient(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
    }
    
    /// 更新或新增食材
    func upsertIngredient(_ new: Ingredient) {
        if let idx = ingredients.firstIndex(where: { $0.id == new.id }) {
            ingredients[idx] = new
        } else {
            ingredients.append(new)
        }
    }
    
    /// 更新或新增設備
    func upsertEquipment(_ new: Equipment) {
        if let idx = equipment.firstIndex(where: { $0.id == new.id }) {
            equipment[idx] = new
        } else {
            equipment.append(new)
        }
    }
    
    /// 產生食譜
    func generateRecipe(with preference: Preference) {
        guard !isLoading else { return }
        
        print("🚀 開始準備請求資料")
        isLoading = true
        
        // 確保使用更新後的偏好設定
        updatePreference(preference)
        
        let request = SuggestRecipeRequest(
            available_ingredients: ingredients,
            available_equipment: equipment,
            preference: self.preference  // 使用更新後的偏好設定
        )
        
        // 打印請求資料以便調試
        print("📝 請求資料：")
        print("- 製作方式：\(self.preference.cooking_method)")
        print("- 份量：\(self.preference.serving_size)")
        print("- 飲食限制：\(self.preference.dietary_restrictions)")
        
        RecipeService.generateRecipe(using: request) { [weak self] (result: Result<SuggestRecipeResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                defer { self.isLoading = false }
                
                switch result {
                case .success(let response):
                    print("✅ 成功解析 JSON，菜名：\(response.dish_name)")
                    self.onRecipeGenerated?(response)
                case .failure(let error):
                    print("❌ 錯誤：\(error.localizedDescription)")
                    // TODO: 處理錯誤情況
                }
            }
        }
    }
    
    func handleSelectedImage(_ image: UIImage) {
        selectedImage = image
        isShowingImagePreview = true
    }
    
    // MARK: - Private Properties
    private var preference = Preference(
        cooking_method: "無指定",  // 預設值
        dietary_restrictions: [],
        serving_size: "1人份"      // 預設值
    )
    
    /// 設置掃描完成的回調
    func setScanCompleteHandler(_ handler: @escaping (String) -> Void) {
        // 將舊的回調轉換為新的格式
        onScanCompleted = { _, summary in
            handler(summary)
        }
    }
    
    func scanImage() {
        guard let image = selectedImage,
              let base64Image = ImageCompressor.compressToBase64(image: image) else {
            print("❌ 圖片壓縮失敗")
            return
        }
        
        isLoading = true
        
        let request = ScanImageRequest(
            image: base64Image,
            description_hint: descriptionHint
        )
        
        RecipeService.scanImage(using: request) { [weak self] (result: Result<ScanImageResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    // 更新識別出的食材和設備
                    response.ingredients.forEach { self.upsertIngredient($0) }
                    response.equipment.forEach { self.upsertEquipment($0) }
                    
                    // 使用單一的回調通知掃描完成，同時傳遞掃描結果和摘要
                    self.onScanCompleted?(response, response.summary)
                case .failure(let error):
                    print("❌ 掃描失敗：\(error.localizedDescription)")
                    // TODO: 處理錯誤情況
                }
            }
        }
    }
}
