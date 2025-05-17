import SwiftUI

// MARK: - Models
struct ScanningState {
    var preference = Preference(
        cooking_method: "",
        dietary_restrictions: [],
        serving_size: "1人份"
    )
    var activeSheet: ScanningSheet?
}

// MARK: - Sheet Type
enum ScanningSheet: Identifiable {
    case ingredient(Ingredient)
    case equipment(Equipment)
    
    var id: String {
        switch self {
        case .ingredient(let item): return "ingredient-\(item.id)"
        case .equipment(let item): return "equipment-\(item.id)"
        }
    }
}

// MARK: - Main View
struct ScanningView: View {
    @StateObject private var viewModel: ScanningViewModel
    @State private var state: ScanningState
    @State private var showCompletionAlert = false
    @State private var scanSummary = ""
    
    init(
        viewModel: ScanningViewModel = ScanningViewModel(),
        initialState: ScanningState = ScanningState()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _state = State(initialValue: initialState)
    }
    @State private var ingredients: [Ingredient] = [
        Ingredient(name: "蛋", type: "蛋類", amount: "2", unit: "顆", preparation: "打散"),
        Ingredient(name: "洋蔥", type: "蔬菜", amount: "1", unit: "顆", preparation: "切絲")
    ]
    @State private var equipmentItems = ["", ""]
    @State private var generatedDishName: String = ""
    @State private var generatedDishDescription: String = ""
    @State private var generatedSteps: [RecipeStep] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    logoView
                    equipmentSection
                    ingredientSection
                    preferenceSection
                    actionButtons
                }
                .ViewStyle()
                .padding(.bottom, 88)

            }
            .navigationTitle("Recipe Generator")
            .sheet(item: $state.activeSheet, content: sheetContent)
            .sheet(isPresented: $viewModel.isShowingImagePreview) {
                imagePreviewSheet
            }
            .alert("掃描完成", isPresented: $showCompletionAlert) {
                Button("完成") {
                    cleanupAfterScan()
                }
            } message: {
                Text(scanSummary)
            }
            .loadingOverlay(isLoading: viewModel.isLoading)
            .imageSourcePicker(
                isPresented: $viewModel.isShowingImagePicker,
                selectedImage: $viewModel.selectedImage,
                onImageSelected: viewModel.handleSelectedImage
            )
        }
    }
    
    // MARK: - View Components
    
    private var logoView: some View {
        HStack {
            Spacer()
            Image("QuickFeatLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
        }
    }
    
    private var equipmentSection: some View {
        EquipmentListView(
            equipment: $viewModel.equipment,
            onAdd: { state.activeSheet = .equipment(Equipment.empty) },
            onEdit: { equipment in state.activeSheet = .equipment(equipment) },
            onDelete: { equipment in viewModel.removeEquipment(equipment) }
        )
    }
    
    private var ingredientSection: some View {
        IngredientListView(
            ingredients: $viewModel.ingredients,
            onAdd: { state.activeSheet = .ingredient(Ingredient.empty) },
            onEdit: { ingredient in state.activeSheet = .ingredient(ingredient) },
            onDelete: { ingredient in viewModel.removeIngredient(ingredient) }
        )
    }
    
    private var preferenceSection: some View {
        PreferenceView(
            cookingMethod: Binding(
                get: { state.preference.cooking_method },
                set: { state.preference.cooking_method = $0 }
            ),
            dietaryRestrictionsInput: Binding(
                get: { state.preference.dietary_restrictions.joined(separator: ", ") },
                set: { state.preference.dietary_restrictions = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
            ),
            servingSize: Binding(
                get: { Int(state.preference.serving_size.replacingOccurrences(of: "人份", with: "")) ?? 1 },
                set: { state.preference.serving_size = "\($0)人份" }
            )
        )
    }
    
    private var actionButtons: some View {
        ActionButtonsView(
            onScan: { viewModel.scanButtonTapped() },
            onGenerate: { viewModel.generateRecipe(with: state.preference) }
        )
    }
    
    private var imagePreviewSheet: some View {
        Group {
            if let image = viewModel.selectedImage {
                ImagePreviewView(
                    image: image,
                    descriptionHint: $viewModel.descriptionHint,
                    onScan: {
                        viewModel.scanImage()
                    }
                )
                .onAppear {
                    // 設置掃描完成的回調
                    viewModel.setScanCompleteHandler { summary in
                        // 關閉預覽視圖
                        viewModel.isShowingImagePreview = false
                        // 顯示完成提示
                        scanSummary = summary
                        showCompletionAlert = true
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func sheetContent(for sheet: ScanningSheet) -> some View {
        switch sheet {
        case .ingredient(let ingredient):
            let binding = binding(for: ingredient, in: $viewModel.ingredients)
            IngredientEditView(
                ingredient: binding,
                onSave: { viewModel.upsertIngredient(binding.wrappedValue) }
            )
        case .equipment(let equipment):
            let binding = binding(for: equipment, in: $viewModel.equipment)
            EquipmentEditView(
                equipment: binding,
                onSave: { viewModel.upsertEquipment(binding.wrappedValue) }
            )
        }
    }
    
    private func binding<T: Identifiable & Equatable>(
        for item: T,
        in array: Binding<[T]>
    ) -> Binding<T> {
        Binding(
            get: {
                if let index = array.wrappedValue.firstIndex(where: { $0.id == item.id }) {
                    return array.wrappedValue[index]
                }
                return item
            },
            set: { newValue in
                if let index = array.wrappedValue.firstIndex(where: { $0.id == item.id }) {
                    array.wrappedValue[index] = newValue
                } else {
                    array.wrappedValue.append(newValue)
                }
            }
        )
    }
    
    private func cleanupAfterScan() {
        viewModel.selectedImage = nil
        viewModel.descriptionHint = ""
        showCompletionAlert = false
        scanSummary = ""
    }
}

// MARK: - View Extensions
private extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        overlay {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}

// MARK: - Model Extensions
private extension Ingredient {
    static var empty: Self {
        Ingredient(name: "", type: "", amount: "", unit: "", preparation: "")
    }
}

private extension Equipment {
    static var empty: Self {
        Equipment(name: "", type: "", size: "", material: "", power_source: "")
    }
}

// MARK: - Preview
#Preview {
    let sampleViewModel = ScanningViewModel()
    sampleViewModel.ingredients = [
        Ingredient(
            name: "蛋",
            type: "蛋類",
            amount: "2",
            unit: "顆",
            preparation: "打散"
        )
    ]
    sampleViewModel.equipment = [
        Equipment(
            name: "平底鍋",
            type: "鍋具",
            size: "小型",
            material: "不沾",
            power_source: "電"
        )
    ]
    
    let initialState = ScanningState(
        preference: Preference(
            cooking_method: "煎",
            dietary_restrictions: ["無麩質"],
            serving_size: "1人份"
        )
    )
    
    return ScanningView(
        viewModel: sampleViewModel,
        initialState: initialState
    )
}

// MARK: - Sample Data Preview
#Preview("Sample Data") {
    let sampleViewModel = ScanningViewModel()
    sampleViewModel.ingredients = [
        Ingredient(
            name: "蛋",
            type: "蛋類",
            amount: "2",
            unit: "顆",
            preparation: "打散"
        )
    ]
    sampleViewModel.equipment = [
        Equipment(
            name: "平底鍋",
            type: "鍋具",
            size: "小型",
            material: "不沾",
            power_source: "電"
        )
    ]
    
    let initialState = ScanningState(
        preference: Preference(
            cooking_method: "煎",
            dietary_restrictions: ["無麩質"],
            serving_size: "1人份"
        )
    )
    
    return ScanningView(
        viewModel: sampleViewModel,
        initialState: initialState
    )
}

