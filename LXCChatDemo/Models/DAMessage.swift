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
    var sendStatusString: String = ""
    var createTime: Double = Date().timeIntervalSince1970
    var contentString: String?
    
    var sendStatus: DAMessageSendStatus {
        set {
            sendStatusString = newValue.rawValue
        }
        get {
            DAMessageSendStatus.fromValue(sendStatusString) ?? .sending
        }
    }
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
        case sendStatusString
        case createTime
        case contentString
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(messageId, isPrimary: true)
        }
    }
    
    override init() {}
    
    init(data: Data) {
        var msg: L_Message?
        do {
            msg = try L_Message(serializedBytes: data)
        } catch _ as NSError {}
        
        let finalMsg = msg ?? L_Message()
        messageId = finalMsg.messageID
        fromId = finalMsg.from
        toId = finalMsg.to
        type = finalMsg.type
        sendStatusString = finalMsg.status
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
        var msg = L_Message()
        msg.messageID = messageId
        msg.from = fromId
        msg.to = toId
        msg.type = type
        msg.status = sendStatusString
        msg.createTime = createTime
        if let data = content?.toData() {
            msg.content = data
        }
        return msg.toData()
    }
}
