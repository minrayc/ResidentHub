import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(filteredUsers) { user in
                    HStack {
                        Text(user.unit)
                        Text(user.name)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("住戶名單")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .onAppear {
            Task {
                await viewModel.fetchUser()
            }
        }
    }
    
    // MARK: - Filtering
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.allUsers
        } else {
            return viewModel.allUsers.filter { user in
                user.unit.contains(searchText) || user.name.contains(searchText)
            }
        }
    }
}

#Preview {
    AdminHomeView()
}
