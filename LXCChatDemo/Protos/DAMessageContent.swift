//
//  DAMessageContent.swift
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

class DAMessageContent: NSObject, YYModel {
    
    /// 接收消息时使用的消息创建方法
    required init(data: Data) {}
    
    /// 转化为proto数据
    func toData() -> Data? {nil}
    
    /// 子类必须重写指定消息类型
    var msgType: DAMessageType {.text}
    
    func toJsonString() -> String? {
        return self.yy_modelToJSONString()
    }
}

class DAMessageText: DAMessageContent {
     var text: String?
    
    required init(data: Data) {
        var msg: DA_Text?
        do {
            msg = try DA_Text(serializedBytes: data)
        } catch _ as NSError {}
        text = msg?.text ?? ""
        super.init(data: data)
    }
    
    override var msgType: DAMessageType {.text}
    
    override func toData() -> Data? {
        var msg = DA_Text()
        msg.text = text ?? ""
        return msg.toData()
    }
}
