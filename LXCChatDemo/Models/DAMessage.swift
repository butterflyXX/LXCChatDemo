//
//  DAMessage.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/1.
//

import WCDBSwift
import Foundation

final class DAMessage: NSObject, TableCodable {
    var messageId: String = ""
    var fromId: String = ""
    var toId: String = ""
    var type: String = ""
    var status: String = ""
    var createTime: Int64 = Int64(Date().timeIntervalSince1970)
    var contentString: String?
    
    var readStatus: DAMessageReadStatus {DAMessageReadStatus.fromValue(status) ?? .sending}
    var msgType: DAMessageType? {DAMessageType.fromValue(type)}
    var content: DAMessageContent? {
        set {
            contentString = newValue?.toJsonString()
        }
        get {
            getContent()
        }
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DAMessage
        case messageId
        case fromId
        case toId
        case type
        case status
        case createTime
        case contentString
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(messageId, isPrimary: true)
        }
    }
    
    override init() {}
    
    init(data: Data) {
        var msg: DA_Message?
        do {
            msg = try DA_Message(serializedBytes: data)
        } catch _ as NSError {}
        
        let finalMsg = msg ?? DA_Message()
        messageId = finalMsg.messageID
        fromId = finalMsg.from
        toId = finalMsg.to
        type = finalMsg.type
        status = finalMsg.status
        createTime = finalMsg.createTime
        if let clazz = DAMessageType.contentClass(rawValue: finalMsg.type) as? DAMessageContent.Type {
            contentString = clazz.init(data: finalMsg.content).toJsonString()
        }
    }
    
    func getContent() -> DAMessageContent? {
        if let jsonString = contentString, let clazz = DAMessageType.contentClass(rawValue: type) as? DAMessageContent.Type {
            return clazz.yy_model(withJSON: jsonString)
        }
        return nil
    }
    
    func toData() -> Data? {
        var msg = DA_Message()
        msg.messageID = messageId
        msg.from = fromId
        msg.to = toId
        msg.type = type
        msg.status = status
        msg.createTime = createTime
        if let data = content?.toData() {
            msg.content = data
        }
        return msg.toData()
    }
}
