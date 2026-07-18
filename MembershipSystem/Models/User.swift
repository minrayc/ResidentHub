//
//  User.swift
//  MembershipSystem
//
//  Created by 張閔瑞 on 2026/6/28.
//
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    
    var name: String
    var unit: String
    var phone: String
    var email: String
    var avatarURL: String?
    var isAdmin: Bool
}
