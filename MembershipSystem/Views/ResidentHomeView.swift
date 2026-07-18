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
//    @State var previewImage: UIImage?
    var body: some View {
        VStack(spacing: 20) {
            Text("會員資料")
                .font(.largeTitle)
                .bold()
            HStack {
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
                    VStack(alignment: .leading) {
                        HStack  {
                            Text("戶名：")
                            ProfileField(label: "戶名", value: $unit, isEditing: isEditing)
                        }
                        HStack  {
                            Text("姓名：")
                            ProfileField(label: "姓名", value: $name, isEditing: isEditing)
                        }
                        HStack  {
                            Text("手機：")
                            ProfileField(label: "手機", value: $phone, isEditing: isEditing)
                        }
                        HStack  {
                            Text("信箱：\(email)")
                            //                            ProfileField(label: "信箱", value: $email, isEditing: isEditing)
                        }
                        
                    }
                    
                }
            }
            
            //對話匡
            Spacer()
        }
        .onAppear() {
            self.unit = self.viewModel.currentUser?.unit ?? ""
            self.name = self.viewModel.currentUser?.name ?? ""
            self.phone = self.viewModel.currentUser?.phone ?? ""
            self.email = self.viewModel.currentUser?.email ?? ""
        }
        .padding(50)
        //鉛筆編輯按鈕
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        Task {
                            // 如果有新圖片，先上傳
                            if let imageData {
                                await viewModel.updatePhoto(imageData: imageData)
                            }
                            await viewModel.updateUser(unit: unit, name: name, phone: phone, email: email)
                        }
                    }
                    isEditing.toggle()
                }) {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                        .foregroundColor(isEditing ? .red : .blue)
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
        // 你來寫
        
        if isEditing {
            TextField(label, text: $value)
                .border(Color.gray)
        } else {
            Text(value)
        }
    }
}
#Preview {
    ResidentHomeView()
}
