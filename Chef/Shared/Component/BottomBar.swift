//
//  BottomBar.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/5/4.
//
import SwiftUI

struct BottomBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                print("第一個 icon 被點了")
            }) {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                print("第二個 icon 被點了")
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                print("第三個 icon 被點了")
            }) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.vertical, 14)
//        .frame(maxWidth: .infinity)
        .background(Color.brandOrange)
    }
}
