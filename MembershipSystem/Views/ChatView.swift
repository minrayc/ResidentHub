//
//  ChatView.swift
//  MembershipSystem
//
//  Created by 張閔瑞 on 2026/11/8.
//
import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    let residentID: String          // 這是「哪一位住戶」的對話
    @State private var text = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages) { message in
                    let isMe = message.poster == viewModel.currentUser?.id
                    HStack {
                        if isMe { Spacer() }
                        VStack(alignment: isMe ? .trailing : .leading) {
                            Text(message.content)
                                .padding(10)
                                .background(isMe ? Color.green : Color.gray.opacity(0.2))
                                .foregroundColor(isMe ? .white : .black)
                                .cornerRadius(12)
                            Text(message.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        if !isMe { Spacer() }
                    }
                }
            }
            .frame(maxHeight: .infinity)

            HStack {
                TextField("請輸入文字", text: $text)
                    .padding(2)
                Button("X") { text = "" }
                Button {
                    viewModel.sendMessage(message: text, to: residentID)
                    text = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                }
                .disabled(text.isEmpty)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .onAppear {
            viewModel.listenToMessages(uid: residentID)
        }
        .onDisappear {
            viewModel.stopListeningToMessages()
        }
    }
}
