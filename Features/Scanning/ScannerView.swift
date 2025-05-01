//
//  ContentView.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/9.
//

import SwiftUI

struct ScannerView: View {
    @State private var ingredients: [Ingredient] = Ingredient.examples
    @State private var equipmentItems = ["", ""]
    @State private var generatedDishName: String = ""
    @State private var generatedDishDescription: String = ""
    @State private var generatedSteps: [RecipeStep] = []
    @State private var showingReceipt: Bool = false
    
    var body: some View {
        ScrollView{
            VStack(spacing:10) {
                HStack {
                    Spacer()
                    Image("QuickFeatLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                
                EquipmentInfoView
                EquipmentButton
                IngredientInfoView
                IngredientButton
                PeopleSettingView
            }
            .ViewStyle()
            .sheet(isPresented: $showingReceipt) {
                GeneratedReceiptView(
                    generatedDishName: generatedDishName,
                    generatedDishDescription: generatedDishDescription,
                    generatedSteps: generatedSteps
                )
            }
        }
        .overlay(
            VStack {
                Spacer()
                HomeBar()
            })
            
            
        }
            
    var EquipmentButton : some View {
        Button("Scaning") {
            equipmentItems = ["Pan"]
        }
        .scanningButtonStyle().scaleEffect(0.8)
    }
    var IngredientButton : some View {
        Button("Scaning") {
        }
        .scanningButtonStyle().scaleEffect(0.8)
    }
    var PeopleSettingView: some View {
        VStack(){
            Image(systemName: "person.3.fill") // or your custom image
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.brandOrange)

            Text("PEOPLE")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Button(action: {
                print("Generate tapped1")
                generateRecipe()
            }) {
                Text("Generate Recipe")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandOrange)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .scaleEffect(0.9)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 1.0, green: 0.8, blue: 0.7))
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
    
    func generateRecipe() {
        print("🚀 開始準備請求資料")
        
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
        
        RecipeAPI.generateRecipe(equipment: equipmentDict, ingredients: ingredientsDict, preference: preference) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipeResponse):
                    self.generatedDishName = recipeResponse.dishName
                    self.generatedDishDescription = recipeResponse.dishDescription
                    self.generatedSteps = recipeResponse.recipe
                    print("✅ 成功解析 JSON，菜名：\(recipeResponse.dishName)")
                    self.showingReceipt = true
                case .failure(let error):
                    self.generatedDishName = ""
                    self.generatedDishDescription = "❌ 發生錯誤：\(error.localizedDescription)"
                    self.generatedSteps = []
                    print("❌ 請求或解析失敗：\(error)")
                }
            }
        }
    }
    
}

private extension ScannerView {
    var EquipmentInfoView : some View{
        VStack{
            Text("INGREDIENT")
            VStack(spacing: 8) {
                ForEach(equipmentItems.indices, id: \.self) { index in
                    TextField("Item", text: $equipmentItems[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        }
    }
    var IngredientInfoView : some View{
        VStack{
            Text("INGREDIENT")
            List {
                ForEach(ingredients) { ingredient in
                    Text(ingredient.name)
                }
            }
            .listStyle(.plain)
            .frame(height: 120)
            .foregroundColor(.black)
        }
    }
}



#Preview {
    ScannerView()
}

