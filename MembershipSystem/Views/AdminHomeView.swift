import SwiftUI

struct AdminHomeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(filteredUsers) { user in
                NavigationLink {
                    AdminResidentDetailView(user: user)
                } label: {
                    HStack {
                        Text(user.unit)
                        Text(user.name)
                    }
                }
            }
        }
        .navigationTitle("住戶名單")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜尋戶號或姓名")
        .task {
            await viewModel.fetchUser()
        }
        .toolbar {
            // 左上：登出（編輯中不顯示）
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button {
                    viewModel.logout()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("登出")
                    }
                }
                .tint(.red)
                
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
    let viewModel = AuthViewModel()
    viewModel.allUsers = [
        User(id: "1", name: "王小明", unit: "B12", phone: "0912345678", email: "test@test.com", avatarURL: nil, isAdmin: false),
        User(id: "2", name: "陳小美", unit: "C4", phone: "0987654321", email: "test2@test.com", avatarURL: nil, isAdmin: false)
    ]
    return AdminHomeView()
        .environmentObject(viewModel)
}
