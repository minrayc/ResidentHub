//
//  ContentView.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/6/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.currentUser == nil {
                NavigationStack { LoginView() }
            } else if authViewModel.currentUser?.isAdmin == true {
                NavigationStack { AdminHomeView() }
            } else {
                NavigationStack { ResidentHomeView() }
            }
        }
        .environmentObject(authViewModel)
        .overlay(alignment: .top) {
                if !authViewModel.toastMessage.isEmpty {
                    Text(authViewModel.toastMessage)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: authViewModel.toastMessage)
            .task(id: authViewModel.toastMessage) {
                guard !authViewModel.toastMessage.isEmpty else { return }
                try? await Task.sleep(for: .seconds(2))
                authViewModel.toastMessage = ""
            }
    }
}

#Preview {
    ContentView()
}
