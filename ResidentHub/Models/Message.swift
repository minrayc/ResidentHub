//
//  Message.swift
//  ResidentHub
//
//  Created by 張閔瑞 on 2026/7/29.
//
import FirebaseFirestore

struct Message: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    let poster: String
    var posterLabel: String?
    let content: String
    let createdAt: Date
}
