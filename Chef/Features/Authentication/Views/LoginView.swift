//
//  LoginView.swift
//  ChefHelper
//
//  Created by 陳泓齊 on 2025/4/10.
//

//import Firebase
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // App Logo & Title
            Image("QuickFeatLogo")
            // Email Field
            CustomInputField(imageName: "envelope",
                             placeholderText: "Email",
                             textCase: .lowercase,
                             keyboardType: .emailAddress,
                             textContentType: .emailAddress,
                             text: $email)
            CustomInputField(imageName: "lock",
                             placeholderText: "Password",
                             textCase: .lowercase,
                             keyboardType: .default,
                             textContentType: .password,
                             isSecureField: true,
                             text: $password)
        }.padding(32)
            // Forgot Password
//            HStack {
//                Spacer()
//                Button(action: {
//                    // Handle forgot password
//                }) {
//                    Text("Forgot your password?")
//                        .font(.largeTitle)
//                        .foregroundColor(.brandOrange)
//                }
//                .padding(.trailing, 30)
//            }
        Button {
            print("Sign in")
            viewModel.login(withEmail: email, password: password)
        } label: {
            Text("Sign in")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 340, height: 50)
                .background(Color.themeColor)
                .clipShape(Capsule())
                .padding()
        }
        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
//            // Login Button
//            Button {
//                print("Sign in")
//                viewModel.login(withEmail: email, password: password)
//            } label:{
//                Text("LOG IN")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.brandOrange)
//                    .cornerRadius(25)
//            }
//            .padding(.horizontal)

            
            Spacer()
            // Sign UP
            NavigationLink  {
                RegistrationView()
                    .environmentObject(viewModel) 
                    .navigationBarHidden(true)
            } label: {
                    HStack {
                            Text("Don't have an account?")
                                    .font(.footnote)
                                Text("Sign Up")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.bottom, 32)

                    
                    
            
            // Or Divider
//            HStack {
//                Rectangle().frame(height: 1).foregroundColor(.gray).padding(.horizontal)
//                Text("OR").foregroundColor(.brandOrange)
//                Rectangle().frame(height: 1).foregroundColor(.gray).padding(.horizontal)
//            }
//            .padding()
//
//            // Social Media Icons
//            HStack(spacing: 30) {
//                Image(systemName: "f.square") // Replace with actual FB logo
//                Image(systemName: "applelogo")
//                Image(systemName: "globe") // Replace with actual Google logo
//            }
//            .font(.title)
//            .foregroundColor(.brandOrange)
     
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
