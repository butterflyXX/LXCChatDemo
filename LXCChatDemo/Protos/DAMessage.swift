//
//  DAMessage.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/31.
//

import Foundation
import YYModel
import WCDBSwift

// 消息状态
enum DAMessageReadStatus: String {
    case sending   // 发送中
    case success  // 发送成功
    case failed   // 发送失败
    static func fromValue(_ value: String) -> DAMessageReadStatus? {
        return DAMessageReadStatus(rawValue: value)
    }
}

enum DAMessageType: String {
    case text
    
    static func fromValue(_ value: String) -> DAMessageType? {
        return DAMessageType(rawValue: value)
    }
    
    static func contentClass(rawValue: String) -> AnyClass {
        switch rawValue {
        case Self.text.rawValue:
            return DAMessageText.self
        default:
            return DAMessageContent.self
        }
    }
}

final class DAMessage: NSObject, TableCodable {
    var messageId: String = ""
    var from: String = ""
    var to: String = ""
    var type: String = ""
    var status: String = ""
    var createTime: Int64 = Int64(Date().timeIntervalSince1970)
    var content: DAMessageContent?
    
    var readStatus: DAMessageReadStatus {DAMessageReadStatus.fromValue(status) ?? .sending}
    var msgType: DAMessageType? {DAMessageType.fromValue(type)}
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DAMessage
        case messageId
        case from
        case to
        case type
        case status
        case createTime
        case content
        
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
        from = finalMsg.from
        to = finalMsg.to
        type = finalMsg.type
        status = finalMsg.status
        createTime = finalMsg.createTime
        if let clazz = DAMessageType.contentClass(rawValue: finalMsg.type) as? DAMessageContent.Type {
            content = clazz.init(data: finalMsg.content)
        }
    }
    
    func toData() -> Data? {
        var msg = DA_Message()
        msg.messageID = messageId
        msg.from = from
        msg.to = to
        msg.type = type
        msg.status = status
        msg.createTime = createTime
        if let data = content?.toData() {
            msg.content = data
        }
        return msg.toData()
    }
}

class DAMessageContent: Codable {
    
    /// 发送消息时使用的消息创建方法
    required init() {}
    
    /// 接收消息时使用的消息创建方法
    required init(data: Data) {}
    
    /// 转化为proto数据
    func toData() -> Data? {nil}
    
    /// 子类必须重写指定消息类型
    var msgType: DAMessageType {.text}
}

class DAMessageText: DAMessageContent {
    var text: String?
    
    public enum CodingKeys: String, CodingKey {
        // key 映射
        case text
    }
    
    init(text: String) {
        self.text = text
        super.init()
    }
    
    required init(data: Data) {
        var msg: DA_Text?
        do {
            msg = try DA_Text(serializedBytes: data)
        } catch _ as NSError {}
        text = msg?.text ?? ""
        super.init(data: data)
    }
    
    required init(from decoder: Decoder) {
        
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let text = try container.decodeIfPresent(String.self, forKey: .text) {
                self.text = text
            }
        } catch _ {}
        
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
    }
    
    override var msgType: DAMessageType {.text}
    
    override func toData() -> Data? {
        var msg = DA_Text()
        msg.text = text ?? ""
        return msg.toData()
    }
}
