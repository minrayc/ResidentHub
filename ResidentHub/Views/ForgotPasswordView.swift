//
//  ForgotPasswordView.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/6/28.
//
import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email = ""
    @EnvironmentObject private var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (spacing: 20){
            Text("忘記密碼")
                .font(.largeTitle)
                .bold()
            TextField("請輸入註冊電子郵件地址", text: $email)
                .onChange(of: email) {
                    viewModel.validateEmail(email: email)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            Button(action: {
                Task {
                    await viewModel.verifyMail(userEmail: email)
                }
            }) {
                Text("發送重設密碼連結")
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!viewModel.errorMessage.isEmpty || email.isEmpty)
            Button("返回登入頁") {
                dismiss()
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            if !viewModel.successMessage.isEmpty {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }
            Spacer()
        }
        .padding(50)
    }
}
