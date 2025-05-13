//
//  HomeBar.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import SwiftUI
struct HomeBar: View {
    let barHeight: CGFloat = 100   // 你實際想要的高度
    var body: some View {
        ZStack(alignment: .leading) {
            BottomBar()
            Button (action:{}){
                Image(systemName:"house.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.brandOrange)
            }
            .offset(x:16, y:-barHeight/2)
            
        }
//        .offset(y:20)
        .background(Color.brandOrange)
//        .ignoresSafeArea(.container, edges: .bottom)
    }
}

//struct HomeBar : View{
//    var body: some View {
//        ZStack(alignment: .leading){
//            Button(action: {}) {
//                Image(systemName: "house.circle.fill")
//                    .font(.system(size: 50))
//                    .foregroundStyle(Color.brandOrange)
//            }
//            .offset(y:-50)
//            BottomBar()
//        }.offset(y: 30)
//    }
//}


private struct HomeBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                // ❸ 內容向上縮 100（依你的 HomeBar 高度調整）
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 100) }

            VStack { Spacer(); HomeBar() }   // ❶ 疊在最底
                .ignoresSafeArea(.container, edges: .bottom)  // ❷ 貼到底
        }
    }
}
extension View {
    /// 讓畫面底部帶有自訂 HomeBar
    func withHomeBar() -> some View { modifier(HomeBarModifier()) }
}
