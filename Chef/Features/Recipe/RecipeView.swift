//
//  RecipeView.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//
import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel

    var body: some View {
        VStack(spacing: 16) {
            // 頂部圓形圖片區（暫用圖示）
            Image(systemName: "leaf")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .padding(.top, 20)

            // 食譜標題
            Text("RECIPE")
                .font(.headline)
                .foregroundColor(.orange)

            // 菜名
            Text(viewModel.dishName)
                .font(.title)
                .bold()

            // 食譜描述
            Text("Ingredients")
                .font(.subheadline)
                .foregroundColor(.gray)

            // 步驟區塊
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.steps.indices, id: \.self) { index in
                    Text("Step \(index + 1): \(viewModel.steps[index].description)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    let sampleStep = RecipeStep(step: "1", time: "5m", temperature: "120°C", description: "預熱平底鍋", doneness: nil)
    let response = RecipeResponse(dishName: "SALAD", dishDescription: "A light healthy dish", recipe: [sampleStep, sampleStep])
    let viewModel = RecipeViewModel(response: response)
    return RecipeView(viewModel: viewModel)
}

