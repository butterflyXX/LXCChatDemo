//
//  ChatDBManager.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

enum ChatTable: String {
    case userList
    case messageList
}

class ChatDBManager {
    static let shared = ChatDBManager()
    private init() {}
    
    // MARK: - userList 操作
    func createUserListTable() {
        
    }
}
