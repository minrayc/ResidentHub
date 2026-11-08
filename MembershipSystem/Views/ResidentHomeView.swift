import SwiftUI
import PhotosUI

struct ResidentHomeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State var isEditing = false
    @State var unit = ""
    @State var name = ""
    @State var phone = ""
    @State var email = ""
    @State var selectedItem: PhotosPickerItem?
    @State var imageData: Data?
    @State var message = ""
    //    @State var previewImage: UIImage?
    var body: some View {
        VStack(spacing: 20) {
            Text("會員資料")
                .font(.largeTitle)
                .bold()
            
            HStack {
                VStack {
                    //頭貼
                    ZStack {
                        // 大頭貼（AsyncImage 或預設圖片）
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else if let avatarURL = viewModel.currentUser?.avatarURL, !avatarURL.isEmpty {
                            // AsyncImage
                            AsyncImage(url: URL(string: viewModel.currentUser?.avatarURL ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            // 預設灰色圖示
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 80, height: 80)
                        }
                        
                        if isEditing {
                            // PhotosPicker 按鈕疊在上面
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("上傳照片")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                            }
                        }
                    }
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                imageData = data
                            }
                        }
                    }
                    .frame(width: 80, height: 80)
                    
                }
                Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 6) {
                    GridRow {
                        Text("戶名").foregroundStyle(.secondary)
                        ProfileField(label: "戶名", value: $unit, isEditing: isEditing)
                    }
                    GridRow {
                        Text("姓名").foregroundStyle(.secondary)
                        ProfileField(label: "姓名", value: $name, isEditing: isEditing)
                    }
                    GridRow {
                        Text("手機").foregroundStyle(.secondary)
                        ProfileField(label: "手機", value: $phone, isEditing: isEditing)
                    }
                    GridRow(alignment: .firstTextBaseline) {
                        Text("信箱").foregroundStyle(.secondary)
                        Text(email)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                
            }
            
            
            //對話匡
            ChatView(residentID: viewModel.currentUser?.id ?? "")
        
        }
        .onAppear() {
            self.unit = self.viewModel.currentUser?.unit ?? ""
            self.name = self.viewModel.currentUser?.name ?? ""
            self.phone = self.viewModel.currentUser?.phone ?? ""
            self.email = self.viewModel.currentUser?.email ?? ""
            viewModel.listenToMessages(uid: viewModel.currentUser?.id ?? "")
        }
        .padding(10)
        //鉛筆編輯按鈕
        .toolbar {
            // 右上：編輯／儲存
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditing {
                        Task {
                            if let imageData {
                                await viewModel.updatePhoto(imageData: imageData)
                            }
                            await viewModel.updateUser(unit: unit, name: name, phone: phone, email: email)
                        }
                    }
                    isEditing.toggle()
                } label: {
                    HStack(spacing: 4) {
                            Image(systemName: isEditing ? "checkmark" : "pencil")
                            Text(isEditing ? "儲存" : "編輯")
                        }
                }
                .tint(isEditing ? .red : .blue)
            }

            // 左上：登出（編輯中不顯示）
            ToolbarItem(placement: .navigationBarLeading) {
                if !isEditing {
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
    }
}

struct ProfileField: View {
    let label: String
    @Binding var value: String
    let isEditing: Bool
    
    var body: some View {
        
        if isEditing {
            TextField(label, text: $value)
                .border(Color.gray)
        } else {
            Text(value)
        }
    }
}
//#Preview {
//    ResidentHomeView()
//        .environmentObject(AuthViewModel())
//}
