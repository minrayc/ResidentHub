//
//  ContentView.swift
//  MembershipSystem
//
//  Created by 張閔瑞 on 2026/6/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        
        NavigationStack {
            if authViewModel.currentUser == nil {
                LoginView()
            } else if authViewModel.currentUser?.isAdmin == true {
                AdminHomeView()
            } else {
                ResidentHomeView()
            }
        }
        .environmentObject(authViewModel)
        

    }
}

#Preview {
    ContentView()
}
