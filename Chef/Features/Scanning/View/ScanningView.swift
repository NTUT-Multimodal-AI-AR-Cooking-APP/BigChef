//
//  ContentView.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/9.
//

import SwiftUI

struct ScanningView: View {
    @StateObject var viewModel: ScanningViewModel

    init(viewModel: ScanningViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        print("👀 View 使用的 vm = \(Unmanaged.passUnretained(viewModel).toOpaque())")
    }
    @State private var ingredients: [Ingredient] = Ingredient.examples
    @State private var equipmentItems = ["", ""]
    @State private var generatedDishName: String = ""
    @State private var generatedDishDescription: String = ""
    @State private var generatedSteps: [RecipeStep] = []
    @State private var showingReceipt: Bool = false
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing:28) {
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
                .padding(.bottom, 88)
            }
            
            .padding(.horizontal, 24)
            .ignoresSafeArea(edges: .top)
            
            if viewModel.isLoading { RecipeLoadingView() }
        }
    }
            
    var EquipmentButton : some View {
        Button("Scanning") {
            viewModel.equipmentButtonTapped()
        }
        .scanningButtonStyle().scaleEffect(0.8)
    }
    var IngredientButton : some View {
        Button("Scanning") {
            viewModel.scanButtonTapped()
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
                viewModel.equipmentItems = equipmentItems
                viewModel.ingredients = ingredients
                viewModel.generateRecipe()
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
    
    
}

private extension ScanningView {
    var EquipmentInfoView : some View{
        VStack{
            Text("EQUIPMENT")
            VStack(spacing: 8) {
                ForEach(equipmentItems.indices, id: \.self) { index in
                    TextField("Item", text: $equipmentItems[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                }
            }
        }
    }
    var IngredientInfoView : some View{
        VStack{
            HStack {
                Text("INGREDIENT")
                Spacer()
                Button(action: {
                    // 點擊事件可填入你要的動作
                    print("➕ Add Ingredient Tapped")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.brandOrange)
                        .font(.title2)
                }
            }
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
    ScanningView(viewModel: ScanningViewModel())
}

