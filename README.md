# ResidentHub：社區住戶管理

> 為社區住戶而生的App：住戶管理自己的會員資料、與管理員一對一傳訊息；管理員查看所有住戶，並與每位住戶個別對話。




<p align="center">
  <img src="Screenshots/01.png" width="240">
  <img src="Screenshots/02.png" width="240">
  <img src="Screenshots/03.png" width="240">
  <img src="Screenshots/04.png" width="240">
  <img src="Screenshots/05.png" width="240">
  <img src="Screenshots/06.png" width="240">
  <img src="Screenshots/07.png" width="240">
</p>


## 功能

**住戶**
- 註冊、Email 驗證、登入、忘記密碼
- 會員資料編輯（戶名、姓名、手機）與大頭貼上傳
- 與管理員一對一即時訊息（訊息標示發送者與時間）
- App 內刪除帳號（連同個人資料、大頭貼、所有訊息一併刪除）

**管理員**
- 住戶名單與搜尋（戶號、姓名）
- 查看住戶資料，並與每位住戶一對一對話
- 多位管理員時，訊息會標示是哪一位管理員發送

## 技術

| 類別 | 使用技術 |
|---|---|
| 語言 / UI | Swift、SwiftUI |
| 架構 | MVVM |
| 後端 | Firebase |
| 最低版本 | iOS 17 |

## 資料結構

```
users/{uid}                 // 住戶或管理員的資料
  ├─ unit, name, phone, email, avatarURL, isAdmin
  └─ messages/{messageId}   // 這位住戶與管理員之間的一對一訊息
       └─ poster, posterLabel, content, createdAt

avatars/{uid}.jpg           // Cloud Storage：大頭貼
```

## 安全性設計

權限控制寫在**伺服器端的安全規則**，而不是只在 App 裡限制：
- 使用者只能讀寫**自己的**資料；管理員可以讀取所有住戶
- 註冊時不能把自己設成管理員，也不能事後把 `isAdmin` 改成 `true`（防止權限提升）
- 訊息的 `poster` 必須等於登入者本人，無法冒用他人身分發送
- 大頭貼只能上傳到自己的路徑，限定圖片格式且小於 2MB

## 作者

張閔瑞（Tim）

📧 minrayc@gmail.com
