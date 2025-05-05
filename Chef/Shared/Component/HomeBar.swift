//
//  HomeBar.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//

import SwiftUI

struct HomeBar : View{
    var body: some View {
        ZStack(alignment: .leading){
            Button(action: {}) {
                Image(systemName: "house.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.brandOrange)
            }
            .offset(y:-50)
            BottomBar()
        }.offset(y: 30)
    }
}
