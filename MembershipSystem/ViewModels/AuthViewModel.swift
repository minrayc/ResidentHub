//
//  AuthViewModel.swift
//  MembershipSystem
//
//  Created by 張閔瑞 on 2026/6/28.
//
import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLogin: Bool = false
    @Published var currentUser: User?
    @Published var successMessage: String = ""
    @Published var allUsers: [User] = []
    @Published var messages: [Message] = []
    
    func login(userEmail: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: userEmail, password: password)
            if result.user.isEmailVerified {
                let db = Firestore.firestore()
                let document = try await db.collection("users").document(result.user.uid).getDocument()
                let user = try document.data(as: User.self)
                currentUser = user
                isLogin = true
            } else {
                errorMessage = "請先至信箱點擊驗證連結"
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func register(userEmail: String, userAccount: String , password: String, confirmPassword: String) async {
        // TODO: 呼叫 Firebase 註冊
        do {
            let result = try await Auth.auth().createUser(withEmail: userEmail, password: password)
            // 註冊成功，result.user.uid 就是新用戶的 uid
            try await result.user.sendEmailVerification()
            let db = Firestore.firestore()
            try await db.collection("users").document(result.user.uid).setData([
                "name": "",
                "unit": userAccount,
                "phone": "",
                "email": userEmail,
                "avatarURL": "",
                "isAdmin": false
            ])
            successMessage = "註冊成功！請至信箱點擊驗證連結"
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func verifyMail(userEmail: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: userEmail)
            successMessage = "重置密碼信件已發送，請至信箱查詢"
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func validateEmail(email: String) {
        let emailUnitRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailUnitRegex)
        let emailIsValid = emailPredicate.evaluate(with: email)
        //email格式判斷
        guard emailIsValid else {
            errorMessage = "Email格式錯誤"
            return
        }
        errorMessage = ""
    }
    
    func validateAccount(account: String) {
        //帳號格式
        let accountUnitRegex = "^[A-Za-z][0-9]{1,2}$"
        let accountPredicate = NSPredicate(format: "SELF MATCHES %@", accountUnitRegex)
        let accountIsValid = accountPredicate.evaluate(with: account)
        //帳號格式判斷
        guard accountIsValid else {
            errorMessage = "戶名格式錯誤，請輸入一個英文+2位數字的組合"
            return
        }
        errorMessage = ""
    }
    
    func validatePassword(password: String) {
        //密碼格式
        let passwordUnitRegex = "^(?=.*[A-Z])(?=.*[0-9]).{8,12}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordUnitRegex)
        let passwordIsValid = passwordPredicate.evaluate(with: password)
        //密碼格式判斷
        guard passwordIsValid else {
            errorMessage = "密碼格式錯誤，請至少輸入一位大寫英文，並輸入8-12位英文+數字的組合"
            return
        }
        errorMessage = ""
    }
    
    func validateConfirmPassword(password: String, confirmPassword: String) {
        guard password == confirmPassword  else {
            errorMessage = "確認密碼與密碼不一致"
            return
        }
        errorMessage = ""
    }
    
    func updateUser(unit: String, name: String, phone: String, email: String) async {
        guard let uid = currentUser?.id else { return }
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(uid).updateData([
                "unit": unit,
                "name": name,
                "phone": phone,
                "email": email
            ])
            // 更新本地的 currentUser
            currentUser?.unit = unit
            currentUser?.name = name
            currentUser?.phone = phone
            currentUser?.email = email
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updatePhoto(imageData: Data) async {
        guard let uid = currentUser?.id else { return }
        let db = Firestore.firestore()
        do  {
            let storage = Storage.storage()
            let ref = storage.reference().child("avatars/\(currentUser?.id ?? "").jpg")
            _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            try await db.collection("users").document(uid).updateData([
                "avatarURL": url.absoluteString
            ])
        } catch {
            errorMessage = error.localizedDescription
            
        }
        
    }
    
    func fetchUser() async {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("users").getDocuments()
            allUsers = snapshot.documents.compactMap { document in
                try? document.data(as: User.self)
            }.filter { !$0.isAdmin }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func listenToMessages(uid: String) {
        print("目前登入的 UID：", Auth.auth().currentUser?.uid ?? "沒有登入")
        let db = Firestore.firestore()
        db.collection("users").document(uid).collection("messages")
            .order(by: "createdAt")
            .addSnapshotListener { snapshot, error in
                // 每次有新訊息，這裡就會被觸發
                if let error = error {
                        print("讀取訊息失敗：", error.localizedDescription)
                        return
                }
                self.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
                
            }
    }
    
    func sendMessage(message: String, to uid: String) {
        let db = Firestore.firestore()
        let message = Message(
            poster: currentUser?.id ?? "",
            content: message,
            createdAt: Date()
        )
        do {
            try db.collection("users").document(uid).collection("messages").addDocument(from: message)
        } catch {
            
        }
    }
    
    
}
