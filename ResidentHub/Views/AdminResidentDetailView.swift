//
//  AdminResidentDetailView.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/7/21.
//
import SwiftUI

struct AdminResidentDetailView: View {
    let user: User
    
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
                        if let avatarURL = user.avatarURL, !avatarURL.isEmpty {
                            // AsyncImage
                            AsyncImage(url: URL(string: avatarURL)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                case .failure(let error):
                                    Image(systemName: "exclamationmark.triangle")
                                        .onAppear { print("大頭貼載入失敗：", error.localizedDescription) }
                                @unknown default:
                                    EmptyView()
                                }
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
                        
                    }
                    .frame(width: 80, height: 80)
                    
                }
                Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 6) {
                    GridRow {
                        Text("戶名").foregroundStyle(.secondary)
                        Text(user.unit)
                    }
                    GridRow {
                        Text("姓名").foregroundStyle(.secondary)
                        Text(user.name)
                    }
                    GridRow {
                        Text("手機").foregroundStyle(.secondary)
                        Text(user.phone)
                    }
                    GridRow(alignment: .firstTextBaseline) {
                        Text("信箱").foregroundStyle(.secondary)
                        Text(user.email)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
            
            //對話匡
            ChatView(residentID: user.id ?? "")
        }
        .padding(10)
    }
}
