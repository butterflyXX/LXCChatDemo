//
//  ChatDBManager.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import Foundation
import WCDBSwift

enum ChatTable: String {
    case userList
    case messageList
}

class ChatDBManager {
    static let shared = ChatDBManager()
    let dbManager = DBManager(dbPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/im.db")
    private init() {
        
        // 创建表
        dbManager.createTable(table: ChatTable.userList.rawValue, itemType: User.self) { error in
            if let err = error {
                NSLog(err.localizedDescription)
            }
        }
        
        dbManager.createTable(table: ChatTable.messageList.rawValue, itemType: DAMessage.self) { error in
            if let err = error as? WCDBError {
                NSLog(err.infos.description)
            }
        }
    }
    
    func insertUser(user: User, completion: ValueChanged<Error?>? = nil) {
        dbManager.insertOrReplace(table: ChatTable.userList.rawValue, items: [user]) { error in
            run {completion?(error)}}
        }
    
    func updateUser(user: User, completion: ValueChanged<Error?>? = nil) {
        dbManager.update(table: ChatTable.userList.rawValue, item: user, on: User.Properties.all, where: User.Properties.userId == user.userId) { error in
            run {completion?(error)}
        }
    }
    
    func getUserList(completion: @escaping ValueChanged<[User]?>) {
        dbManager.getObjects(table: ChatTable.userList.rawValue, on: User.Properties.all) { list in
            run {completion(list)}
        }
    }
    
    func insertMessage(message: DAMessage, completion: ValueChanged<Error?>? = nil) {
        dbManager.insertOrReplace(table: ChatTable.messageList.rawValue, items: [message]) { error in
            run {completion?(error)}
        }
    }
    
    func updateMessage(message: DAMessage, completion: ValueChanged<Error?>? = nil) {
        dbManager.update(table: ChatTable.userList.rawValue, item: message, on: DAMessage.Properties.all, where: DAMessage.Properties.messageId == message.messageId) { error in
            run {completion?(error)}
        }
    }
    
    func getMessageList(completion: @escaping ValueChanged<[DAMessage]?>) {
        dbManager.getObjects(table: ChatTable.messageList.rawValue, on: DAMessage.Properties.all) { list in
            run {completion(list)}
        }
    }
}
