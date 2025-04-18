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
    var dbManager: DBManager
    init(userId: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        dbManager = DBManager(dbPath: path + "/im/\(userId)/storage.db")
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
    
    func getUserList(count: Int? = nil, completion: @escaping ValueChanged<[User]?>) {
        dbManager.getObjects(table: ChatTable.userList.rawValue,
                             on: User.Properties.all,
                             orderBy: [User.Properties.lastMessageTime.order(.descending)],
                             limit: count) { list in
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
    
    func getMessageList(userId: String, createTime: Double? = nil, count: Int? = nil, completion: @escaping ValueChanged<[DAMessage]?>) {
        
        var max = createTime ?? Date().timeIntervalSince1970
        if (max < 0) {
            max = Date().timeIntervalSince1970
        }
        let exp = DAMessage.Properties.toId == userId && DAMessage.Properties.createTime < max
        
        dbManager.getObjects(table: ChatTable.messageList.rawValue,
                             on: DAMessage.Properties.all,
                             where: exp,
                             orderBy: [DAMessage.Properties.createTime.order(.descending)],
                             limit: count
        ) { list in
            run {completion(list)}
        }
    }
}
