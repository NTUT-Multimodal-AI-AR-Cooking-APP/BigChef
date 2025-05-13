//
//  LoginView.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/10.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // App Logo & Title
            Image("QuickFeatLogo")
            // Email Field
            TextField("Email", text: $email)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.brandOrange, lineWidth: 1))
                .padding(.horizontal)

            // Password Field
            SecureField("Password", text: $password)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.brandOrange, lineWidth: 1))
                .padding(.horizontal)

            // Forgot Password
            HStack {
                Spacer()
                Button(action: {
                    
                    // Handle forgot password
                }) {
                    Text("Forgot your password?")
                        .font(.caption)
                        .foregroundColor(.brandOrange)
                }
                .padding(.trailing, 30)
            }

            // Login Button
            Button(action: {
                // Handle login
//                print("\(email)")
            }) {
                Text("LOG IN")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandOrange)
                    .cornerRadius(25)
            }
            .padding(.horizontal)

            // Or Divider
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray).padding(.horizontal)
                Text("OR").foregroundColor(.brandOrange)
                Rectangle().frame(height: 1).foregroundColor(.gray).padding(.horizontal)
            }
            .padding()

            // Social Media Icons
            HStack(spacing: 30) {
                Image(systemName: "f.square") // Replace with actual FB logo
                Image(systemName: "applelogo")
                Image(systemName: "globe") // Replace with actual Google logo
            }
            .font(.title)
            .foregroundColor(.brandOrange)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
