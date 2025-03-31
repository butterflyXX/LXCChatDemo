//
//  User.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import WCDBSwift
import Foundation

final class User: TableCodable {
    var userId: String = ""
    var nickname: String = ""
    var avatar: String = ""
    var lastMessageTime: Int64 = Int64(Date().timeIntervalSince1970)
    var lastMessageString: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = User
        case userId
        case nickname
        case avatar
        case lastMessageTime
        case lastMessageString
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(userId, isPrimary: true)
        }
    }
}
