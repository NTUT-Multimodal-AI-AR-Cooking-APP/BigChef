//
//  Home.swift
//  ChefHelper
//
//  Created by 羅辰澔 on 2025/5/7.
//

import SwiftUI

struct HomeView: View {
    // Binding
    @ObservedObject  var viewModel : HomeViewModel
    @State var isNavigationToDish = false
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView(Strings.fetchingRecords)
                case .error(let message):
                    ErrorView(message) {
                        viewModel.fetchAllDishes()
                    }
                case .dataLoaded:
                    mainContent
                }
            }
        }.accentColor(.pink)
        .onAppear {
            viewModel.fetchAllDishes()
        }
    }

    var mainContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        Image("QuickFeatLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                }.padding(.bottom)

                if let allDishes = viewModel.allDishes {
                    // Start Food Category
                    VStack(alignment: .leading) {
                       SectionTitleView(title: "Food Category")
                        // 檢查 categories 是否為空，如果需要的話
                        if !allDishes.categories.isEmpty { // 如果不想在 categories 為空時顯示 ScrollView
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(allDishes.categories) { dish in // 直接使用 allDishes.categories
                                        CategoryView(dish: dish)
                                    }
                                }
                            }.frame(height: 128)
                        } else {
                            // 可選：如果 categories 為空時，顯示一些提示文字
                            // Text("No categories available.")
                        }
                    }.padding(.bottom)
                    // End Food Category

                    // Start Popular (假設 populars 也總是非 nil，如果 allDishes 存在)
                    // 檢查 AllDishes 的定義，populars 和 specials 也是非可選的
                    VStack(alignment: .leading) {
                        SectionTitleView(title: "Popular Dishes")
                        if !allDishes.populars.isEmpty { // 可選檢查
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(allDishes.populars) { dish in
                                        NavigationLink(destination: DishDetailView(dish: dish)) {
                                            PopularDishesView(dish: dish)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }.frame(height: 250)
                        }
                    }.padding(.bottom, 8)
                    // End Popular

                    // Start Recommended
                    SectionTitleView(title: "Recommended")
                    if !allDishes.specials.isEmpty { // 可選檢查
                        LazyVStack {
                            ForEach(allDishes.specials) { dish in
                                RecommendedView(dish: dish)
                            }
                        }
                    }
                    // End Recommended
                }
            }.padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
    }
}



struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
