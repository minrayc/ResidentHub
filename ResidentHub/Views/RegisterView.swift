//
//  RegisterView.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/6/28.
//
import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var userName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @EnvironmentObject private var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (spacing: 20){
            Text("註冊帳號")
                .font(.largeTitle)
                .bold()
            TextField("信箱", text: $email)
                .onChange(of: email) {
                    viewModel.validateEmail(email: email)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("戶名", text: $userName)
                .onChange(of: userName) {
                    viewModel.validateAccount(account: userName)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("密碼", text: $password)
                .onChange(of: password) {
                    viewModel.validatePassword(password: password)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("確認密碼", text: $confirmPassword)
                .onChange(of: confirmPassword) {
                    viewModel.validateConfirmPassword(password: password, confirmPassword: confirmPassword)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                Task {
                    await viewModel.register(userEmail: email, userAccount: userName, password: password, confirmPassword: confirmPassword)
                }
            }) {
                Text("註冊")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!viewModel.errorMessage.isEmpty || email.isEmpty || userName.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            
            Button("返回登入頁") {
                dismiss()
            }
            Spacer()
        }
        .padding(50)
    }
}
