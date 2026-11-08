//
//  LoginView.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/6/28.
//
import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        VStack (spacing: 20){
            HStack {
                //房子圖片icon
                Text("住戶登入")
                    .font(.largeTitle)
                    .bold()
            }
            
            VStack (spacing: 20){
                TextField("請輸入信箱", text: $email)
                    .onChange(of: email) {
                        viewModel.validateEmail(email: email)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("請輸入密碼", text: $password)
                    .onChange(of: password) {
                        viewModel.validatePassword(password: password)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                Task {
                    await viewModel.login(userEmail: email, password: password)
                }
            }) {
                Text("登入")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!viewModel.errorMessage.isEmpty || email.isEmpty || password.isEmpty)
            HStack {
                Spacer()
                NavigationLink("註冊帳號") {
                    RegisterView()
                }
                Text("/")
                    .foregroundColor(Color.blue)
                NavigationLink("忘記密碼") {
                    ForgotPasswordView()
                }
                
            }
            
            Spacer()
            
        }
        .padding(50)
    }
}

//#Preview {
//    LoginView()
//        .environmentObject(AuthViewModel())
//}
