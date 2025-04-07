//
//  IMManager.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/4/7.
//

import MQTTClient

class Topics {
    static let chatTopic = "chat"
    static let userTopic = "user"
    static let systemTopic = "system"
}

class IMManager: NSObject {
    static let shared = IMManager()
    private override init() {}
    
    var serverModel: ServerModel?
    
    var keepLive = 60
    
    var userId: String = ""
    
    var clientId = ""
    
    var dbManager: ChatDBManager?
    
    lazy var mqttManager: MQTTSessionManager = {
        let manager = MQTTSessionManager()
        manager.delegate = self
        return manager
    }()
    
    
    
    func setupSDK(userId: String, clientId: String, server: ServerModel, keepLive: Int) {
        serverModel = server
        self.userId = userId
        self.keepLive = keepLive
        self.clientId = clientId
        dbManager = ChatDBManager(userId: userId)
    }
    
    func preSaveMessage(targetId: String, message: DAMessage) {
        message.fromId = ""
        message.toId = targetId
        message.sendStatus = .sending
        
        dbManager?.insertMessage(message: message)
    }
    
    func connect(connectHandler: MQTTConnectHandler? = nil) {
        if let server = serverModel {
            mqttManager.connect(to: server.ip,
                                port: server.port,
                                tls: false,
                                keepalive: keepLive,
                                clean: true,
                                auth: false,
                                user: nil,
                                pass: nil,
                                will: false,
                                willTopic: nil,
                                willMsg: nil,
                                willQos: .atLeastOnce,
                                willRetainFlag: false,
                                withClientId: nil,
                                securityPolicy: nil,
                                certificates: nil,
                                protocolLevel: .version311,
                                connectHandler: connectHandler)
        }
        
    }
    
    private func subscribeToTopics() {
        mqttManager.subscriptions = [
            Topics.chatTopic + "/#": 2,
            Topics.userTopic + "/#": 2,
            Topics.systemTopic + "/#": 2,
        ]
    }
    
    func sendMessage(_ message: DAMessage) {
        let topic = "\(Topics.chatTopic)/\(message.fromId)/\(message.toId)"
        
        if let data = message.toData() {
            mqttManager.session.publishData(data, onTopic: topic, retain: false, qos: .exactlyOnce)
        }
    }
    
    func sendUserStatus(userId: String, onLine: Bool) {
        let topic = "\(Topics.userTopic)/\(userId)/status"
        var statusModel = L_Status()
        statusModel.onLine = onLine
        if let data = statusModel.toData() {
            mqttManager.session.publishData(data, onTopic: topic, retain: true, qos: .exactlyOnce)
        }
    }
    
    // MARK: - Private Methods
    private func handleMessage(_ data: Data, topic: String) {
        // 解析消息
        
    }
    
    private func handleUserStatus(_ data: Data, topic: String) {
        // 解析用户状态
    }
    
    func disconnect() {
        mqttManager.disconnect { error in
            
        }
    }
}

extension IMManager: MQTTSessionManagerDelegate {
    func sessionManager(_ sessionManager: MQTTSessionManager!, didReceiveMessage data: Data!, onTopic topic: String!, retained: Bool) {
        // 处理接收到的消息
        if topic.hasPrefix("\(Topics.chatTopic)/") {
            handleMessage(data, topic: topic)
        } else if topic.hasPrefix("\(Topics.userTopic)/") {
            handleUserStatus(data, topic: topic)
        }
    }
    
    func sessionManager(_ sessionManager: MQTTSessionManager!, didChange newState: MQTTSessionManagerState) {
        switch newState {
        case .connected:
            print("MQTT已连接")
//            connectionHandler?(true)
            subscribeToTopics()
        case .connecting:
            print("MQTT正在连接")
        case .closed:
            print("MQTT已关闭")
//            connectionHandler?(false)
        case .error:
            print("MQTT错误")
//            connectionHandler?(false)
        default:
            break
        }
    }
}
