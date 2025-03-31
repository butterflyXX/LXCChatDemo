//
//  Message+Extension.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/31.
//

import SwiftProtobuf

extension Message {
    func toData() -> Data? {
        do {
            return try serializedData()
        } catch _ {
            return nil
        }
    }
}
