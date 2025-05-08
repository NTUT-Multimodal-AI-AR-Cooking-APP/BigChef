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
            ScrollView {
                VStack(spacing: 16) {
                    // 頂部圖片
                    Image(systemName: "leaf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .padding(.top, 20)

                    Text("RECIPE")
                        .font(.headline)
                        .foregroundColor(.orange)

                    Text(viewModel.dishName)
                        .font(.title)
                        .bold()

                    Text("Ingredients")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("烹飪步驟")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    let maxTextWidth = UIScreen.main.bounds.width * 0.8

                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.steps.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("步驟 \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(viewModel.steps[index].description)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(width: maxTextWidth, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }

            // 按鈕區拉出來，不跟著 ScrollView 滾動
            Button(action: {
                viewModel.cookButtonTapped()
                // 將跳轉 CameraCookingView 的邏輯放這裡
            }) {
                Text("開始烹飪")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brandOrange)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}

#Preview {
    let sampleStep = RecipeStep(step: "1", time: "5m", temperature: "120°C", description: "將牛排從冰箱取出，放置於室溫約 20 分鐘，讓其回溫。接著在牛排兩面均勻抹上橄欖油與海鹽，並撒上現磨黑胡椒。預熱平底鍋至中高溫，將牛排放入鍋中，每面煎約 2 分鐘，煎至表面微焦並鎖住肉汁。", doneness: nil)
    let response = RecipeResponse(dishName: "SALAD", dishDescription: "A light healthy dish", recipe: [sampleStep, sampleStep])
    let viewModel = RecipeViewModel(response: response)
    return RecipeView(viewModel: viewModel)
}
